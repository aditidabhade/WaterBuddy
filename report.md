# Report and Progress Bar Module
- **File**: `scripts/report.sh`
- **Functionality**: Shows daily or weekly intake vs. goal with ASCII progress bar. Supports past dates and weekly summaries.
- **Implementation**: Uses `grep` and `awk` to parse `data/water_log.txt`. Generates 10-character bar with `printf`. Weekly summary includes total, average, days meeting goal.
- **Usage**: `./report.sh [--date YYYY-MM-DD | --weekly]`
- **Notes**: Handles overflow (intake > goal) and zero goal cases.
