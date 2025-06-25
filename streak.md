# Streak Tracking Module
- **File**: `scripts/streak.sh`
- **Functionality**: Tracks consecutive days meeting the water goal. Awards “Streak Master” badge for 5-day streaks.
- **Implementation**: Updates `data/streak.txt` with `STREAK` and `LAST_DATE`. Checks daily intake vs. goal.
- **Usage**: `./streak.sh [--update | --view]`
- **Output**: Shows streak (e.g., “You've hit your goal 3 days in a row! 🔥”).
