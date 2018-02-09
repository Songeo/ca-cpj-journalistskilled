# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(
  # Application title
  
  # div(style="text-align:center",
  #     img(src="televisa_logo.png", width="100") ),
  # hr(),
  
  
  
  titlePanel("Análisis de Correspondencias:"),
  h3("Asociación de impunidad con variables."),

  br(),
  br(),
  # Sidebar with a slider input for number of bins 
    
  navbarPage("Muertes de 1992 a 2017:",
             tabPanel("Tendencias", 
                      icon =  icon("sellsy"),
                      mainPanel(
                        h4("Número de casos"),
                        plotOutput("gg_trend_n", height = "300px", width = "600px"),
                        h4("Proporción de motivo"),
                        plotOutput("gg_trend_p", height = "300px", width = "600px")
                        
                      )), #tabpanel tendencias
             tabPanel("Análisis de correspondencias", 
                      icon =  icon("map"),
                      sidebarPanel(
                        selectInput(inputId = 'varnom.input',
                                    label = 'Variable',
                                    choices = c("Coverage" = "coverages",
                                                "Sources of fire" = "sourcesOfFire",
                                                "Job" = "jobs",
                                                "Medium" = "mediums",
                                                "Gender" = "gender",
                                                "Type of death" = "typeOfDeath",
                                                "Tortured" = "tortured",
                                                "Captive" = "captive",
                                                "Threatened" = "threatened",
                                                "Country killed" = "country",
                                                "Region" = "region_short"))
                        ), #sidebarpanel
                        mainPanel(
                          plotOutput("gg_ca_var", height = "600px", width = "700px")
                        )
                      ), # tabpanel correspondance
             tabPanel("Información",
                      icon =  icon("info")
                      ) # tabpanel info
             
             ),
  
  hr(),
  HTML('<p style="text-align:center;color:gray">
       <b> Data from the Committee to Protect Journalists</b>
       <br>
       <img src="cpj-logo.png", width="60", height="45">
       </p>')

  

)) # fluidpage shinyui
