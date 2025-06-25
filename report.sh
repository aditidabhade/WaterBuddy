#!/bin/bash
# report.sh: Generates daily or weekly report with ASCII progress bar

# Load settings
if [ -f $(dirname "$0")/../data/settings.conf ]; then
    source $(dirname "$0")/../data/settings.conf
else
    echo "Error: data/settings.conf not found."
    exit 1
fi

# Function to generate progress bar
progress_bar() {
    local current=$1
    local total=$2
    local bars=10
    # Prevent division by zero
    if [ "$total" -eq 0 ]; then
        total=1
    fi
    # Cap current at total to avoid overflow
    local filled=$((current * bars / total))
    if [ $filled -gt $bars ]; then
        filled=$bars
    fi
    local empty=$((bars - filled))
    # Ensure empty is non-negative
    if [ $empty -lt 0 ]; then
        empty=0
    fi
    printf "["
    # Print filled portion
    if [ $filled -gt 0 ]; then
        printf "#%.0s" $(seq 1 $filled)
    fi
    # Print empty portion
    if [ $empty -gt 0 ]; then
        printf -- "-%.0s" $(seq 1 $empty)
    fi
    printf "] %s/%s\n" "$current" "$total"
}

# Function to generate daily report
generate_daily_report() {
    local date="$1"
    if [ -z "$date" ]; then
        date=$(date +%Y-%m-%d)
    fi
    # Sum intake for the given date
    total=$(grep "^$date," $(dirname "$0")/../data/water_log.txt | awk -F',' '{sum+=$2} END {print sum+0}')
    echo "Report for $date:"
    echo "Total intake: $total"
    echo "Daily goal: $GOAL"
    progress_bar $total $GOAL
}

# Function to generate weekly report
generate_weekly_report() {
    local end_date=$(date +%Y-%m-%d)
    local start_date=$(date -d "$end_date -6 days" +%Y-%m-%d)
    local total=0
    local days_met=0
    local day_count=0
    for ((i=0; i<7; i++)); do
        local date=$(date -d "$start_date +$i days" +%Y-%m-%d)
        local daily_total=$(grep "^$date," $(dirname "$0")/../data/water_log.txt | awk -F',' '{sum+=$2} END {print sum+0}')
        total=$((total + daily_total))
        if [ $daily_total -ge $GOAL ]; then
            days_met=$((days_met + 1))
        fi
        day_count=$((day_count + 1))
    done
    local avg=$(awk "BEGIN {print $total / $day_count}")
    echo "Weekly Summary ($start_date to $end_date):"
    echo "Total intake: $total"
    echo "Average daily intake: $avg"
    echo "Days meeting goal ($GOAL): $days_met/7"
}

# Handle arguments
case "$1" in
    --date) generate_daily_report "$2" ;;
    --weekly) generate_weekly_report ;;
    *) generate_daily_report ;;
esac
