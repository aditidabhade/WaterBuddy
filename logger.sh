#!/bin/bash
# logger.sh: Logs water intake, manages settings, awards badges

# Load settings
if [ -f $(dirname "$0")/../data/settings.conf ]; then
    source $(dirname "$0")/../data/settings.conf
else
    echo "Error: data/settings.conf not found."
    exit 1
fi

# Function to check if daily goal is met
check_goal_met() {
    local date=$(date +%Y-%m-%d)
    local total=$(grep "^$date," $(dirname "$0")/../data/water_log.txt | awk -F',' '{sum+=$2} END {print sum+0}')
    if [ $total -ge $GOAL ]; then
        return 0  # Goal met
    else
        return 1  # Goal not met
    fi
}

# Function to award badges
award_badges() {
    local date=$(date +%Y-%m-%d)
    local total=$(grep "^$date," $(dirname "$0")/../data/water_log.txt | awk -F',' '{sum+=$2} END {print sum+0}')
    local badges_file=$(dirname "$0")/../data/badges.txt
    # Hydration Beast: 20 glasses in a day
    if [ $total -ge 20 ] && ! grep -q "$date,Hydration Beast" $badges_file; then
        echo "$date,Hydration Beast" >> $badges_file
        echo "Badge Earned: Hydration Beast!"
    fi
    # Streak Master: Handled in streak.sh
}

# Function to show celebration animation
show_celebration() {
    local frames=("$(cat $(dirname "$0")/../data/celebration.txt)" "$(cat $(dirname "$0")/../data/celebration.txt | sed 's/~/ /g')")
    for ((i=0; i<3; i++)); do
        clear
        echo "Goal Achieved! Here's a water drop:"
        echo "${frames[$((i%2))]}"
        sleep 0.5
    done
    echo "Congratulations! You met your daily goal!"
}

# Function to log water
log_water() {
    read -p "Enter water amount (glasses or ml): " amount
    if [[ ! $amount =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo "Error: Enter a valid number."
        exit 1
    fi
    echo "$(date +%Y-%m-%d),$amount" >> $(dirname "$0")/../data/water_log.txt
    # Show random motivational message
    local message_file=$(dirname "$0")/../data/messages_${MESSAGE_THEME}.txt
    if [ -f "$message_file" ]; then
        message=$(shuf -n 1 "$message_file")
        echo "$message"
    else
        echo "Keep drinking!"
    fi
    # Show random health tip
    if [ -f $(dirname "$0")/../data/health_tips.txt ]; then
        tip=$(shuf -n 1 $(dirname "$0")/../data/health_tips.txt)
        echo "Health Tip: $tip"
    fi
    # Check and show celebration if goal met
    if check_goal_met; then
        show_celebration
    fi
    # Update streak
    /bin/bash $(dirname "$0")/streak.sh --update
    # Award badges
    award_badges
}

# Function to set goal
set_goal() {
    read -p "Enter daily goal (glasses or ml): " new_goal
    if [[ ! $new_goal =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo "Error: Enter a valid number."
        exit 1
    fi
    sed -i "s/GOAL=.*/GOAL=$new_goal/" $(dirname "$0")/../data/settings.conf
    echo "Goal updated to $new_goal."
}

# Function to set reminder interval
set_interval() {
    read -p "Enter reminder interval (number): " new_interval
    if [[ ! $new_interval =~ ^[0-9]+$ ]]; then
        echo "Error: Enter a valid number."
        exit 1
    fi
    read -p "Enter unit (hours or minutes): " new_unit
    if [[ "$new_unit" != "hours" && "$new_unit" != "minutes" ]]; then
        echo "Error: Unit must be 'hours' or 'minutes'."
        exit 1
    fi
    sed -i "s/INTERVAL=.*/INTERVAL=$new_interval/" $(dirname "$0")/../data/settings.conf
    sed -i "s/INTERVAL_UNIT=.*/INTERVAL_UNIT=$new_unit/" $(dirname "$0")/../data/settings.conf
    echo "Interval updated to $new_interval $new_unit."
    echo "Restart reminders (option 7, then 8) to apply changes."
}

# Function to set reminder message
set_message() {
    read -p "Enter new reminder message: " new_message
    sed -i "s/MESSAGE=.*/MESSAGE=\"$new_message\"/" $(dirname "$0")/../data/settings.conf
    echo "Reminder message updated."
}

# Function to set message theme
set_theme() {
    echo "Available themes: fitness, chill, anime"
    read -p "Enter message theme: " new_theme
    if [[ "$new_theme" != "fitness" && "$new_theme" != "chill" && "$new_theme" != "anime" ]]; then
        echo "Error: Theme must be 'fitness', 'chill', or 'anime'."
        exit 1
    fi
    sed -i "s/MESSAGE_THEME=.*/MESSAGE_THEME=$new_theme/" $(dirname "$0")/../data/settings.conf
    echo "Message theme updated to $new_theme."
}

# Function to view badges
view_badges() {
    local badges_file=$(dirname "$0")/../data/badges.txt
    if [ -s $badges_file ]; then
        echo "Your Badges:"
        cat $badges_file
    else
        echo "No badges earned yet. Keep drinking!"
    fi
}

# Handle arguments
case "$1" in
    --log) log_water ;;
    --set-goal) set_goal ;;
    --set-interval) set_interval ;;
    --set-message) set_message ;;
    --set-theme) set_theme ;;
    --view-badges) view_badges ;;
    *) echo "Usage: $0 [--log | --set-goal | --set-interval | --set-message | --set-theme | --view-badges]" ;;
esac
