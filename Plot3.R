## Load the necessary libraries. 
## If not installed, install and load the required libraries

packages <- c("data.table")
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
        install.packages(packages[!installed_packages])
}
invisible(lapply(packages, library, character.only = TRUE))


## Download and load the data if not downloaded and loaded 

dir_path <- getwd() ## Get the path of the current/working directory


## Create data url and path to unzip data and download the data

data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zip_data_file <- "household_power_consumption.zip"
unzip_dir <- "data"


# Check if the file already exists in the current directory then download data
if (!file.exists(zip_data_file)) {
        download.file(data_url, zip_data_file) # If the file does not exist, download it
        print("File downloaded successfully.")
} else {
        print("File already exists.")
}

# Check if the unzipped data folder already exists

if (!dir.exists(unzip_dir)){
        unzip(zip_data_file, exdir = unzip_dir) # If the folder does not exist, unzip the file
        print("Data unzipped successfully.")
} else {
        print("Data folder already exists.")
}

data <- data.table::fread("data/household_power_consumption.txt",
                          na.strings = "?")

## Convert Date to Date format

data$Date <- as.Date(data$Date, format = "%d/%m/%Y")


## Subset the data for the given period

data_power <- subset(data, Date >= "2007-02-01" & Date <= "2007-02-02")

## Merge Datetime to make single column and format to dattime format

data_power$DateTime <- as.POSIXct(paste(as.Date(data_power$Date), data_power$Time))

## Plot Timeseries of Global Active Power and save plot in Plot3.png

{
        png("Plot3.png", width=720, height=720)
        
        plot(data_power$Sub_metering_1 ~ data_power$DateTime, type = "l",
             ylab = "Energy sub metering",
             xlab = "", xaxt = "n")
        lines(data_power$Sub_metering_2 ~ data_power$DateTime, col = "Red")
        lines(data_power$Sub_metering_3 ~ data_power$DateTime, col = "Blue")
        axis(1, at = c(as.numeric(min(data_power$DateTime)), 
                       as.numeric(min(data_power$DateTime)) + 86400,
                       as.numeric(min(data_power$DateTime)) + 2*86400),
             labels = c("Thu", "Fri", "Sat"))
        legend("topright", col = c("black", "red", "blue"),
               legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
               lty = c(1,1), lwd = c(1,1))
        
        dev.off()
}