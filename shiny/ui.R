library(shiny)
library(markdown)

shinyUI(
  pageWithSidebar(
    # Header
    headerPanel("Which car should you bought 40 years ago???"
    ),
    # Menu
    sidebarPanel(
      #MPG filter
      sliderInput('mpg', 'Miles/(US) gallon', min = 10, max = 40, value = c(10,40)),
      hr(),
      #CYL filter
      uiOutput("cylControls"),
      hr(),
      #AM filter
      uiOutput("amControls"),
      hr(),
      #GEAR filter
      uiOutput("gearsControls"),
      hr(),
      
      submitButton('Submit')
    ),
    # Main
    mainPanel(
      tabsetPanel(
        # Data 
        tabPanel(p(icon("table"), "Results"),
                 hr(),
                 p("Using 'mtcars' dataset we'll see the cars we could bougth in 1974, according our desired parameters."),
                 hr(),
                 p("Press 'Submit' after selecting your options. Table & Charts will update."),
                 hr(),
                 h3('List of Cars'),
                 dataTableOutput(outputId="table"),
                 downloadButton('downloadData', 'Download')

        ),
        tabPanel(p(icon("line-chart"), "Charts"),
                h3('Relationships between paramters selected'),
                fluidRow(
                  column(4,plotOutput("chcyl")),
                  column(4,plotOutput("cham")),
                  column(4,plotOutput("chgear"))
                  )
        ),
        tabPanel("About",
                 mainPanel(
                   includeMarkdown("include.md")
                 )
        )
      )
    )
  )
)
