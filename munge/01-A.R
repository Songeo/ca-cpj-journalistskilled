# Example preprocessing script.

tt <- read_csv("data/cpj_mods.csv")
names(tt) <- tolower(names(tt))

df_cpj <- tt %>%
  mutate(date_registered = mdy(date)) %>% 
  separate(date, into = c("aux", "year"), sep = ",", remove = F) %>% 
  mutate(year = parse_number(year),
         month_year = dmy(paste0("01-", format(date_registered, "%m-%Y"))) ) %>% 
  filter(!is.na(name))


df_cpj %>% data.frame() %>% head
df_cpj$month_year %>% summary()

filter(df_cpj, is.na(month_year)) %>% data.frame()
df_cpj %>% 
  group_by(year) %>% 
  summarise(min(date_registered, na.rm = T),
            max(date_registered, na.rm = T)) %>% 
  data.frame()

rm("tt")

df_cpj$coverage %>% table(useNA = "always")
df_cpj$`source of fire` %>% table(useNA = "always")
df_cpj$`type of death` %>% table(useNA = "always")
df_cpj$`impunity (for murder)` %>% table(useNA = "always")
df_cpj$`taken captive` %>% table(useNA = "always")
df_cpj$tortured %>% table(useNA = "always")
df_cpj$threatened %>% table(useNA = "always")

