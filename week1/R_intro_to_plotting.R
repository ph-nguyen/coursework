library(tidyverse)
theme_set(theme_bw())
mpg
summary(mpg)

ggplot(data=mpg) + geom_point(mapping = aes(x= displ, y = hwy, color = class))

gg plot(data=mpg) + geom_point(mapping = aes(x= displ, y = hwy, color = class, size = cty))

ggplot(data=mpg) + geom_point(mapping = aes(x= displ, y = hwy, alpha = class))

#manually set up the color by pull it out of the mapping
ggplot(data=mpg) + geom_point(mapping = aes(x= displ, y = hwy), color = "blue")

#facet plot
ggplot(data=mpg) + geom_point(mapping = aes(x= displ, y = hwy)) +
  facet_wrap(~ class)

#cylinder is the column and drv is the row and  the range is set with the whole dataset
ggplot(data=mpg) + geom_point(mapping = aes(x= displ, y = hwy)) +
  facet_grid(drv ~ cyl,labeller= label_both)
# to set the range within panel, use scale = "free_y"

gglot(mpg, aes(x=displ, y = hwy)) +
  geom_point() +
  geom_smooth()

#be careful about what you want to tell. Hence the color 
gglot(mpg, aes(x=displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(color= "black")

#in geom_bar, using stack bar plot is very hard to see. Hence, use position="dodge" instead
# find the median
mpg %>% 
  group_by(class) %>% 
  summarise(lower = quantile (hwy, 0.25),
    middle = median(hwy),
    upper = quantile (hwy, 0.75))

#colorbrewer2.org <- website to choose the color scheme 