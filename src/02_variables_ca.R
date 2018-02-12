
library(ProjectTemplate)
load.project()

names(df_cpj_confirmed)
df_cpj_confirmed$impunity %>% unique
df_cpj_confirmed$typeOfDeath %>% unique

df_cpj_confirmed %>% data.frame() %>% head()




# df tidy ----

df_cpj_tidy <- df_cpj_confirmed %>% 
  gather(variable, value, gender:region_short) %>% 
  group_by(name) %>% 
  do(var_sep_fun(sub_df = .)) %>% 
  arrange(month_year, name) %>% 
  mutate(impunity = fct_explicit_na(impunity, "Unknown"), 
         value = fct_explicit_na(value, na_level = "Unknown"))

df_cpj_tidy %>% data.frame() %>% head()

df_cpj_tidy

cache("df_cpj_tidy")







# ca ----

df_cpj_tidy$variable %>% unique()

CAvar_gg_fun(var.nom = "typeOfDeath")
CAvar_gg_fun(var.nom = "sourcesOfFire")
CAvar_gg_fun(var.nom = "coverages")
CAvar_gg_fun(var.nom = "country")
CAvar_gg_fun(var.nom = "region_short")
CAvar_gg_fun(var.nom = "mediums")
CAvar_gg_fun(var.nom = "captive")


vect.date <- c("2005-01-18", "2010-12-03")


vect.date <- paste0(format(ymd(input$dateca.input), "%Y-%m"), "-01")

CAvar_gg_fun(fecha.min = vect.date[1],
             fecha.max = vect.date[2])





# variables ----

tt <- df_cpj_tidy %>% 
  group_by(year, variable) %>% 
  summarise(nu = n_distinct(value))

tt %>% 
  spread(year, nu) %>% 
  data.frame() 


df_cpj_tidy %>% 
  data.frame() %>% 
  head

