library(ggplot2)
library(tidyverse)

load('trips.RData')
holiday <- read.csv('US Bank Holidays 2012-2020.csv') %>% mutate(ymd = as.Date(Date, "%m/%d/%Y")) %>% select(ymd, Bank.Holiday)

trip_per_day <- trips %>% group_by(ymd) %>% mutate(ride_daily = n())
trip_weather <- left_join(trip_per_day,weather) %>% filter(date>0) %>% mutate(avg_temp= (tmax + tmin)/2, age= 2014 - birth_year)
trip_w_holiday <- left_join(trip_weather, holiday) %>% replace_na(list(Bank.Holiday = "FALSE"))

set.seed(101)

## 80% of the sample size

smp_size <- floor(0.8 * nrow(trip_w_holiday))

## set the seed to make your partition reproducible


train_ind <- sample(seq_len(nrow(trip_w_holiday)), size = smp_size)

train <- data.frame(trip_w_holiday[train_ind, ])
test <- data.frame(trip_w_holiday[-train_ind, ])

#Fit the model
reg3 <- lm(formula = ride_daily ~ tmin* tmax * prcp * snwd + snow + Bank.Holiday, data =train)
summary(reg3) #0.77

#predict y
test$reg_hat3 <- predict(reg3, newdata =test)
cor(test$reg_hat3, test$ride_daily)^2 #0.77

rmse(reg3, test) #4022.296
rmse(reg3, train) #4020.63

#Plotting
test %>% ggplot( aes(ymd, ride_daily, color= Bank.Holiday)) +
  geom_line( aes(y= reg_hat3)) +
  geom_point()+
  xlab('Date') +
  ylab('Total ride daily')

test %>% ggplot( aes(reg_hat3, ride_daily, color= Bank.Holiday)) +
  geom_point() +
  xlab('predicted') +
  ylab('Actual ride daily')

#The interaction between tmax, prcp, snow depth is the highest predictive feature. So does the minimum temparature and snow depth, which is the the second highest predictive feature because it is the most elastic feature according to its coefficient.
