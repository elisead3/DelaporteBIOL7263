install.packages("geomorph", dependencies = TRUE)

library(geomorph)

filelist <- list.files(pattern = "*.jpeg")

digitize2d(filelist, nlandmarks = 11, scale = 3, tpsfile = "shrimp3.tps", verbose = TRUE)

mydata <- readland.tps("shrimp3.tps", specID= "ID")
Y.gpa <- gpagen(mydata, print.progress = FALSE)

ref <- mshape(Y.gpa$coords)

plotRefToTarget(ref, Y.gpa$coords[,,2], method="TPS") #takes landmark data and plots its
plotRefToTarget(ref, Y.gpa$coords[,,2], mag=3, method="TPS") #magnifies difference between reference and target by 3x
plotRefToTarget(ref, Y.gpa$coords[,,2], mag=3, method="vector") #shows displacement between target and reference sequence using vector methods. Arrows show direction of displacement
plotRefToTarget(ref, Y.gpa$coords[,,2], mag=3, method="points") #plots reference and target landmark data

plotAllSpecimens(Y.gpa$coords, label=T, plot.param = list(pt.bg = "green", mean.cex=1, link.col= "red", txt.pos=3, txt.cex=1))


