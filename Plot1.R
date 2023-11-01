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

## Plot histogram and save plot in Plot1.png

{png("plot1.png", width=720, height=720)

hist(data_power$Global_active_power, main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)", ylab= "Frequency",
     col="Red")

dev.off()
}

