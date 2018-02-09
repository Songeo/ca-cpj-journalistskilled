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
    tab <- df_cpj_union %>% 
      filter(year < 2018) %>% 
      group_by(year, motive) %>% 
      # filter(`country killed` == "Mexico") %>%
      summarise(value = n()) %>% 
      ungroup() %>% 
      spread(motive, value) %>% 
      mutate(Confirmed = ifelse(year <= 2016 & is.na(Confirmed), 
                                0, Confirmed),
             Unconfirmed = ifelse(year <= 2016 & is.na(Unconfirmed), 
                                  0, Unconfirmed),
             UnconfirmedNA = ifelse(year > 2016, NA, Unconfirmed)) %>% 
      arrange(desc(year)) %>% 
      mutate(UnconfirmedIMP = round(na.ma(UnconfirmedNA))) %>% 
      dplyr::select(year, Confirmed, Unconfirmed = UnconfirmedIMP) %>% 
      gather(motive, value,  -year)
    tab
  })
  
  output$gg_trend_n <- renderPlot({
    gg <- tabTrend() %>% 
      ggplot(aes(x = year, 
                 y = value, 
                 fill = factor(motive, c("Unconfirmed", "Confirmed") )))  +  
      geom_bar(stat = "identity") + 
      scale_x_continuous(breaks = seq(1991, 2019, by = 3)) +
      guides(fill = guide_legend("Motive")) +
      ylab("Número de asesinatos") + 
      xlab("Fecha") 
    gg
  })
  
  output$gg_trend_p <- renderPlot({
    gg <- tabTrend() %>% 
      ggplot(aes(x = year, 
                 y = value, 
                 fill = factor(motive, c("Unconfirmed", "Confirmed") )))  +  
      geom_bar(stat = "identity", position = "fill") + 
      geom_hline(yintercept = .5) + 
      scale_x_continuous(breaks = seq(1991, 2019, by = 3)) +
      guides(fill = guide_legend("Motive")) +
      ylab("Número de asesinatos") + 
      xlab("Fecha")
    gg
  })
  
  output$gg_ca_var <- renderPlot({
    CAvar_gg_fun(var.nom = input$varnom.input)
  })
  
})