#!/bin/bash

# Ensure script is run as root/sudo
if [ "$EUID" -ne 0 ]; then
    echo "[-] Please run this script with sudo: sudo ./install.sh"
    exit 1
fi

echo "=================================================="
echo " Installing Apex Linux Security Suite..."
echo "=================================================="

# 1. Install required packages via DNF
echo "[*] Installing security packages..."
dnf install -y chkrootkit rkhunter aide lynis fail2ban firejail suricata auditd

# 2. Setup directories
echo "[*] Creating required directories..."
mkdir -p /var/log/suricata
mkdir -p /etc/systemd/system/suricata.service.d/
mkdir -p /usr/local/bin

# Safely determine the real invoking user's home directory
REAL_USER="${SUDO_USER:-$USER}"
USER_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)
mkdir -p "$USER_HOME/security-logs"

# 3. Configure Suricata sandbox override
echo "[*] Applying systemd sandbox configuration for Suricata..."
cat << 'EOF' > /etc/systemd/system/suricata.service.d/override.conf
[Service]
ProtectSystem=true
ReadWritePaths=/var/log/suricata /var/run
EOF

# 4. Copy scan script to global path
echo "[*] Installing security scan orchestrator..."
cp run_security_scans.sh /usr/local/bin/run_security_scans.sh
chmod +x /usr/local/bin/run_security_scans.sh

# 5. Install Systemd Timer and Service for Automated Scans
echo "[*] Installing automated weekly scan timer..."
cp secscan.service /etc/systemd/system/secscan.service
cp secscan.timer /etc/systemd/system/secscan.timer

# 6. Enable and Start Services
echo "[*] Enabling background daemons and timers..."
systemctl daemon-reload
systemctl enable --now suricata
systemctl enable --now fail2ban
systemctl enable --now secscan.timer

echo "=================================================="
echo " Installation Complete! "
echo " Run manual scans anytime using: sudo run_security_scans.sh"
echo "=================================================="
