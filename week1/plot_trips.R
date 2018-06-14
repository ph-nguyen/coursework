########################################
# load libraries
########################################

# load some packages that we'll need
library(tidyverse)
library(scales)

# be picky about white backgrounds on our plots
theme_set(theme_bw())

# load RData file output by load_trips.R
load('trips.RData')


########################################
# plot trip data
########################################
trips %>% View

# plot the distribution of trip times across all rides

filter (trips, tripduration < quantile(tripduration, .99) ) %>% 
  ggplot(aes(x = tripduration/60)) +
  geom_histogram() +
  scale_x_log10(label = comma) +
  scale_y_continuous(label = comma) +
  xlab ('Trip duration') +
  ylab('Number of trips')
  
#might want to change the time to mins or hour and change the spread of x axis

# plot the distribution of trip times by rider type
filter (trips, tripduration < quantile(tripduration, .99) ) %>% 
  ggplot(aes(x = tripduration)) +
  geom_histogram() +
  scale_x_log10(label = comma) +
  facet_wrap(~ usertype, scale= 'free_y') +
  xlab ('Trip times') +
  ylab('Number of trips')

# plot the total number of trips over each day
trips %>% group_by(ymd) %>% summarize(count= n()) %>%
  ggplot (aes(x= ymd, y= count)) +
  geom_point()

# plot the total number of trips (on the y axis) by age (on the x axis) and age (indicated with color)
library(lubridate)
trips %>% 
  mutate(age = year(ymd) - birth_year) %>% 
  group_by(age) %>%
  summarise(count = n()) %>%
  ggplot(aes(x= age, y= count, color = gender)) +
  geom_point() +
  scale_y_continuous(label = comma) +
  xlim(c(16,80)) +
  ylab('Number of trips')


# plot the ratio of male to female trips (on the y axis) by age (on the x axis)
# hint: use the spread() function to reshape things to make it easier to compute this ratio
trips %>% 
  mutate(age = year(ymd) - birth_year) %>% 
  group_by(age, gender) %>%
  summarise(count = n()) %>%
  spread('gender','count') %>%
  mutate(ratio = Male/Female) %>%
  ggplot(aes(x= age, y= ratio)) +
  geom_point() +
  geom_smooth()+
  xlim(c(16,70)) +
  ylab('Number of trips')
  
########################################
# plot weather data
########################################
# plot the minimum temperature (on the y axis) over each day (on the x axis)
View(weather)
ggplot(weather, aes(x= ymd, y= tmin))+
   geom_point() +
   xlab ('Day') +
   ylab('Minimum temperature')

# plot the minimum temperature and maximum temperature (on the y axis, with different colors) over each day (on the x axis)
# hint: try using the gather() function for this to reshape things before plotting

weather %>% gather ("MaxMin", "Temperature", tmax, tmin) %>%
  ggplot(aes(x= ymd, y = Temperature, color= MaxMin)) +
  geom_point() +
  xlab ('Day') +
  ylab('Temperature')
  
########################################
# plot trip and weather data
########################################

# join trips and weather
trips_with_weather <- inner_join(trips, weather, by="ymd")

# plot the number of trips as a function of the minimum temperature, where each point represents a day
# you'll need to summarize the trips and join to the weather data to do this
trips_with_weather%>% 
  group_by(ymd, tmin) %>% 
  summarize(count= n()) %>%
  ggplot (aes(x= tmin, y= count)) +
  geom_point(position='jitter') +
  xlab ('Minimum Temperature') +
  ylab('Number of ride')

# repeat this, splitting results by whether there was substantial precipitation or not
# you'll need to decide what constitutes "substantial precipitation" and create a new T/F column to indicate this
summary(trips_with_weather$prcp) #choose the 3rd quatile as the benchmark
trips_with_weather%>% 
  mutate(big_prcp = ifelse(prcp> 0.0300,"T", "F")) %>%
  group_by(ymd, tmin, big_prcp) %>%
  summarise(count= n()) %>%
  ggplot (aes(x= tmin, y= count)) +
  geom_point(position='jitter') +
  facet_wrap(~ big_prcp) +
  xlab ('Minimum Temperature') +
  ylab('Number of ride')

# add a smoothed fit on top of the previous plot, using geom_smooth
trips_with_weather%>% 
  mutate(big_prcp = ifelse(prcp> 0.0300,"T", "F")) %>%
  group_by(ymd, tmin, big_prcp) %>%
  summarise(count= n()) %>%
  ggplot (aes(x= tmin, y= count)) +
  geom_point(position='jitter') +
  facet_wrap(~ big_prcp) +
  xlab ('Minimum Temperature') +
  ylab('Number of ride') +
  geom_smooth()

# compute the average number of trips and standard deviation in number of trips by hour of the day
# hint: use the hour() function from the lubridate package
library(lubridate)
trips_with_weather %>% mutate(hour = hour(starttime)) %>%
  group_by(ymd, hour) %>% 
  count() %>%
  group_by(hour) %>%
  summarize (mean (n), sd (n)) 
# plot the above
trips_with_weather %>% mutate(hour = hour(starttime)) %>%
  group_by(ymd, hour) %>% 
  summarize(tripnum = n()) %>%
  group_by(hour) %>%
  summarize (avg= mean (tripnum), stdv= sd (tripnum)) %>%
  ggplot(aes(x= hour , y= avg)) +
  geom_line() +
  geom_ribbon(aes(ymin = avg - stdv, ymax = avg + stdv), alpha= 0.2) +
  xlab ('Hour in Day') +
  ylab('Statistics')

# repeat this, but now split the results by day of the week (Monday, Tuesday, ...) or weekday vs. weekend days
# hint: use the wday() function from the lubridate package
trips_with_weather %>% mutate(hour = hour(starttime), dayw= wday(ymd, label = T)) %>%
  group_by(ymd, hour, dayw) %>% 
  count() %>%
  group_by(hour, dayw) %>%
  summarize (avg= mean (n), stdv= sd (n)) %>%
  ggplot(aes(x= hour, y= avg)) +
  geom_line() +
  geom_ribbon(aes(ymin = avg - stdv, ymax = avg + stdv), alpha= 0.2) +
  facet_wrap(~ dayw) +
  xlab ('Hour in Day') +
  ylab('Statistics')

