library(tidyverse)
library(scales)

#list files
files <- list.files(pattern="/*.bed")

#read all tsv into one matrix and then bind rows to create one df
df <- lapply(files,function(i){
  read_tsv(i, col_names = FALSE)}) %>% 
  bind_rows()

#plot
df %>% 
  filter(X9 >= -100000) %>% 
  filter(X9 <= 100000) %>% 
  ggplot(aes(x=X9)) +
  geom_histogram(binwidth=1000,
                 center = 501)+
  scale_x_continuous(labels = unit_format(unit = "Kb", scale = 1e-3),
                     breaks = seq(-100000, 100000, by = 20000))+
  
  xlab("Distance from TSS")+
  ylab("Frequency")+
  theme_bw()+
  facet_wrap(~X10)
