#!/bin/bash

# add your solution after each of the 10 comments below
# set the variable name
file="./201402-citibike-tripdata.csv"
# head -n1 $file | tr , '\n' | cat -n;

# # count the number of unique stations
tail -n +2 $file | cut -d, -f5,9 | tr , "\n" | sort | uniq | wc -l
# # count the number of unique bikes
tail -n +2 $file | cut -d, -f12 | tr , "\n" | sort | uniq | wc -l

# # count the number of trips per day
# #if we take the bike for one day and return it the other day, how can we compute it and which day should it belong to?
# #count the start time
tail -n +2 $file | cut -d, -f2 | tr -d \" |  awk -F" " '{print $1}' | sort | uniq -c | head

# #count the stop time
tail -n +2 $file | cut -d, -f3 | tr -d \" | awk -F" " '{print $1}' | sort | uniq -c | head

# # find the day with the most rides
tail -n +2 $file | cut -d, -f2 | tr -d \" | awk -F" " '{print $1}' | sort | uniq -c | sort -nr | head -n1

# # find the day with the fewest rides
tail -n +2 $file | cut -d, -f2 | tr -d \" | awk -F" " '{print $1}' | sort | uniq -c | sort -n | head -n1

# # find the id of the bike with the most rides
tail -n +2 $file | cut -d, -f12 | sort | uniq -c | sort -nr | tail +1

# # count the number of rides by gender and birth year
tail -n +2 $file | cut -d, -f14,15 | sort | uniq -c

# # count the number of trips that start on cross streets that both contain numbers (e.g., "1 Ave & E 15 St", "E 39 St & 2 Ave", ...)
awk -F, '$5 ~ /.*[0-9]+.*&.*[0-9]+./ {print $5}' $file | sort | uniq -c 

# compute the average trip duration 
# tail -n +2 $file | cut -d, -f3,2| tr -d \" |  awk -F" " '{print $1,$2}' | head
cut -d, -f1 $file | tail -n+2 | tr -d '"' | awk '{sum+=$1; n++} END {print sum/n}'
