#!/bin/sh

echo "[*] Verifying permissions of the service crontab at '/etc/cron.d/service-crontab'…"
chmod 644 /etc/cron.d/service-crontab
echo "[*] Installing crontab from `/etc/cron.d/service-crontab`…"
crontab /etc/cron.d/service-crontab
echo "[*] Showing installed cron jobs…"
crontab -l
echo "[*] Starting cron daemon…"
crond -f
