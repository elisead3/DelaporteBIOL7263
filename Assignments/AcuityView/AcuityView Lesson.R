install.packages("magrittr")
install.packages("AcuityView")
install.packages("imager")
install.packages("fftwtools")
library("AcuityView")
library("fftwtools")
library("imager")

img <- load.image('fish.jpg')
dim(img)
img <- resize(img, 512, 512)
AcuityView(photo = img, distance = 2, realWidth = 2, eyeResolutionX = 8.14, eyeResolutionY = NULL, plot = T, output = "fish.jpg" )

# mouse-eye view of a cat. Distance unit is meters for both distance and width
img <- load.image('cat.jpg')
img <- resize(img, 512, 512)
AcuityView(photo = img, distance = 1, realWidth = 0.3, eyeResolutionX = 2, eyeResolutionY = NULL, plot = T, output = "Assignments/AcuityView/catmouse1.jpg" )
AcuityView(photo = img, distance = 2, realWidth = 0.3, eyeResolutionX = 2, eyeResolutionY = NULL, plot = T, output = "Assignments/AcuityView/catmouse2.jpg" )
AcuityView(photo = img, distance = 3, realWidth = 0.3, eyeResolutionX = 2, eyeResolutionY = NULL, plot = T, output = "Assignments/AcuityView/catmouse3.jpg" )


# eagle-eye view of a mouse
img <- load.image('mouse.jpg')
img <- resize(img, 512, 512)
AcuityView(photo = img, distance = 1, realWidth = 0.15, eyeResolutionX = 0.00714285714, eyeResolutionY = NULL, plot = T, output = "mouse1.jpg" )
AcuityView(photo = img, distance = 2, realWidth = 0.15, eyeResolutionX = 0.00714285714, eyeResolutionY = NULL, plot = T, output = "mouse2.jpg" )
AcuityView(photo = img, distance = 3, realWidth = 0.5, eyeResolutionX = 0.00714285714, eyeResolutionY = NULL, plot = T, output = "mouse3.jpg" )

# fly's view of a web
img <- load.image('spiderweb.jpg')
img <- resize(img, 512, 512)
AcuityView(photo = img, distance = 1, realWidth = 0.3, eyeResolutionX = 11, eyeResolutionY = NULL, plot = T, output = "web1.jpg" )
AcuityView(photo = img, distance = 2, realWidth = 0.3, eyeResolutionX = 11, eyeResolutionY = NULL, plot = T, output = "web2.jpg" )
AcuityView(photo = img, distance = 3, realWidth = 0.3, eyeResolutionX = 11, eyeResolutionY = NULL, plot = T, output = "web3.jpg" )

# bee's view of a flower
img <- load.image('flower.jpg')
img <- resize(img, 512, 512)
AcuityView(photo = img, distance = 1, realWidth = 0.15, eyeResolutionX = 2, eyeResolutionY = NULL, plot = T, output = "flower1.jpg" )
AcuityView(photo = img, distance = 2, realWidth = 0.15, eyeResolutionX = 2, eyeResolutionY = NULL, plot = T, output = "flower2.jpg" )
AcuityView(photo = img, distance = 3, realWidth = 0.15, eyeResolutionX = 2, eyeResolutionY = NULL, plot = T, output = "flower3.jpg" )

# goldfish looking at another goldfish
img <- load.image('goldfish.jpg')
img <- resize(img, 512, 512)
AcuityView(photo = img, distance = 1, realWidth = 0.15, eyeResolutionX = 0.14285714285, eyeResolutionY = NULL, plot = T, output = "goldfish1.jpg" )
AcuityView(photo = img, distance = 2, realWidth = 0.15, eyeResolutionX = 0.14285714285, eyeResolutionY = NULL, plot = T, output = "goldfish2.jpg" )
AcuityView(photo = img, distance = 3, realWidth = 0.15, eyeResolutionX = 0.14285714285, eyeResolutionY = NULL, plot = T, output = "goldfish3.jpg" )


