

load("data/df_cpj_union.RData")
load("data/df_cpj_tidy.RData")


# global functions
CAvar_gg_fun <- function(var.nom = "country", 
                         fecha.min = "2005-01-01",
                         fecha.max = "2017-12-01", 
                         var.size = 9, 
                         col.size = 5){
  
  require(ggrepel)
  require(FactoMineR)
  
  summ.vars <- df_cpj_tidy %>% 
    filter(variable == var.nom, 
           date_registered >= fecha.min, 
           date_registered <= fecha.max) 
  
  tab.x <- summ.vars %>% 
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
  
  mca1_vars_df <- data.frame(ca.fit$col$coord) %>% 
    rownames_to_column("columna")
  mca1_obs_df <- data.frame(ca.fit$row$coord) %>% 
    rownames_to_column("renglon") 
  
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
                    size = col.size,
                    alpha = .6) + 
    theme(legend.position = "none") +
    scale_size_manual(values = c(6, 4.5)) + 
    labs(caption=paste( "Datos disponibles de",
                   min(summ.vars$date_registered),
                   "a",
                   max(summ.vars$date_registered) )) + 
    ylab("Dim 2") + 
    xlab("Dim 1")
}
