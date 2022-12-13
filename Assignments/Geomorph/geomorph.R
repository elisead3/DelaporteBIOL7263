library(geomorph)

# list of .jpg files in current working directory
filelist <- list.files(pattern = "*.jpg")

# adding landmarks to flower images
digitize2d(filelist, nlandmarks = 11, scale = 3, tpsfile = "flower.tps", verbose = TRUE)

# creates a data file from the points
mydata <- readland.tps("flower.tps", specID= "ID")
Y.gpa <- gpagen(mydata, print.progress = FALSE)

ref <- mshape(Y.gpa$coords)

# plotting landmark data
plotRefToTarget(ref, Y.gpa$coords[,,2], method="TPS") #takes landmark data and plots it
plotRefToTarget(ref, Y.gpa$coords[,,2], mag=3, method="TPS") #magnifies difference between reference and target by 3x
plotRefToTarget(ref, Y.gpa$coords[,,2], mag=3, method="vector") #shows displacement between target and reference sequence using vector methods. Arrows show direction of displacement
plotRefToTarget(ref, Y.gpa$coords[,,2], mag=3, method="points") #plots reference and target landmark data

plotAllSpecimens(Y.gpa$coords, label=T, plot.param = list(pt.bg = "green", mean.cex=1, link.col= "red", txt.pos=3, txt.cex=1))


