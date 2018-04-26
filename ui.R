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
      dateInput("dateFrom","From:",value="2008-04-24"),
      dateInput("dateTo","To:",value="2018-04-24"),
      tags$br(),
      actionButton("selectData", "Fetch Data"),
      tags$br()
      
      ),
      column(
        4,
        offset = 2,
        
        checkboxGroupInput("indicatorsSelected", "Include Indicators:",
                           c("Moving Average Convergence Divergence (MACD)" = 0,
                             "Stochastic (fast)" = 1,
                             "Stochastic (slow)" = 2,
                             "Stochastic Volume" = 3,
                             "Stochastic Movement Index (SMI)" = 4,
                             "Relative Strength Index (RSI)" = 5,
                             "Directional Movement Index (Signal)" = 6,
                             "Directional Movement Index (Average Signal)" = 7,
                             "Remove Incomplete Rows (Suggested)"= "y"),
                           selected = c(0,1,2,3,4,5,6,7,"y")
        )
        
        
        
      )
      ),
      
        column(
          10,
          offset = 1,
          tags$h4("Currently Selected Symbol:"),
          tags$h1(textOutput("showSelection")),
          #verbatimTextOutput("debug"),
          
          tags$br(),
          tags$br(),
          tabsetPanel(
            tabPanel("Raw Stock Data",tags$b("Yahoo Finance Stock Data"),DT::dataTableOutput("stockDataTable")),
            tabPanel("Indicator Data",tags$b("Indicator Data:"),tags$b("Indicator Data:"),DT::dataTableOutput("stockIndicatorDataTable"))),
          downloadButton("downloadRaw", "Download Raw Data"),
          downloadButton("downloadIndicator", "Download Indicator Data"),
          downloadButton("downloadMetadata", "Download Min/Max Indicator Values"),
          tags$br(),
          tags$i("min/max for use with cs487 project"),
          tags$i("above project can be found at https://github.com/xue021/cs487groupproject")
          
        )
       
    # sidebarPanel(
    #   tags$h4("Currently Selected:"),
    #   tags$h1(textOutput("showSelection")),
    #   textOutput("testoutput")
    # ),
  ) 
)
  
  
      
      
      
      

      

    

  
