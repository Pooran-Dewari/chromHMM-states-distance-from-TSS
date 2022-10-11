library(tidyverse)
library(scales)

#list files
files <- list.files(pattern="/*.bed")

#read all tsv into one matrix and then bind rows to create one df
df <- lapply(files,function(i){
  read_tsv(i, col_names = FALSE)}) %>% 
  bind_rows()

#perform log transformation; also convert 0 -> 1
#mutate(log10 = ifelse(condition1, value1, ifelse(condition2, value2, value3))
df_log <- df %>%
  mutate(log_10 = if_else(df$X9 > 0,log10(df$X9),
         if_else(df$X9 < 0, -log10(-df$X9), log10(1))))


#order the legends
order<- unique(df_log$X10)
df_log$X10 <- factor(df_log$X10, levels = c(
  order[11], order[6], order[15], order[7], order[8], order[1],
  order[12], order[13], order[14], order[3], 
  order[4], order[5],order[2], order[9], order[10])
  )


#plot density & colour by chromatin state
plot <- df_log %>%
  ggplot(aes(x=log_10)) +
  geom_density(aes(color = X10), size=0.6)+
  scale_x_continuous(breaks = seq(-9, 9, by = 1))+
  xlab("\n Distance from TSS in log10(bp) \n")+
  ylab("\n Density \n")+
  theme_minimal()+
  theme(axis.text.y = element_text(size = 12), axis.text.x = element_text(size = 13)) +
  theme(axis.title.x = element_text(color = "black", size = 16),
        axis.title.y = element_text(color = "black", size = 16),
        plot.title = element_text(size = 20),
        plot.subtitle = element_text(size = 15),
        legend.title = element_text(size = 13), 
        legend.text = element_text(size = 13))

plot<- update_labels(plot, list(colour="Chromatin States \n"))

my_col_palette<- c("red","#FF6600","#FFCC00","#CCFF00",
                   "#66FF00","green","#00FF66","#00FFCC",
                   "#00CCFF","#0066FF","blue","#6600FF",
                   "#CC00FF","#FF00CC","#FF0066")

plot + scale_color_manual(values = my_col_palette)

#.............................


#plot histogram
# plot <- df %>% 
#   filter(X9 >= -100000) %>% 
#   filter(X9 <= 100000) %>% 
#   ggplot(aes(x=X9)) +
#   geom_histogram(binwidth=1000,
#                  center = 501)+
#   scale_x_continuous(labels = unit_format(unit = "", scale = 1e-3),
#                      breaks = seq(-100000, 100000, by = 25000))+
#   
#   xlab("Distance from TSS in Kb")+
#   ylab("Frequency")+
#   theme_bw()+
#   facet_wrap(~X10)

