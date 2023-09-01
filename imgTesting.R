library(tesseract)
library(magick)

eng = tesseract('eng')
text = ocr("~/Downloads/Screenshot 2023-08-30 at 10.24.27 PM.png")

df = ocr_data("~/Downloads/Screenshot 2023-08-30 at 10.24.27 PM.png")

df = df[df$confidence > 90,]

words = df$word[which(df$confidence >= 90)]
x = paste(words, collapse = " ")

img = magick::image_read("~/Downloads/Screenshot 2023-08-30 at 10.24.27 PM.png")

image_crop(img, "1000x1124+610+0", repage = FALSE)


image_annotate(img, "CONFIDENTIAL", color = "red", boxcolor = "pink",
               degrees = 0, location = "200x200+72+65")

img = image_draw(img)
for(i in 1:nrow(df)){
  coord = df$bbox[i]
  coord = strsplit(coord,split = ",")[[1]]
  coord1 = as.numeric(coord[1])
  coord2 = as.numeric(coord[2])
  coord3 = as.numeric(coord[3])
  coord4 = as.numeric(coord[4])
  rect(coord1,coord2,coord3,coord4, col = "red", lwd = 5)
}


rect(72,66,270,145, col = "red", lwd = 5)
