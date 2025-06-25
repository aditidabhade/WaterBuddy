
#!/bin/bash
# streak.sh: Manages goal streak tracking

# Load settings
if [ -f $(dirname "$0")/../data/settings.conf ]; then
    source $(dirname "$0")/../data/settings.conf
else
    echo "Error: data/settings.conf not found."
    exit 1
fi

# Load streak data
if [ -f $(dirname "$0")/../data/streak.txt ]; then
    source $(dirname "$0")/../data/streak.txt
else
    echo "Error: data/streak.txt not found."
    exit 1
fi

# Function to update streak
update_streak() {
    local today=$(date +%Y-%m-%d)
    local yesterday=$(date -d "$today -1 day" +%Y-%m-%d)
    local total=$(grep "^$today," $(dirname "$0")/../data/water_log.txt | awk -F',' '{sum+=$2} END {print sum+0}')

    # Check if goal was met today
    if [ $total -ge $GOAL ]; then
        if [ "$LAST_DATE" = "$yesterday" ] || [ "$LAST_DATE" = "$today" ]; then
            STREAK=$((STREAK + 1))
        else
            STREAK=1
        fi
        # Award Streak Master badge for 5-day streak
        if [ $STREAK -ge 5 ] && ! grep -q "$today,Streak Master" $(dirname "$0")/../data/badges.txt; then
            echo "$today,Streak Master" >> $(dirname "$0")/../data/badges.txt
            echo "Badge Earned: Streak Master!"
        fi
    else
        STREAK=0
    fi

    # Update streak.txt
    cat > $(dirname "$0")/../data/streak.txt << EOF
STREAK=$STREAK
LAST_DATE=$today
EOF
}

# Function to view streak
view_streak() {
    local today=$(date +%Y-%m-%d)
    local total=$(grep "^$today," $(dirname "$0")/../data/water_log.txt | awk -F',' '{sum+=$2} END {print sum+0}')
    # Update streak before displaying
    update_streak
    source $(dirname "$0")/../data/streak.txt
    if [ $STREAK -gt 0 ]; then
        echo "You've hit your goal $STREAK days in a row! 🔥"
    else
        echo "No streak yet. Drink $GOAL today to start one!"
    fi
}

# Handle arguments
case "$1" in
    --update) update_streak ;;
    --view) view_streak ;;
    *) echo "Usage: $0 [--update | --view]" ;;
esac
