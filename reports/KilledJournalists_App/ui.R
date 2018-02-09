# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fixedPage(
  # Application title
  
  # div(style="text-align:center",
  #     img(src="televisa_logo.png", width="100") ),
  # hr(),
  headerPanel("Análisis de Correspondencias"),
  br(),
  br(),
  
  titlePanel("Asociación de impunidad con variables"),
  

  br(),
  br(),
  # Sidebar with a slider input for number of bins 
    
  navbarPage("1992 a 2017",
             tabPanel("Tendencias", 
                      icon =  icon("sellsy"),
                      h3("Asociación de impunidad con variables"),
                      sidebarPanel(selectInput(inputId = 'country.input',
                                               label = 'País',
                                               selected = "-Todos-",
                                               choices = c("-Todos-",
          "Afghanistan","Algeria","Angola","Argentina","Armenia","Azerbaijan",
          "Bahrain","Bangladesh","Belarus","Bolivia","Bosnia","Brazil",
          "Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada",
          "Central African Republic","Chad","China","Colombia","Costa Rica",
          "Croatia","Cyprus","Democratic Republic of the Congo","Denmark",
          "Dominican Republic","East Timor","Ecuador","Egypt","El Salvador",
          "Eritrea","Ethiopia","France","Gabon","Gambia","Georgia","Ghana",
          "Greece","Guatemala","Guinea","Haiti","Honduras","India","Indonesia",
          "Iran","Iraq","Ireland","Israel and the Occupied Palestinian Territory",
          "Ivory Coast","Japan","Kazakhstan","Kenya","Kuwait","Kyrgyzstan",
          "Latvia","Lebanon","Libya","Lithuania","Madagascar","Maldives",
          "Mali","Malta","Mexico","Montenegro","Mozambique","Myanmar",
          "Nepal","Nicaragua","Nigeria","Pakistan","Panama","Papua New Guinea",
          "Paraguay","Peru","Philippines","Poland","Republic of Congo","Russia",
          "Rwanda","Saudi Arabia","Serbia","Sierra Leone","Somalia",
          "South Africa","South Sudan","Spain","Sri Lanka","Sudan",
          "Syria","Tajikistan","Tanzania","Thailand","Tunisia","Turkey",
          "Turkmenistan","Uganda","UK","Ukraine","Uruguay","USA","Uzbekistan",
          "Venezuela","Vietnam","Yemen","Yugoslavia","Zimbabwe")),
                                   dateRangeInput(inputId = 'datetrend.input',
                                                  label = 'Rango de Fecha',
                                                  start = "2005-01-01", 
                                                  end = "2017-12-31", 
                                                  min = "1992-01-01", 
                                                  max = "2017-12-31",
                                                  format = "yyyy-mm", 
                                                  startview = "year",
                                                  language = "es", 
                                                  separator = " a ",
                                                  width = NULL),
                                   width = 4),
                      mainPanel(
                        h4("Número de casos"),
                        plotOutput("gg_trend_n", height = "300px", width = "700px"),
                        h4("Proporción de motivo"),
                        plotOutput("gg_trend_p", height = "300px", width = "700px")
                      )), #tabpanel tendencias
             tabPanel("Análisis de correspondencias", 
                      icon =  icon("map"),
                      h3("Asociación de impunidad con variables"),
                      br(),
                      fluidRow(
                        column(5,
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
                        ),
                        column(5,
                               dateRangeInput(inputId = 'dateca.input',
                                              label = 'Rango de Fecha',
                                              start = "2005-01-01", 
                                              end = "2017-12-31", 
                                              min = "1992-01-01", 
                                              max = "2017-12-31",
                                              format = "yyyy-mm", 
                                              startview = "year",
                                              language = "es", 
                                              separator = " a ",
                                              width = NULL)
                        )
                      ), # fluidrow
                      br(),
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
       <b> Datos del Comité para la Protección de los Periodistas</b>
       <br>
       <img src="cpj-logo.png", width="60", height="45">
       </p>')

  

)) # fluidpage shinyui
