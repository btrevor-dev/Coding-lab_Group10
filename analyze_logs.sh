#!/bin/bash

# ---------------------------------
# Intelligent Log Analysis Script
# ---------------------------------

# Prompt user
echo "Select log file to analyze:"
echo "1) Heart Rate (heart_rate.log)"
echo "2) Temperature (temperature.log)"
echo "3) Water Usage (water_usage.log)"
read -p "Enter choice (1-3): " choice

# Validate input
if [[ ! $choice =~ ^[1-3]$ ]]; then
    echo "Invalid selection. Please enter 1, 2, or 3."
    exit 1
fi

# Map choice to log file
case $choice in
    1) logfile="hospital_data/active_logs/heart_rate.log" ;;
    2) logfile="hospital_data/active_logs/temperature.log" ;;
    3) logfile="hospital_data/active_logs/water_usage.log" ;;
esac

# Check if log file exists
if [ ! -f "$logfile" ]; then
    echo "Error: Log file $logfile not found."
    exit 1
fi

# Create reports directory if missing
mkdir -p hospital_data/reports

echo
echo "Analyzing $logfile ..."
echo "-----------------------------------"

# Get device counts
device_counts=$(awk '{print $3}' "$logfile" | sort | uniq -c)

# Get first and last timestamps (bonus)
first_entry=$(head -n 1 "$logfile" | awk '{print $1, $2}')
last_entry=$(tail -n 1 "$logfile" | awk '{print $1, $2}')

# Display results to terminal
echo "Device activity count:"
echo "$device_counts"
echo
echo "First entry : $first_entry"
echo "Last entry  : $last_entry"

# Append results to report file
{
echo "Analysis run on: $(date)"
echo "Log file analyzed: $logfile"
echo "Device activity count:"
echo "$device_counts"
echo "First entry : $first_entry"
echo "Last entry  : $last_entry"
echo "-------------------------------------------"
} >> hospital_data/reports/analysis_report.txt

echo
echo "Analysis appended to hospital_data/reports/analysis_report.txt"
echo "Analysis completed successfully."
