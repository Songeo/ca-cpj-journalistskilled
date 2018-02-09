
library(ProjectTemplate)
load.project()

df_cpj$`impunity (for murder)` %>% unique
df_cpj$`type of death` %>% unique



# df tidy ----
var_sep_fun <- function(sub_df){
  # sub_df <- filter(tab_cpj, name == "Abay Hailu")
  tab_1 <- filter(sub_df, variable == "coverage")
  tab_2 <- filter(sub_df, variable == "source_fire")
  tab_1 %>% 
    dplyr::select(-value) %>% 
    left_join(tibble(value = str_split_fixed(tab_1$value, 
                                             pattern = ",",
                                             n = str_count(tab_1$value, ",") +1) %>% 
                       str_trim(),
                     name = tab_1$name), 
              by = "name") %>% 
    bind_rows(tab_2 %>% 
                dplyr::select(-value) %>% 
                left_join(tibble(value = str_split_fixed(tab_2$value, 
                                                         pattern = ",",
                                                         n = str_count(tab_2$value, ",") +1) %>% 
                                   str_trim(),
                                 name = tab_2$name), 
                          by = "name")) %>% 
    bind_rows(sub_df %>% 
                filter(!(variable %in% c("source_fire", "coverage"))))
}
  
df_cpj_tidy <- df_cpj %>% 
  filter(motive == "Confirmed") %>% 
  dplyr::select(month_year, year, name, 
                impunity = `impunity (for murder)`, 
                country = `country killed`, 
                local = `local/foreign`, 
                source_fire = `source of fire`, 
                type_death = `type of death`, 
                threatened,
                coverage) %>% 
  gather(variable, value, country:coverage) %>% 
  group_by(name) %>% 
  do(var_sep_fun(sub_df = .)) %>% 
  arrange(month_year, name) %>% 
  mutate(impunity = fct_explicit_na(impunity, "No info"), 
         value = fct_explicit_na(value, na_level = "No info"))


# ca ----

# función ca
CAvar_gg_fun <- function(var.nom = "country", 
                 fecha.min = "2005-01-01",
                 fecha.max = "2017-05-01", 
                 var.size = 5, 
                 col.size = 3){
  
  require(ggrepel)
  require(FactoMineR)
  
  tab.x <- df_cpj_tidy %>% 
    filter(variable == var.nom, 
           month_year >= fecha.min, 
           month_year <= fecha.max) %>% 
    group_by(value, impunity) %>% 
    tally %>% 
    ungroup %>% 
    complete(nesting(value), impunity, fill = list(n = 0) ) %>% 
    spread(impunity, n) %>% 
    data.frame()
  tab.x
  row.names(tab.x) <- tab.x$value
  ca.fit <- CA(tab.x[, -1], graph = F)
  # summary(ca.fit, nb.dec = 2, ncp = 2)
  ggCA(ca.fit)
  
  mca1_vars_df <- data.frame(ca.fit$col$coord) %>% 
    rownames_to_column("columna")
  mca1_obs_df <- data.frame(ca.fit$row$coord) %>% 
    rownames_to_column("renglon") 
  
  # pal <- colorRampPalette()
  
  ggplot(data = mca1_obs_df, 
         aes(x = Dim.1, y = Dim.2)) + 
    geom_density2d(colour = "gray80") +
    geom_hline(yintercept = 0, linetype = 2) +
    geom_vline(xintercept = 0, linetype = 2) +
    geom_point(colour = "gray50", alpha = 0.7) + 
    geom_text_repel(aes(label = renglon),
              alpha = .6) + 
    scale_size_manual(values = c(6, 4.5)) +
    geom_point(data = mca1_vars_df, 
               size = 3,
               aes(x = Dim.1, y = Dim.2, 
                   colour = columna)) +
    geom_text_repel(data = mca1_vars_df, 
              fontface = "bold", 
              size = var.size,
              aes(x = Dim.1, y = Dim.2, 
                  label = columna, 
                  colour = columna)) 
    # scale_color_manual(values = c("gray20", "gray50", pal))
}


df_cpj_tidy$variable %>% unique()
CAvar_gg_fun(var.nom = "type_death")
CAvar_gg_fun(var.nom = "source_fire")
CAvar_gg_fun(var.nom = "local")
CAvar_gg_fun(var.nom = "country")
CAvar_gg_fun(var.nom = "threatened")
