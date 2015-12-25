# assignment 1
# load data from activity.zip

library(Hmisc)
library(plyr)
Sys.setlocale("LC_ALL","English")

data <- read.csv("activity.csv")


steps_by_date <- aggregate(steps ~ date, data = data, FUN=sum)
barplot(steps_by_date$steps, names.arg=steps_by_date$date, xlab="date", ylab="steps")


steps_interval <- aggregate(steps ~ interval, data=data, FUN=mean)
plot(steps_interval, type="l")


steps_interval$interval[which.max(steps_interval$steps)]



sum(is.na(data))

data$imp_steps <- with(data, impute(steps, mean))
data$steps <- NULL
data <- rename(data, c("imp_steps"="steps"))

# check that there is no NAs
sum(is.na(data))

steps_by_date <- aggregate(steps ~ date, data = data, FUN=sum)
barplot(steps_by_date$steps, names.arg=steps_by_date$date, xlab="date", ylab="steps")
mean(steps_by_date$steps)
median(steps_by_date$steps)


data$daytype <- as.factor(
  ifelse( (weekdays(as.Date(data$date)) %in%  c("Saturday", "Sunday")), "weekend", "weekday") ) 

steps_weekend <- aggregate(steps ~ interval,
                           data=data,
                           subset=data$daytype=="weekend",
                           FUN=mean)
steps_weekday <- aggregate(steps ~ interval,
                           data=data,
                           subset=data$daytype=="weekday",
                           FUN=mean)

par(mfrow=c(2,1))
plot(steps_weekend, type="l", main="weekend")
plot(steps_weekday, type="l", main="weekday")
