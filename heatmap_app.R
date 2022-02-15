#Shiny app to build heatmaps from a data matrix, such as gene expression data
#Developed by Amanda Fanelli in 02/2022

#Load libraries----

library(shiny)
library(pheatmap)
library(gplots)
library(RColorBrewer)


#Create color palettes----

#Use gplots and Rcolorbrewer to create palettes
blue <- colorRampPalette(brewer.pal(n = 7, name = "Blues"))(100)
green <- colorRampPalette(brewer.pal(n = 7, name = "Greens"))(100)
orange <- colorRampPalette(brewer.pal(n = 7, name = "Oranges"))(100)
purple <- colorRampPalette(brewer.pal(n = 7, name = "Purples"))(100)
bluered <- bluered(75)
greenred <- greenred(75)
greenblue <- colorRampPalette(brewer.pal(n = 7, name ="GnBu"))(100)
stdpalette <- colorRampPalette(rev(brewer.pal(n = 7, name ="RdYlBu")))(100)

#Create a list with the names of the palletes to show as options
colorlist <- list("blues" = blue,
                  "greens" = green,
                  "oranges" = orange,
                  "purples" = purple,
                  "blue red" = bluered,
                  "green red" = greenred,
                  "green blue" = greenblue,
                  "red yellow blue" = stdpalette)


#User interface UI ----

ui <- fluidPage(
  
  #Create sidebar
  sidebarLayout(
    sidebarPanel(width = 4,
                 h1("Choose parameters"),
                 
                 #Create input box to load the dataset file
                 fileInput(inputId = "matrix", 
                           label = "Load your dataset in a .txt file", 
                           accept =".txt"),
                 
                 #Create select box to choose the method for row distances
                 selectInput(inputId = "row_distance",
                             label = "Choose distance method for clustering rows",
                             choices = c("euclidean", 
                                         "maximum", 
                                         "manhattan", 
                                         "canberra", 
                                         "binary", 
                                         "minkowsky")),
                 
                 #Create select box to choose the method for column distances
                 selectInput(inputId = "col_distance",
                             label = "Choose distance method for clustering columns",
                             choices = c("euclidean", 
                                         "maximum", 
                                         "manhattan", 
                                         "canberra", 
                                         "binary", 
                                         "minkowsky")),
                 
                 #Create select box to choose cluster column, row or both
                 selectInput(inputId = "cluster",
                             label = "Choose cluster colum, row or both",
                             choices = c("column", "row", "both"),
                             selected = "both"),
                 
                 #Create select box to choose the method for clustering
                 selectInput(inputId = "clustering",
                             label = "Choose clustering method",
                             choices = c("ward.D", 
                                         "ward.D2", 
                                         "single", 
                                         "complete",
                                         "average", 
                                         "mcquitty",
                                         "median",
                                         "centroid")),
                 
                 #Create select box to choose the color palette
                 selectInput(inputId = "colors",
                             label = "Choose color palette",
                             choices = c("blues",
                                         "greens",
                                         "oranges",
                                         "purples",
                                         "blue red",
                                         "green red",
                                         "green blue",
                                         "blue yellow red"),
                             selected = "blue yellow red"),
                 
                 #Create select box to choose cell dimensions
                 selectInput(inputId ="size",
                             label = "Choose cell dimensions",
                             choices = seq(1:120),
                             selected = 50),
                 
                 #Create slider box to choose font size
                 sliderInput(inputId ="fontsize",
                             label = "Choose fontsize",
                             min = 0,
                             max = 50,
                             value = 20),
                 #Create Export button
                 downloadButton('downloadPlot', 'Export.png'),
                 
                 #Create a footnote
                 hr(),
                 print("Built by Amanda Fanelli using Shiny")
    ),
    
    mainPanel(h1("Build your heatmap"),
              plotOutput("heatmap", width = "100%")),
    
  )
)


#Server----

#Read input file and show error if not .txt
server <- function(input, output) {
  data <- reactive({
    req(input$matrix)
    ext <- tools::file_ext(input$matrix$datapath)
    validate(need(ext=="txt", "Input file is not .txt, please upload a .txt file")) 
    read.table(input$matrix$datapath, header = TRUE)
  })
#Reactive options for the heatmap  
  color <- reactive({
    switch(input$colors,
           "blues" = colorlist[[1]],
           "greens" = colorlist[[2]],
           "oranges" = colorlist[[3]],
           "purples" = colorlist[[4]],
           "blue red" = colorlist[[5]],
           "green red" = colorlist[[6]],
           "green blue" = colorlist[[7]],
           "blue yellow red" = colorlist[[8]])
    
  })
  cluster_d_rows <- reactive({input$row_distance})
  cluster_d_cols <- reactive({input$col_distance})
  cluster_methods <- reactive({input$clustering})
  cluster_cols <- reactive({switch(input$cluster, "column" = TRUE, 
                                   "row" = FALSE, "both" = TRUE)})
  cluster_rows <- reactive({switch(input$cluster, "column" = FALSE, 
                         "row" = TRUE, "both" = TRUE)})
  cell_size <- reactive({ifelse(input$size =="automatic", 
                                NA, as.numeric(input$size))})
  font_size <- reactive({input$fontsize})

#Build output heatmap
  output$heatmap <- renderPlot({
    pheatmap(as.matrix(data()), 
    clustering_distance_rows = cluster_d_rows(),
    clustering_distance_cols = cluster_d_cols(),
    clustering_method = cluster_methods(),
    cluster_cols = cluster_cols(),
    cluster_rows = cluster_rows(),
    angle_col = 315,
    color = color(),
    fontsize = font_size(),
    cellwidth = cell_size(),
    cellheight = cell_size())
    
  },
  width = 1152,
  height = 1008)
 
#Export heatmap as .png image
  output$downloadPlot <- downloadHandler(
    file = "heatmap.png",
    content = function(file){
      png(file = file, width = 4800, height = 4200, res = 300)
      pheatmap(as.matrix(data()), 
      clustering_distance_rows = cluster_d_rows(),
      clustering_distance_cols = cluster_d_cols(),
      clustering_method = cluster_methods(),
      cluster_cols = cluster_cols(),
      cluster_rows = cluster_rows(),
      angle_col = 315,
      color = color(),
      fontsize = font_size(),
      cellwidth = cell_size(),
      cellheight = cell_size())
      dev.off()
    }
  )
  
}

#Build app
shinyApp(ui = ui, server = server)