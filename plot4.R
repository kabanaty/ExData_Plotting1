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


plot4 <- function() {
  ## Set graphical parameters
  par(mfrow = c(2,2))
  
  ## Plot 1
  hist(df$Global_active_power, breaks = 12, freq = TRUE, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power")
  
  ## Plot 2
  plot(df$timestamp, df$Global_active_power, type = "l", frame.plot = TRUE, 
       xlab = "datetime", ylab = "Global Active Power (kilowatts)", main = "Global Active Power")
  
  ## Plot 3
  plot3 <- function() {
    ## Plot sub_metering lines
    plot(df$timestamp, df$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
    lines(df$timestamp, df$Sub_metering_2, col = "red")
    lines(df$timestamp, df$Sub_metering_3, col = "blue")
    ## Create legend  
    legend("topright", col = c("black", "red", "blue"), c("Sub_metering_1  ", "Sub_metering_2  ", "Sub_metering_3  "),
           lty = c(1,1), lwd = c(1,1), bty = "n", cex = .5)
                      }
  plot3()
  
  ## Plot 4
  plot(df$timestamp, df$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power")
  
  ## Create PNG file
  dev.copy(png, file = "plot4.png", width = 480, height = 480)
  dev.off()
}

plot4()