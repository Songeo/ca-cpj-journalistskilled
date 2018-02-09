

library(ProjectTemplate)
load.project()


library(plotly)
library(imputeTS)
library(mi)

# Union de df ----
df_cpj %>% head()
df_cpj_confirmed %>% head

df_cpj_union <- df_cpj %>% 
  dplyr::select(name, sex, `country killed`, 
                motive,
                date_registered, month_year, year) %>% 
  filter(motive == "Unconfirmed") %>% 
  bind_rows(df_cpj_confirmed %>% 
              dplyr::select(name, sex = gender, `country killed` = country, 
                            motive, 
                            date_registered, month_year, year) ) 

df_cpj_union


# Variables ----

# summary
tab <- df_cpj_union %>% 
  filter(year < 2018) %>% 
  group_by(year, motive) %>% 
  filter(`country killed` == "Mexico") %>%
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


# # MI ----
# df_tab <- data.frame(tab) %>% 
#   dplyr::select(-Unconfirmed)
# mdf <- missing_data.frame(df_tab) # warnings about missingness patterns
# show(mdf)
# imputations <- mi(mdf)
# dfs <- complete(imputations)
# dfs

gg <- tab %>% 
  ggplot(aes(x = year, 
             y = value, 
             fill = factor(motive, c("Unconfirmed", "Confirmed") )))  +  
  geom_bar(stat = "identity") + 
  scale_x_continuous(breaks = seq(1991, 2019, by = 3)) +
  guides(fill = guide_legend("Motive")) +
  ylab("Journalists killed") + 
  xlab("Date") 
gg
# ggplotly(gg)


gg <- tab %>% 
  ggplot(aes(x = year, 
             y = value, 
             fill = factor(motive, c("Unconfirmed", "Confirmed") )))  +  
  geom_bar(stat = "identity", position = "fill") + 
  geom_hline(yintercept = .5) + 
  scale_x_continuous(breaks = seq(1991, 2019, by = 3)) +
  guides(fill = guide_legend("Motive")) +
  ylab("Journalists killed") + 
  xlab("Date")
gg
# ggplotly(gg)



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
