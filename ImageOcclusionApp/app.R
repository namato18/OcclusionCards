library(shiny)
library(magick)
library(tesseract)
# Define UI for application
ui <- fluidPage(
  fileInput("filein","Input Your Images Here", multiple = TRUE),
  actionButton("generate","Generate Cards"),
  imageOutput("imgOut")
  
)

# Define server logic
server <- function(input, output) {
  
  observeEvent(input$generate, {
    
    f = input$filein
    
    for(i in 1:nrow(f)){
      
      
      path = f$datapath[i]
      
      eng = tesseract('eng')
      df = ocr_data(path)
      df = df[df$confidence > 90,]
      words = df$word[which(df$confidence >= 90)]
      
      img = magick::image_read(path)
      img = image_draw(img)
      image_write(img, path = paste0("../test_images/test",i,".png"), format = "png")
      for(j in 1:nrow(df)){
        coord = df$bbox[j]
        coord = strsplit(coord,split = ",")[[1]]
        coord1 = as.numeric(coord[1])
        coord2 = as.numeric(coord[2])
        coord3 = as.numeric(coord[3])
        coord4 = as.numeric(coord[4])
        rect(coord1,coord2,coord3,coord4, col = "red", lwd = 5)
        image_write(img, path = paste0("../test_images/test",j,i,".png"), format = "png")
        
      }
    }
    
    output$imgOut = renderImage(    list(src = "../test_images/test1.png",
                                         contentType = 'image/png',
                                         width = 1000,
                                         height = 750,
                                         alt = "This is alternate text"),
                                    deleteFile = FALSE)
  })
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
