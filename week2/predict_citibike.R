library(ggplot2)
library(tidyverse)

load('trips14.RData')
holiday <- read.csv('US Bank Holidays 2012-2020.csv') %>% mutate(ymd = as.Date(Date, "%m/%d/%Y")) %>% select(ymd, Bank.Holiday)

trip_per_day_14 <- trips %>% group_by(ymd) %>% summarise(ride_daily = n())
trip_weather_14 <- left_join(trip_per_day_14,weather) %>% filter(date>0)
trip_w_holiday_14 <- left_join(trip_weather_14, holiday) %>% replace_na(list(Bank.Holiday = "FALSE"))

trip_w_holiday_14$wday <- weekdays(as.Date(trip_w_holiday$date))

set.seed(101)

## 80% of the sample size

smp_size <- floor(0.8 * nrow(trip_w_holiday_14))

## set the seed to make your partition reproducible


train_ind <- sample(seq_len(nrow(trip_w_holiday_14)), size = smp_size)

train <- data.frame(trip_w_holiday_14[train_ind, ])
test <- data.frame(trip_w_holiday_14[-train_ind, ])

#Fit the model
reg <- lm(formula = ride_daily ~ tmax+ tmin * I(tmin^2) + prcp + wday + snwd + Bank.Holiday  , data =train)
summary(reg) #R-sq= .88

test$reg_hat <- predict(reg, newdata =test)
cor(test$reg_hat, test$ride_daily)^2 # 0.89

rmse(reg, test) #3431
rmse(reg, train) #3536

#Plotting
test %>% ggplot( aes(ymd, ride_daily, color= Bank.Holiday)) +
  geom_line( aes(y= reg_hat)) +
  geom_point()+
  xlab('Date') +
  ylab('Total ride daily')

test %>% ggplot( aes(reg_hat, ride_daily, color= Bank.Holiday)) +
  geom_point() +
  xlab('predicted') +
  ylab('Actual ride daily')

#saving model
mod_14 <- lm(formula = ride_daily ~ tmax+ tmin * I(tmin^2) + prcp + wday + snwd + Bank.Holiday  , data = trip_w_holiday_14)
summary(mod_14)
save(mod_14, file= 'mod14.RData')
