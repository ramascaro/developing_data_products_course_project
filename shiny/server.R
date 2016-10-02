library(ggplot2)
library(dplyr)

# Load data
mt <- mtcars  %>% add_rownames()
# create factors with value labels data(mtcars)
# mt$cyl <- factor(mt$cyl)
# mt$vs <- factor(mt$vs)
# mt$gear <- factor(mt$gear)
# mt$carb <- factor(mt$carb)
mt$am <- factor(mt$am,labels=c('Automatic','Manual'))
# str(mt)

models <- sort(unique(row.names(mtcars)))
cyl <-  sort(unique(mt$cyl))
am <-  sort(unique(mt$am))
gear <-  sort(unique(mt$gear))

# Main Function Output
shinyServer(
  function(input, output) {
    
    # Define and initialize reactive values
    values <- reactiveValues()
    values$models <- models
    values$cyl <- cyl
    values$am <- factor(am,labels=c('Automatic','Manual'))
    values$gear <- gear
    
    # Create event type checkbox
    output$cylControls <- renderUI({
      checkboxGroupInput('cyl', 'Number of Cylinders', cyl, selected=values$cyl)
    })
    
    output$amControls <- renderUI({
      checkboxGroupInput('am', 'Transmission (1 - Automatic  2 - Manual)', am, selected=values$am)
    })
    
    output$gearsControls <- renderUI({
      checkboxGroupInput('gear', 'Number of Gears', gear, selected=values$gear)
    })
    
    # Prepare dataset for downloads
    dataTable <- reactive({
      
      mt_show <- mt
      mt_show <- mt_show[mt_show$mpg %between% input$mpg,]
      if(!is.null(input$cyl )) mt_show <- mt_show[mt_show$cyl %in% input$cyl,]
      if(!is.null(input$am  )) mt_show <- mt_show[mt_show$am %in% input$am,]
      if(!is.null(input$gear)) mt_show <- mt_show[mt_show$gear %in% input$gear,]
      mt_show
    })
    
    # Render data table and create download handler
    output$table <- renderDataTable(
      {dataTable()}, options = list(bFilter = FALSE, iDisplayLength = 10))
    
    output$downloadData <- downloadHandler(
      filename = 'data.csv',
      content = function(file) {
        write.csv(dataTable(), file, row.names=FALSE)
      }
    )
    
    # Chart 1
    output$chcyl  <- renderPlot({
      df <-dataTable()
      pie(table(df$cyl), col=rainbow(3), main="Number of Cylinders")
      print(pie)
    })
    # Chart 2
    output$cham  <- renderPlot({
      df <-dataTable()
      pie(table(df$am), col=rainbow(3), main="Transmission Type")
      print(pie)
    })
    
    # Chart 2
    output$chgear  <- renderPlot({
      df <-dataTable()
      pie(table(df$gear), col=rainbow(3), main="Number of Gears")
      print(pie)
    })
    
  }
)