#!/bin/bash
# water.sh: Main menu-driven interface for WaterBuddyPlus with reminder loop

# Function to start reminders in background
start_reminders() {
    if [ -f data/reminder.pid ] && kill -0 $(cat data/reminder.pid) 2>/dev/null; then
        echo "Reminders are already running (PID: $(cat data/reminder.pid))."
        return
    fi

    # Load settings
    if [ -f data/settings.conf ]; then
        source data/settings.conf
    else
        echo "Error: data/settings.conf not found."
        exit 1
    fi

    # Convert interval to seconds
    if [ "$INTERVAL_UNIT" = "hours" ]; then
        sleep_time=$((INTERVAL * 3600))
    else
        sleep_time=$((INTERVAL * 60))
    fi

    # Start background loop
    (
        while true; do
            /bin/bash $(pwd)/scripts/reminder.sh
            sleep $sleep_time
        done
    ) &
    echo $! > data/reminder.pid
    echo "Reminders started (PID: $(cat data/reminder.pid), every $INTERVAL $INTERVAL_UNIT)."
}

# Function to stop reminders
stop_reminders() {
    if [ -f data/reminder.pid ] && kill -0 $(cat data/reminder.pid) 2>/dev/null; then
        kill $(cat data/reminder.pid)
        rm data/reminder.pid
        echo "Reminders stopped."
    else
        echo "No reminders are running."
    fi
}

# Main menu loop
while true; do
    echo "WaterBuddyPlus: Hydration Tracker"
    echo "1. Log Water Intake"
    echo "2. View Today's Report"
    echo "3. Set Daily Goal"
    echo "4. Set Reminder Interval"
    echo "5. Set Reminder Message"
    echo "6. View Past Report"
    echo "7. Start Reminders"
    echo "8. Stop Reminders"
    echo "9. Weekly Summary"
    echo "10. View Streak"
    echo "11. View Badges"
    echo "12. Set Message Theme"
    echo "13. Exit"
    read -p "Choose option: " choice

    case $choice in
        1) ./scripts/logger.sh --log ;;
        2) ./scripts/report.sh ;;
        3) ./scripts/logger.sh --set-goal ;;
        4) ./scripts/logger.sh --set-interval ;;
        5) ./scripts/logger.sh --set-message ;;
        6) read -p "Enter date (YYYY-MM-DD): " date; ./scripts/report.sh --date "$date" ;;
        7) start_reminders ;;
        8) stop_reminders ;;
        9) ./scripts/report.sh --weekly ;;
        10) ./scripts/streak.sh --view ;;
        11) ./scripts/logger.sh --view-badges ;;
        12) ./scripts/logger.sh --set-theme ;;
        13) stop_reminders; echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid option. Choose 1-13." ;;
    esac
done
