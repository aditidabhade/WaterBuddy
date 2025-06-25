# Reminder Module
- **File**: `scripts/reminder.sh`
- **Functionality**: Sends reminders via desktop notifications (if `libnotify` installed), sound (if `alsa-utils` installed), or terminal. Logs to `data/reminder.log`.
- **Implementation**: Runs in a background loop started by `water.sh`, triggered every `INTERVAL` (hours/minutes) from `settings.conf`.
- **Usage**: Start via option 7; stop via option 8.
- **Output**: Notification, sound, or `reminder.log` entry (e.g., `2025-06-24 20:39:00: Time to drink water!`).
