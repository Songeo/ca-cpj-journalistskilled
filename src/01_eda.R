

library(ProjectTemplate)
load.project()

library(plotly)

# Variables ----
df_cpj$coverage %>% table(useNA = "always")
df_cpj$`source of fire` %>% table(useNA = "always")
df_cpj$`type of death` %>% table(useNA = "always")
df_cpj$`impunity (for murder)` %>% table(useNA = "always")
df_cpj$`taken captive` %>% table(useNA = "always")
df_cpj$tortured %>% table(useNA = "always")
df_cpj$threatened %>% table(useNA = "always")



df_cpj %>% nrow


df_cpj %>% 
  group_by(motive) %>% 
  tally()


df_cpj %>% 
  mutate(ind = 1) %>% 
  # filter(`country killed` == "Mexico") %>%
  ggplot(aes(x = year, 
             y = ind))  +  
  stat_summary(fun.y = sum, geom = "line") + 
  stat_summary(fun.y = sum, geom = "point", size = 2) + 
  ylab("Journalists killed") + 
  xlab("Date")+ 
  scale_x_continuous(breaks = seq(1992, 2016, by = 3))

gg <- df_cpj %>% 
  group_by(year, motive) %>% 
  filter(`country killed` == "Mexico") %>%
  summarise(value = n()) %>% 
  ungroup() %>% 
  ggplot(aes(x = year, 
             y = value, 
             fill = motive))  +  
  geom_bar(stat = "identity") + 
  scale_x_continuous(breaks = seq(1992, 2016, by = 3)) +
  ylab("Journalists killed") + 
  xlab("Date") 
ggplotly(gg)


gg <- df_cpj %>% 
  group_by(year, motive) %>% 
  filter(`country killed` == "Mexico") %>%
  summarise(value = n()) %>% 
  ungroup() %>% 
  ggplot(aes(x = year, 
             y = value, 
             fill = motive))  +  
  geom_bar(stat = "identity", position = "fill") + 
  geom_hline(yintercept = .5) + 
  scale_x_continuous(breaks = seq(1992, 2016, by = 3)) +
  ylab("Journalists killed") + 
  xlab("Date")
ggplotly(gg)



# mapa del mundo ----
world <- map_data(map = "world")
world %>% head
ggmap_freq <- function(sub){
  tt.gg <- world %>% 
    as_tibble() %>% 
    mutate(region = tolower(region)) %>% 
    left_join( sub, 
               by = c("region" = "country_killed"))
  ggplot(tt.gg, aes(x = long, y = lat, 
                    group = group, fill = freq))+ 
    geom_polygon() + 
    theme_bw() + 
    coord_fixed() + 
    theme(rect = element_blank(), 
          line = element_blank(),
          axis.text = element_blank(), 
          axis.ticks = element_blank(),
          plot.title = element_text(hjust = .5),
          legend.position = "bottom") + 
    xlab(NULL) +
    ylab(NULL)
}
