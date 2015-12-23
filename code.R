# assignment 1
# load data from activity.zip

data <- read.csv("activity.csv")


cleandata <- data[complete.cases(data),]

cleandata1 <- subset(cleandata, select = -interval)


sumdata <- aggregate(cleandata$steps, by=list(cleandata$date), FUN=sum)

mean(sumdata$x)
median(sumdata$x)

fiveminintervals <- aggregate(cleandata$steps, by=list(interval = cleandata$interval), FUN=mean)

plot(fiveminintervals$interval, fiveminintervals$x, type = "l", ylab = "Average number of steps", xlab = "Interval")
lines(fiveminintervals$interval, fiveminintervals$x)

max(fiveminintervals$x)

fiveminintervals[fiveminintervals$x == max(fiveminintervals$x),]$interval

# Imputing missing values
