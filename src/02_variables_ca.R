
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

