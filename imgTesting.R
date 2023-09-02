library(tesseract)
library(magick)

eng = tesseract('eng')
text = ocr("C:/Users/xbox/Pictures/demo1.png")

df = ocr_data("C:/Users/xbox/Pictures/demo1.png")

df = df[df$confidence > 90,]

words = df$word[which(df$confidence >= 90)]
x = paste(words, collapse = " ")

img = magick::image_read("C:/Users/xbox/Pictures/demo1.png")


img = image_draw(img)
image_write(img, path = paste0("test_images/test.png"), format = "png")
for(i in 1:nrow(df)){
  coord = df$bbox[i]
  coord = strsplit(coord,split = ",")[[1]]
  coord1 = as.numeric(coord[1])
  coord2 = as.numeric(coord[2])
  coord3 = as.numeric(coord[3])
  coord4 = as.numeric(coord[4])
  rect(coord1,coord2,coord3,coord4, col = "red", lwd = 5)
  image_write(img, path = paste0("test_images/test",i,".png"), format = "png")
  
}

