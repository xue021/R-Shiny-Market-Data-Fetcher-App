library(shiny)
library(DT)
fluidPage(
  titlePanel("Stock Data Grabber"),
  fluidRow(
    fluidRow(
      column(
      4,
      offset = 1,
      textInput("symInput", label = h3("Enter stock symbol:"), value = "TWTR"),
      tags$br(),
      
      tags$br(),
      actionButton("selectData", "Fetch Data"),
      tags$br()#,
      #actionButton("testButton","Test Button")
      
      
      ),
      column(
        4,
        offset = 2,
        dateInput("dateFrom","From:",value="2008-04-24"),
        dateInput("dateTo","To:",value="2018-04-24"),
        #tags$b("What data would you like to see?"),
        tags$br(),
        tags$br()
       
        
        
      )
      ),
      
        column(
          10,
          offset = 1,
          tags$h4("Currently Selected:"),
          tags$h1(textOutput("showSelection")),
          verbatimTextOutput("daterange"),
          downloadButton("downloadRaw", "Download Raw Data"),
          downloadButton("downloadIndicator", "Download Indicator Data"),
          tags$br(),
          tags$br(),
          tabsetPanel(
            tabPanel("Raw Stock Data",tags$b("Yahoo Finance Stock Data"),DT::dataTableOutput("stockDataTable")),
            tabPanel("Indicator Data",tags$b("Indicator Data:"),tags$b("Indicator Data:"),DT::dataTableOutput("stockIndicatorDataTable")))
        )
       
    # sidebarPanel(
    #   tags$h4("Currently Selected:"),
    #   tags$h1(textOutput("showSelection")),
    #   textOutput("testoutput")
    # ),
  ) 
)
  
  
      
      
      
      

      

    

  
