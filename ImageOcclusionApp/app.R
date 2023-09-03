library(shiny)
library(magick)
library(tesseract)
library(shinythemes)
# Define UI for application
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      fileInput("filein","Input Your Images Here", multiple = TRUE),
      actionButton("generate","Generate Cards")
      
    ),
    mainPanel(
      imageOutput("imgOut"),
      actionButton("nextImage","Remove One Rectangle (bottom up")
    )
    
  )

  
)

# Define server logic
server <- function(input, output) {
  
  image.counter = reactiveValues()
  image.counter$val = 0
  
  observeEvent(input$generate, {
    
    f = input$filein
    for(i in 1:nrow(f)){
      # Grab filepath
      path = f$datapath[i]
      
      # Grab words from picture
      eng = tesseract('eng')
      df = ocr_data(path)
      df = df[df$confidence > 90,]
      words = df$word[which(df$confidence >= 90)]
      
      # Create images with boxes over words
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
        image_write(img, path = paste0("../test_images/test",i,"_",j,".png"), format = "png")
        
      }
    }
    list.of.images = sort(list.files(path = "../test_images"))
    assign("list.of.images",list.of.images,.GlobalEnv)
    output$imgOut = renderImage(list(src = paste0("../test_images/",list.of.images[length(list.of.images)]),
                                     contentType = 'image/png',
                                     width = 1000,
                                     height = 750,
                                     alt = "This is alternate text"),
                                deleteFile = FALSE)
  })
  
  observeEvent(input$nextImage, {
    if(image.counter$val < (length(list.of.images)-1)){
      print(list.of.images[length(list.of.images)-image.counter$val])
      output$imgOut = renderImage(    list(src = paste0("../test_images/",list.of.images[length(list.of.images)-image.counter$val]),
                                           contentType = 'image/png',
                                           width = 1000,
                                           height = 750,
                                           alt = "This is alternate text"),
                                      deleteFile = FALSE)
      image.counter$val = image.counter$val + 1
    }

  })
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
