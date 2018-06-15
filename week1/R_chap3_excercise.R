library(tidyverse)

# Excercise 2 p151
new_4a <- gather(table4a,"year","cases", 2:3)
new_4b <- gather(table4b,"year","population", 2:3)
table4 <- inner_join(new_4a,new_4b)

table4 %>% 
  mutate(rate = cases/population*10000)

table2%>% spread(key= type, value=count) %>%
  mutate(rate = cases/population*10000)
#

#Exercise 1 p156
stocks <- tibble(
  year = c(20 15, 2015, 2016, 2016),
  half = c(1,2,1,2),
  return = c(1.88, 0.59, 0.92, 0.17)
)

stocks %>% spread(year, return) %>% gather("year", "return",'2015':'2016')

#Excercise 3 p156
people <- tribble(
  ~name, ~key, ~value,
  "Phill", "age", 45,
  "Phill", "height", 186,
  "Phill", "age", 50
)
people %>% group_by(name, key) %>% 
  mutate(order = rank(name, ties.method = "last")) %>% ungroup() %>%
  mutate(key = ifelse(order ==2,"original",key)) %>% select(-order) %>% spread (key,value)
  
