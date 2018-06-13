library(tidyverse)
library(lubridate)

trips <- read_csv('201402-citibike-tripdata.csv')

# replace spaces in column names with underscores

names(trips) <- gsub(' ', '_', names(trips))

summary(trips)
# convert dates strings to dates
# trips <- mutate(trips, starttime = mdy_hms(starttime), stoptime = mdy_hms(stoptime))

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
#find all string match with grepl. Then filter by condition to find row then access row.
filter(trips, grepl('Broadway', start_station_name) | grepl('Broadway', end_station_name)) %>% select(start_station_name, end_station_name)


# do the same, but find all trips that both start and end on broadway
filter(trips, grepl('Broadway', start_station_name) , grepl('Broadway', end_station_name)) %>% select(start_station_name, end_station_name)

# find all unique station names

sapply(df, function(x) unique(x)) %>% 
  select (start.station.name, end.station.name)

# count the number of trips by gender

summarize(group_by(trips, gender),
          count = n())

# compute the average trip time by gender
summarize(group_by(trips, gender),
          mean_trip_gen= mean(gender))
trips%>% group_by(gender) %>% summarize(count(n))

# comment on whether there's a (statistically) significant difference



# find the 10 most frequent station-to-station trips



# find the top 3 end stations for trips starting from each start station



# find the top 3 most common station-to-station trips by gender



# find the day with the most trips
# tip: first add a column for year/month/day without time of day (use as.Date or floor_date from the lubridate package)



# compute the average number of trips taken during each of the 24 hours of the day across the entire month


# what time(s) of day tend to be peak hour(s)?