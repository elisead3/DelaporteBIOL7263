install.packages(c("sp","rgdal","raster","rgeos","geosphere","dismo"))

library(sp) # classes for vector data (polygons, points, lines)
library(rgdal) # basic operations for spatial data
library(raster) # handles rasters
library(rgeos) # methods for vector files
library(geosphere) # more methods for vector files
library(dismo) # species distribution modeling tools

bio1<- raster("WORLDCLIM_Rasters/wc2.1_10m_bio_1.tif")
plot(bio1) 

#Displaying meta data of plot
bio1

#changing temperatures on plot from C to F
bio1_f <- bio1 * (9/5)+32
plot(bio1_f)

#Creating a stack of rasters
clim_stack <- stack(list.files("WORLDCLIM_Rasters", full.names = TRUE, pattern = ".tif"))

plot(clim_stack, nc = 5) # nc plots five columns of the 19 rasters

plot(clim_stack[[19]], nc = 5) #plot just one of the rasters

clim_stack

list.files("WORLDCLIM_Rasters", full.names = TRUE, pattern = ".tif") #list raster file names

my_clim_stack <- stack(
  raster('WORLDCLIM_Rasters/wc2.1_10m_bio_5.tif'),
  raster('WORLDCLIM_Rasters/wc2.1_10m_bio_7.tif'),
  raster('WORLDCLIM_Rasters/wc2.1_10m_bio_12.tif')
)
#Look up the variable on https://www.worldclim.org/data/bioclim.html and rename the variable with a more descriptive name.  
names(my_clim_stack) <- c("max_hot_temp", "temp_annual_range", "annual_precipitation")

plot(my_clim_stack)

#plot bivariate relationships among climate variables
pairs(my_clim_stack)

#load country shape files

countries <- shapefile("Country_Shapefiles/ne_10m_admin_0_countries.shp")
countries

plot(countries, col="goldenrod")

dev.new() #new window for plot
plot(my_clim_stack[[2]]) # plot mean annual temperature
plot(countries, add=TRUE) # add countries shapefile

my_sites <- as.data.frame(click(n=3)) #and then click on map in new window to select the points

names(my_sites) <- c('long', 'lat')
my_sites

#Extracting values from the rasters at each of our points
env <- as.data.frame(extract(my_clim_stack, my_sites))
env

# join environmental data and your site data
my_sites <- cbind(my_sites, env)
my_sites

#create a shape file of my sites
#get the projection from the raster file
myCrs <- projection(my_clim_stack)

# apply that projection to our points to create a shapefile

my_sites_shape <- SpatialPointsDataFrame(coords = my_sites, data = my_sites, proj4string = CRS(myCrs))

plot(my_clim_stack[[2]])
plot(countries, add=TRUE)
points(my_sites_shape, pch=16) # show sites on the map

#generate set of random points for comparison to our selected locations

bg <- as.data.frame(randomPoints(my_clim_stack, n = 10000))
head(bg)

names(bg) <- c("long", "lat")
head(bg)

plot(my_clim_stack[[2]])
points (bg, pch = ".")

#extract our types of climate data from random points
bgEnv <- as.data.frame(extract(my_clim_stack, bg))
head(bgEnv)

bg <- cbind(bg, bgEnv)
head(bg)

my_sites_fixed <- my_sites[,1:5]

#train the model - ones and zeroes for the presence of absence
pres_bg <- c(rep(1, nrow(my_sites_fixed)), rep(0, nrow(bg)))

pres_bg

train_data <- data.frame (pres_bg = pres_bg, rbind(my_sites_fixed, bg))

#We will use a generalized linear model (glm) with pres_bg as the dependent variable and our climate variables as independent variables. Since this is a binary outcome and quadratic model provides a good starting point.

my_model <- glm(
  pres_bg ~ max_hot_temp*temp_annual_range*annual_precipitation + I(temp_annual_range^2) + I(max_hot_temp^2) + I(annual_precipitation^2),
  data=train_data,
  family='binomial',
  weights=c(rep(1, nrow(my_sites_fixed)), rep(nrow(my_sites_fixed) / nrow(bg), nrow(bg)))
)
#assigned a weight of 1 to all of our points, and then take the number of our points divided by the number of random points (so the sum of the weights of our points and the random points are equal - otherwise the model will favor the random points)

summary(my_model)

#We will ignore the warning and we are not going to put to much stock in the statistical significance of the variables in the model. Our glm does not account for spatial autocorrelation, so these are likely inflated. However, we can use the model to make useful predictions and characterize suitable habitat given our selected points.

#use model to predict climate niche
my_world <- predict(
  my_clim_stack,
  my_model,
  type='response'
)
#raster created for our model now. It predicted a value between 0 and 1 for that model. 1 would be matches my climate niche

my_world

plot(my_world)
plot(countries, add=TRUE)
points(my_sites_shape, col='red', pch=16)
# threshold your "preferred" climate

my_world_thresh <- my_world >= quantile(my_world, 0.75)
plot(my_world_thresh)

writeRaster(my_world, 'My_Climate_Space/my_world', format='GTiff', overwrite=TRUE, progress='text') #saved as my_world.tif in My_Climate_Space folder

# convert all values not equal to 1 to NA...
# using "calc" function to implement a custom function
my_world_thresh <- calc(my_world_thresh, fun=function(x) ifelse(x==0 | is.na(x), NA, 1))

# get random sites
my_best_sites <- randomPoints(my_world_thresh, 10000)
my_best_env <- as.data.frame(extract(my_clim_stack, my_best_sites))

# plot world's climate
smoothScatter(x=bgEnv$annual_precipitation, y=bgEnv$temp_annual_range, col='lightblue')
points(x=my_best_env$annual_precipitation, y=my_best_env$temp_annual_range, col='red', pch=16, cex=0.2)
points(my_sites_fixed$annual_precipitation, my_sites_fixed$temp_annual_range, pch=16)
legend(
  'bottomright',
  inset=0.01,
  legend=c('world', 'my niche', 'my locations'),
  pch=16,
  col=c('lightblue', 'red', 'black'),
  pt.cex=c(1, 0.4, 1)
)



