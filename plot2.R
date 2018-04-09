## Downloads file if it does not already exist in directory
if(!file.exists("exdata_data_household_power_consumption.zip")) {
  temp <- tempfile()
  download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
  file <- unzip(temp)
  unlink(temp)
}

## Define data set to be variable 'power' 
power <- read.table(file, header=T, sep=";")

## Change date format
power$Date <- as.Date(power$Date, format="%d/%m/%Y")

## Create data frame of only time of interest
df <- power[(power$Date=="2007-02-01") | (power$Date=="2007-02-02"),]

## Convert strings to numerics
df$Global_active_power <- as.numeric(as.character(df$Global_active_power))
df$Global_reactive_power <- as.numeric(as.character(df$Global_reactive_power))
df$Voltage <- as.numeric(as.character(df$Voltage))

## Change time format
df <- transform(df, timestamp=as.POSIXct(paste(Date, Time)), "%d/%m/%Y %H:%M:%S")

## Convert strings to numerics
df$Sub_metering_1 <- as.numeric(as.character(df$Sub_metering_1))
df$Sub_metering_2 <- as.numeric(as.character(df$Sub_metering_2))
df$Sub_metering_3 <- as.numeric(as.character(df$Sub_metering_3))

## Create line graph
plot(df$timestamp, df$Global_active_power, type = "l", frame.plot = TRUE, 
     xlab = "", ylab = "Global Active Power (kilowatts)", main = "Global Active Power")

## Create PNG file
dev.copy(png, file = "plot2.png", width = 480, height = 480)
dev.off()