#!/bin/bash
# setup.sh: Initialize files and directories for WaterBuddyPlus


# Install alsa-utils for sound (optional, no libnotify for headless EC2)
sudo yum install -y alsa-utils || echo "Warning: alsa-utils not installed, sound notifications will use terminal."

# Create settings.conf with defaults
cat > data/settings.conf <<EOF
GOAL=8
INTERVAL=1
INTERVAL_UNIT=hours
MESSAGE="Time to drink water!"
MESSAGE_THEME=fitness
EOF

# Create themed message files
cat > data/messages_fitness.txt <<EOF
Push harder, stay hydrated!
Fuel your workout with water!
Hydration = Performance!
Keep those muscles hydrated!
EOF

cat > data/messages_chill.txt <<EOF
Stay calm and sip water!
Chill vibes, hydrated life!
Take a sip, relax, repeat!
Water keeps you zen!
EOF

cat > data/messages_anime.txt <<EOF
Channel your inner ninja, drink water!
Power up like Goku with hydration!
Stay hydrated, senpai!
Water is your chakra boost!
EOF

# Create health_tips.txt
cat > data/health_tips.txt <<EOF
Drinking water aids digestion!
Stay hydrated to boost focus!
Water helps regulate body temperature!
Hydration improves skin health!
EOF

# Create celebration.txt with ASCII art
cat > data/celebration.txt <<EOF
  _____
 /     \\
/_______\\
 | ~~~ |
 | ~~~ |
 |~~~~~|
EOF

# Create empty data files
touch data/water_log.txt data/reminder.log data/reminder.pid data/badges.txt data/streak.txt

