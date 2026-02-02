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
