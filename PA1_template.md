---
output: 
  html_document: 
    keep_md: yes
    self_contained: no
---

Reproducible Research: Peer Assessment 1
========================================
**Dmitri Perov**

Source code: https://github.com/dperov/RepData_PeerAssessment1  

## Loading requires libraries and setting english locale


```r
library(Hmisc)
library(plyr)
Sys.setlocale("LC_ALL","English")
```

## Loading and preprocessing the data

```r
data <- read.csv("activity.csv")
```


## What is mean total number of steps taken per day?

1. Make a histogram of the total number of steps taken each day


```r
steps_by_date <- aggregate(steps ~ date, data = data, FUN=sum)
barplot(steps_by_date$steps, names.arg=steps_by_date$date, xlab="date", ylab="steps")
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png) 

2. Calculate and report the **mean** and **median** total number of
   steps taken per day


```r
mean(steps_by_date$steps)
```

```
## [1] 10766.19
```

```r
median(steps_by_date$steps)
```

```
## [1] 10765
```

## What is the average daily activity pattern?


1. Make a time series plot (i.e. `type = "l"`) of the 5-minute
   interval (x-axis) and the average number of steps taken, averaged
   across all days (y-axis)


```r
steps_interval <- aggregate(steps ~ interval, data=data, FUN=mean)
plot(steps_interval, type="l")
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png) 

2. Which 5-minute interval, on average across all the days in the
   dataset, contains the maximum number of steps?


```r
steps_interval$interval[which.max(steps_interval$steps)]
```

```
## [1] 835
```



## Imputing missing values


1. Calculate and report the total number of missing values in the
   dataset (i.e. the total number of rows with `NA`s)


```r
sum(is.na(data))
```

```
## [1] 2304
```

2. Devise a strategy for filling in all of the missing values in the
   dataset. The strategy does not need to be sophisticated. For
   example, you could use the mean/median for that day, or the mean
   for that 5-minute interval, etc.

I use the mean of 5-minute interval for substituting missing values



3. Create a new dataset that is equal to the original dataset but with
   the missing data filled in.


```r
data$imp_steps <- with(data, impute(steps, mean))
data$steps <- NULL
data <- rename(data, c("imp_steps"="steps"))
```


4. Make a histogram of the total number of steps taken each day and
   Calculate and report the **mean** and **median** total number of
   steps taken per day. Do these values differ from the estimates from
   the first part of the assignment? What is the impact of imputing
   missing data on the estimates of the total daily number of steps?


```r
steps_by_date <- aggregate(steps ~ date, data = data, FUN=sum)
barplot(steps_by_date$steps, names.arg=steps_by_date$date, xlab="date", ylab="steps")
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9-1.png) 

```r
mean(steps_by_date$steps)
```

```
## [1] 10766.19
```

```r
median(steps_by_date$steps)
```

```
## [1] 10766.19
```


## Are there differences in activity patterns between weekdays and weekends?


1. Create a new factor variable in the dataset with two levels --
   "weekday" and "weekend" indicating whether a given date is a
   weekday or weekend day.
   
  

```r
data$daytype <- as.factor(
  ifelse( (weekdays(as.Date(data$date)) %in%  c("Saturday", "Sunday")), "weekend", "weekday") ) 
```
   
   
2. Make a panel plot containing a time series plot (i.e. `type = "l"`)
   of the 5-minute interval (x-axis) and the average number of steps
   taken, averaged across all weekday days or weekend days
   (y-axis).
   

```r
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
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-11-1.png) 
