# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(tidyverse)
library(ggrepel)
library(FactoMineR)
library(lubridate)
library(stringr)
library(imputeTS)

theme_set(theme_minimal(base_size = 17))

# 
# load("data/df_cpj_union.RData")
# load("data/df_cpj_tidy.RData")

source("global.R")


shinyServer(function(input, output) {
  
  tabTrend <- reactive({
    
    if(input$country.input == "-Todos-"){
      selec.country <- unique(df_cpj_union$`country killed`)
    }
    if(input$country.input != "-Todos-"){
      selec.country <- input$country.input
    }
    
    tab <- df_cpj_union %>% 
        filter(year < 2018) %>% 
        group_by(`country killed`, year, motive) %>% 
        summarise(value = n()) %>% 
        ungroup() %>% 
        complete(nesting(motive, year), `country killed`, fill = list(value = 0)) %>% 
        filter(`country killed` %in% selec.country) %>% 
        # filter(`country killed` == "Bahrain") %>%
        group_by(year, motive) %>% 
        summarise(value = sum(value)) %>% 
        ungroup() %>% 
        spread(motive, value, fill = 0) %>% 
        mutate(UnconfirmedNA = ifelse(year > 2016, NA, Unconfirmed)) %>% 
        arrange(desc(year)) %>% 
        mutate(UnconfirmedIMP = round(na.ma(UnconfirmedNA))) %>% 
        dplyr::select(year, Confirmed, Unconfirmed = UnconfirmedIMP) %>% 
        gather(motive, value,  -year) %>% 
        mutate(motive = ifelse(year > 2016 & motive == "Unconfirmed", 
                               "Unconfirmed Imp", 
                               motive))
    
    
    tab
  })
  
  output$txt_country <- renderText({
    txt <- paste( n_distinct(df_cpj_union$`country killed`),
                 "países")
    if(input$country.input != "-Todos-"){
      txt <- input$country.input
    }
    
    HTML(paste0("<p style='text-align:center;font-size:140%'>",
                "Serie de asesinatos de <b style='font-size:150%' >", 
                txt, "</b> </p>"))
  })
  
  
  output$gg_trend_n <- renderPlot({
    gg <- tabTrend() %>% 
      ggplot(aes(x = year, 
                 y = value, 
                 fill = factor(motive) ))  +  
      geom_bar(stat = "identity") + 
      scale_x_continuous(breaks = seq(1991, 2019, by = 3),
                         limits = c(1992, 2018)) +
      scale_y_continuous(labels = function(x)round(x) )+
      guides(fill = guide_legend("Motive")) +
      ylab("Número de asesinatos") + 
      xlab("Fecha") 
    gg
  })
  
  output$gg_trend_p <- renderPlot({
    gg <- tabTrend() %>% 
      ggplot(aes(x = year, 
                 y = value, 
                 fill = factor(motive)))  +  
      geom_bar(stat = "identity", position = "fill") + 
      geom_hline(yintercept = .5) + 
      scale_x_continuous(breaks = seq(1991, 2019, by = 3),
                         limits = c(1992, 2018)) +
      scale_y_continuous(labels = function(x)paste(round(100*x), "%") )+
      guides(fill = guide_legend("Motive")) +
      ylab("Proporción de motivo") + 
      xlab("Fecha")
    gg
  })
  
  output$txt_varinput <- renderText({
    HTML(paste0("<div style='font-size:200%;color:gray;",
                "font-family:courier;text-align:left;'>",
                paste0("impunity vs. ", input$varnom.input),
                "</div>"))
  })
  
  output$gg_ca_var <- renderPlot({
    vect.date <- input$dateca.input
    
    tab_aux <- df_cpj_tidy %>% 
      filter(variable == input$varnom.input, 
             date_registered >= vect.date[1], 
             date_registered <= vect.date[2]) 
    validate(
      need(n_distinct(tab_aux$value) > 2, 
           'Selecciona otro periodo de tiempo o variable.\nNo es posible realizar el análisis')
    )
    
    CAvar_gg_fun(var.nom = input$varnom.input, 
                 fecha.min = vect.date[1],
                 fecha.max = vect.date[2])
  })

  

})