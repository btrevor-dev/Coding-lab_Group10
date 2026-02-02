#!/bin/bash

# ---------------------------------
# Intelligent Log Analysis Script
# ---------------------------------

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

# Map choice to log file and thresholds
case $choice in
    1)
        logfile="hospital_data/active_logs/heart_rate.log"
        label="Heart Rate"
        min_th=40
        max_th=120
        ;;
    2)
        logfile="hospital_data/active_logs/temperature.log"
        label="Temperature"
        min_th=35
        max_th=39
        ;;
    3)
        logfile="hospital_data/active_logs/water_usage.log"
        label="Water Usage"
        min_th=0
        max_th=500
        ;;
esac

# Check if log file exists
if [ ! -f "$logfile" ]; then
    echo "Error: Log file $logfile not found."
    exit 1
fi

# Ensure reports directory exists
mkdir -p hospital_data/reports
report_file="hospital_data/reports/analysis_report.txt"

echo
echo "Analyzing $logfile ..."
echo "-----------------------------------"

# Device activity count
device_counts=$(awk '{print $3}' "$logfile" | sort | uniq -c)

# First and last timestamps
first_entry=$(head -n 1 "$logfile" | awk '{print $1, $2}')
last_entry=$(tail -n 1 "$logfile" | awk '{print $1, $2}')

# Statistics: min, max, average
stats=$(awk '
{sum+=$4; if(NR==1 || $4<min) min=$4; if(NR==1 || $4>max) max=$4}
END {printf "Min: %.2f\nMax: %.2f\nAverage: %.2f\n", min, max, sum/NR}
' "$logfile")

# Detect anomalies outside thresholds
anomalies=$(awk -v min="$min_th" -v max="$max_th" '$4<min || $4>max' "$logfile")

# Display results to terminal
echo "Device activity count:"
echo "$device_counts"
echo
echo "First entry : $first_entry"
echo "Last entry  : $last_entry"
echo
echo "Statistics:"
echo "$stats"
echo
echo "Anomalies (outside $min_th-$max_th):"
if [ -z "$anomalies" ]; then
    echo "None detected"
else
    echo "$anomalies"
fi

# Append results to report file
{
    echo "=== $label Log Analysis ==="
    echo "Analysis run on: $(date)"
    echo "Log file analyzed: $logfile"
    echo
    echo "Device activity count:"
    echo "$device_counts"
    echo
    echo "First entry : $first_entry"
    echo "Last entry  : $last_entry"
    echo
    echo "Statistics:"
    echo "$stats"
    echo
    echo "Anomalies (outside $min_th-$max_th):"
    if [ -z "$anomalies" ]; then
        echo "None detected"
    else
        echo "$anomalies"
    fi
    echo "-------------------------------------------"
    echo
} >> "$report_file"

echo
echo "Analysis appended to $report_file"
echo "Analysis completed successfully."

