### downloading data

URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(URL, "./household_power_consumption.zip")

### unzipping data

unzip("./household_power_consumption.zip")

### reading data into table

hpc <- read.table("./household_power_consumption.txt", sep = ";", header = TRUE)

### converting dates in table

hpc$datetime <- strptime(paste(hpc[,1],hpc[,2]), format = "%d/%m/%Y %H:%M:%S")
hpc$Date <- NULL
hpc$Time <- NULL

### deleting unrequired dates to reduce table size and increase speed

library(lubridate)
hpc <- hpc[year(hpc$datetime) == 2007,]
hpc <- hpc[month(hpc$datetime) == 2,]
hpc <- hpc[day(hpc$datetime) %in% c(1,2),]

### replacing all question marks (missing values) with NA

hpc$Global_active_power   <- gsub("\\?", "NA", hpc$Global_active_power)
hpc$Global_reactive_power <- gsub("\\?", "NA", hpc$Global_reactive_power)
hpc$Voltage               <- gsub("\\?", "NA", hpc$Voltage)
hpc$Global_intensity      <- gsub("\\?", "NA", hpc$Global_intensity)
hpc$Sub_metering_1        <- gsub("\\?", "NA", hpc$Sub_metering_1)
hpc$Sub_metering_2        <- gsub("\\?", "NA", hpc$Sub_metering_2)

### re-classing numeric/integer columns stored as characters

hpc$Global_active_power   <- as.numeric(hpc$Global_active_power)
hpc$Global_reactive_power <- as.numeric(hpc$Global_reactive_power)
hpc$Voltage               <- as.numeric(hpc$Voltage)
hpc$Global_intensity      <- as.numeric(hpc$Global_intensity)
hpc$Sub_metering_1        <- as.integer(hpc$Sub_metering_1)
hpc$Sub_metering_2        <- as.integer(hpc$Sub_metering_2)
hpc$Sub_metering_3        <- as.integer(hpc$Sub_metering_3)

### drawing the four plots on device screen

par(mfcol=c(2,2), mar=c(5,4,2,1))

# plot 1

plot(hpc$datetime, hpc$Global_active_power, type="n",
     ylab="Global Active Power",
     xlab="",
     main="")

lines(hpc$datetime, hpc$Global_active_power)

# plot 2

plot(hpc$datetime, hpc$Global_active_power, type="n",
     ylab="Energy sub metering",
     xlab="",
     main="",
     ylim=c(0,38))

lines(hpc$datetime, hpc$Sub_metering_1, col="black")
lines(hpc$datetime, hpc$Sub_metering_2, col="red")
lines(hpc$datetime, hpc$Sub_metering_3, col="blue")

legend("topright", col=c("black","red","blue"),
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lwd=c(1,1,1),
       bty="n")

# plot 3

with(hpc, plot(datetime, Voltage, type="n"))
with(hpc, lines(datetime, Voltage))

# plot 4

with(hpc, plot(datetime, Global_reactive_power, type="n"))
with(hpc, lines(datetime, Global_reactive_power))

### saving it as a png file

dev.copy(png, file="plot4.png")
dev.off()