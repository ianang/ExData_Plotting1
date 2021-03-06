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

### drawing the histogram on device screen

dev.off() # resetting par() options

hist(hpc$Global_active_power, col="red",
                              ylab="Frequency",
                              xlab="Global Active Power (kilowatts)",
                              main="Global Active Power")

### saving it as a png file

dev.copy(png, file="plot1.png")
dev.off()