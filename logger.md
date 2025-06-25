# Logger and Settings Module
- **File**: `scripts/logger.sh`
- **Functionality**: Logs water intake, sets goal, interval, message, and theme (fitness, chill, anime). Shows health tips and ASCII art celebration when goal is met. Awards badges.
- **Implementation**: Writes to `data/water_log.txt`, `data/badges.txt`. Updates `data/settings.conf` with `sed`. Uses `shuf` for messages from `messages_${theme}.txt` and `health_tips.txt`.
- **Usage**: `./logger.sh [--log | --set-goal | --set-interval | --set-message | --set-theme | --view-badges]`
