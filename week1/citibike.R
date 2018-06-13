library(tidyverse)
library(lubridate)

########################################
# READ AND TRANSFORM THE DATA
########################################

# read one month of data
trips <- read_csv('201402-citibike-tripdata.csv')

# replace spaces in column names with underscores
names(trips) <- gsub(' ', '_', names(trips))

# convert dates strings to dates
#trips <- mutate(trips, starttime = mdy_hms(starttime), stoptime = mdy_hms(stoptime))

# recode gender as a factor 0->"Unknown", 1->"Male", 2->"Female"
trips <- mutate(trips, gender = factor(gender, levels=c(0,1,2), labels = c("Unknown","Male","Female")))


########################################
# YOUR SOLUTIONS BELOW
########################################

# count the number of trips (= rows in the data frame)
nrow(na.omit(trips))
# find the earliest and latest birth years (see help for max and min to deal with NAs)
max(as.numeric(trips$birth_year), na.rm =  TRUE)
min(as.numeric(trips$birth_year), na.rm =  TRUE)

# use filter and grepl to find all trips that either start or end on broadway
filter(trips, grepl('Broadway', start_station_name) | grepl('Broadway', end_station_name)) %>% 
  select(start_station_name, end_station_name)

# do the same, but find all trips that both start and end on broadway
filter(trips, grepl('Broadway', start_station_name) , grepl('Broadway', end_station_name)) %>% 
  select(start_station_name, end_station_name)

# find all unique station names
#several ways to answer this
unique(c(trips$start_station_name, trips$end_station_name))
trips %>% distinct(start_station_name)
union(trips$start_station_name, trips$end_station_name)

# count the number of trips by gender
summarize(group_by(trips, gender),
          count = n())

# compute the average trip time by gender
summarize(group_by(trips, gender),
          mean_trip_time= mean(tripduration))


# comment on whether there's a (statistically) significant difference
#One average, there is a differences between the trip duration of men and women. 
#even though the number of women use citibike is less than men, their trip duration is higher on average
#To find if there's a statistically significant, we will have to compute the p-value to reject null hypothesis


# find the 10 most frequent station-to-station trips 
common_trip <- group_by(trips, start_station_name, end_station_name) %>%
  summarize(count= n()) %>% 
  arrange(desc(count)) %>% 
  head(10)


# find the top 3 end stations for trips starting from each start station
select(common_trip, start_station_name, end_station_name) %>%
  summarize(count= n()) %>% 
  group_by(start_station_name) %>%
  filter(rank(desc(count)) < 4) %>%
  arrange(start_station_name, desc(count))

# find the top 3 most common station-to-station trips by gender
group_by(trips,start_station_name, end_station_name, gender) %>% 
  summarize(count= n()) %>%
  group_by(gender) %>%
  filter(rank(desc(count)) < 4) %>%
  arrange(gender, desc(count))
  
# find the day with the most trips
# tip: first add a column for year/month/day without time of day (use as.Date or floor_date from the lubridate package)

start_ymd <- mutate(trips, ymd = as.Date(starttime))

summarize(group_by(start_ymd,ymd), count= n()) %>% filter(rank(desc(count)) < 2)

# compute the average number of trips taken during each of the 24 hours of the day across the entire month
start_ymd %>%
  mutate(daily_hour= hour(starttime)) %>%
  group_by (ymd, daily_hour) %>%
  summarise(count = n ()) %>%
  group_by(daily_hour) %>%
  summarise(avg= mean(count))

# what time(s) of day tend to be peak hour(s)? (top 5)

start_ymd %>%
  mutate(daily_hour= hour(starttime)) %>%
  group_by (ymd, daily_hour) %>%
  summarise(count = n ()) %>%
  group_by(daily_hour) %>%
  summarise(avg= mean(count)) %>%
  filter(rank(desc(avg)) < 6)
  
