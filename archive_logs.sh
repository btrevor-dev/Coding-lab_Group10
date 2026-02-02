#!/bin/bash
echo "Select log to archive:"
echo "1.Heart rate"
echo "2.Temperature "
echo "3.Water usage"
read -p "Enter choice (1-3):" choice
# validating user input
if [[ ! $choice =~ ^[1-3]$ ]]; then 
    echo "Invalid selection. Please enter 1, 2, or 3."
    exit 1
fi
# Map choice to log file and archive directory
case $choice in
    1)
        logfile="hospital_data/active_logs/heart_rate.log"
        archive_dir="hospital_data/archives/heart_data_archive"
        ;;
    2)
        logfile="hospital_data/active_logs/temperature.log"
        archive_dir="hospital_data/archives/temperature_data_archive"
        ;;
    3)
        logfile="hospital_data/active_logs/water_usage.log"
        archive_dir="hospital_data/archives/water_data_archive"
        ;;
esac

# Check if log file exists
if [ ! -f "$logfile" ]; then
    echo "Error: Log file $logfile not found."
    exit 1
fi

# Ensure archive directory exists
if [ ! -d "$archive_dir" ]; then
    mkdir -p "$archive_dir" || { echo "Error: Cannot create archive directory $archive_dir"; exit 1; }
fi

# Create timestamp for archiving
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
filename=$(basename "$logfile" .log)
archived_file="$archive_dir/${filename}_$timestamp.log"

# Move and rename the log file
echo "Archiving $logfile..."
mv "$logfile" "$archived_file" || { echo "Error: Failed to move $logfile"; exit 1; }

# Create a new empty log for continued monitoring
touch "$logfile" || { echo "Error: Cannot create new log file $logfile"; exit 1; }

# Success message
echo "Successfully archived to $archived_file"
