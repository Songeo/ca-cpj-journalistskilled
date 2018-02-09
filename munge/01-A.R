# Example preprocessing script.


# Datos hasta 2017 ----
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



# df_cpj$coverage %>% table(useNA = "always")
# df_cpj$`source of fire` %>% table(useNA = "always")
# df_cpj$`type of death` %>% table(useNA = "always")
# df_cpj$`impunity (for murder)` %>% table(useNA = "always")
# df_cpj$`taken captive` %>% table(useNA = "always")
# df_cpj$tortured %>% table(useNA = "always")
# df_cpj$threatened %>% table(useNA = "always")

rm("tt")



# Datos nuevos commited ----

# tt <- read_csv("data/Killed_Confirmed_92_18.csv")
# dim(tt)
# tt %>% data.frame() %>% head
# 
# apply(is.na(tt), 2, sum)

df_cpj_confirmed <- read_csv("data/Killed_Confirmed_92_18.csv") %>% 
  dplyr::select(id, href, name = fullName, personId,
                motive = motiveConfirmed,
                primaryNationality, 
                year, startDate, startDisplay,
                impunity, 
                gender, type,
                localOrForeign,
                sourcesOfFire, typeOfDeath,
                tortured, captive, threatened,
                jobs, employedAs, 
                mediums, coverages,
                country, country_name, countryShort, region_short) %>% 
  mutate(date_registered = mdy(startDate),
         month_year = dmy(paste0("01-", format(date_registered, "%m-%Y")))) %>% 
  filter(!is.na(name)) %>% 
  arrange(desc(date_registered))
df_cpj_confirmed


