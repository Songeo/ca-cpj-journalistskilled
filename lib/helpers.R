

# función split commas ----
var_split_fun <- function(tab){
  tab %>% 
    dplyr::select(-value) %>% 
    left_join(tibble(value = str_split_fixed(tab$value, 
                                             pattern = ",",
                                             n = str_count(tab$value, ",") +1) %>% 
                       str_trim(),
                     name = unique(tab$name)), 
              by = "name")
}


var_sep_fun <- function(sub_df){
  # sub_df <- filter(tab_cpj, name == "Abay Hailu")
  tab_1 <- var_split_fun(filter(sub_df, variable == "coverages"))
  tab_2 <- var_split_fun(filter(sub_df, variable == "sourcesOfFire"))
  tab_3 <- var_split_fun(filter(sub_df, variable == "jobs"))
  tab_4 <- var_split_fun(filter(sub_df, variable == "mediums"))
  
  tab_1 %>% 
    bind_rows(tab_2) %>% 
    bind_rows(tab_3) %>% 
    bind_rows(tab_4) %>% 
    bind_rows(sub_df %>% 
                filter(!(variable %in% c("sourcesOfFire", "coverages",
                                         "jobs", "mediums"))))
}


# función ca
CAvar_gg_fun <- function(var.nom = "country", 
                         fecha.min = "2005-01-01",
                         fecha.max = "2017-12-01", 
                         var.size = 5, 
                         col.size = 3){
  
  require(ggrepel)
  require(FactoMineR)
  
  tab.x <- df_cpj_tidy %>% 
    filter(variable == var.nom, 
           month_year >= fecha.min, 
           month_year <= fecha.max) %>% 
    # mutate(value = fct_lump(value, n = 10, ties.method = "random")) %>% 
    group_by(value, impunity) %>% 
    tally %>% 
    ungroup %>% 
    complete(nesting(value), impunity, fill = list(n = 0) ) %>% 
    spread(impunity, n) %>% 
    data.frame(check.names = F)
  
  if(var.nom == "country"){
    ind <- apply(tab.x[, -1], 1, sum)  > 2
  }else{
    ind <- rep(T, nrow(tab.x))
  }
  
  row.names(tab.x) <- tab.x$value
  ca.fit <- CA(tab.x[ind, -1], graph = F)
  # summary(ca.fit, nb.dec = 2, ncp = 2)
  
  mca1_vars_df <- data.frame(ca.fit$col$coord) %>% 
    rownames_to_column("columna")
  mca1_obs_df <- data.frame(ca.fit$row$coord) %>% 
    rownames_to_column("renglon") 
  
  # pal <- colorRampPalette()
  ggplot(data = mca1_obs_df, 
         aes(x = Dim.1, y = Dim.2)) + 
    geom_density2d(color = "gray80") +
    geom_hline(yintercept = 0, linetype = 2) +
    geom_vline(xintercept = 0, linetype = 2) +
    geom_point(data = mca1_vars_df, 
               size = 3,
               aes(x = Dim.1, y = Dim.2, 
                   color = columna)) +
    geom_text_repel(data = mca1_vars_df, 
                    fontface = "bold", 
                    size = var.size,
                    aes(x = Dim.1, y = Dim.2, 
                        label = columna, 
                        color = columna)) +
    geom_point(color = "gray50", alpha = 0.7) + 
    geom_text_repel(aes(label = renglon),
                    alpha = .6) + 
    theme(legend.position = "none") +
    scale_size_manual(values = c(6, 4.5)) 
}
