#!/bin/bash
# reminder.sh: Sends a hydration reminder via notification, sound, or terminal

# Load settings
if [ -f $(dirname "$0")/../data/settings.conf ]; then
    source $(dirname "$0")/../data/settings.conf
else
    echo "Error: data/settings.conf not found."
    exit 1
fi

# Log reminder to terminal and reminder.log
echo "$(date '+%Y-%m-%d %H:%M:%S'): $MESSAGE"
# Suppress notify-send errors in headless setup
if command -v notify-send >/dev/null 2>&1; then
    notify-send "WaterBuddyPlus Reminder" "$MESSAGE" -t 5000 2>/dev/null || true
fi

# Play sound if available
if command -v aplay >/dev/null 2>&1 && [ -f $(dirname "$0")/../data/sound.wav ]; then
    aplay $(dirname "$0")/../data/sound.wav >/dev/null 2>&1 || echo "$(date '+%Y-%m-%d %H:%M:%S'): No sound available, reminder logged."
fi

# Log reminder to reminder.log
echo "$(date '+%Y-%m-%d %H:%M:%S'): $MESSAGE" >> $(dirname "$0")/../data/reminder.log
