#!/bin/bash

# Define the log folder with a timestamp in the user's home directory
LOG_DIR="$HOME/security-logs/scan_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$LOG_DIR"

echo "=================================================="
echo " Starting Full Security Suite Scan (All Tools)"
echo " Logs will be saved to: $LOG_DIR"
echo "=================================================="

# 1. SELinux Status Check
echo "[*] Checking SELinux..."
sestatus > "$LOG_DIR/selinux.log" 2>&1

# 2. Firejail Status Check
echo "[*] Checking Firejail Status..."
firejail --list > "$LOG_DIR/firejail.log" 2>&1

# 3. Fail2ban Status Check
echo "[*] Checking Fail2ban Status..."
sudo fail2ban-client status > "$LOG_DIR/fail2ban.log" 2>&1

# 4. Auditd Status Check
echo "[*] Checking Auditd Status..."
sudo systemctl status auditd > "$LOG_DIR/auditd.log" 2>&1

# 5. Rustinel Activity Check
echo "[*] Checking Rustinel Logs..."
if [ -d "$HOME/rustinel/logs" ]; then
    cat $HOME/rustinel/logs/alerts.json.* > "$LOG_DIR/rustinel_alerts.log" 2>&1
else
    echo "Rustinel logs directory not found." > "$LOG_DIR/rustinel_alerts.log"
fi

# 6. Suricata Status Check
echo "[*] Checking Suricata Status..."
sudo systemctl status suricata > "$LOG_DIR/suricata.log" 2>&1

# 7. Chkrootkit Scan
echo "[*] Running Chkrootkit..."
sudo chkrootkit > "$LOG_DIR/chkrootkit.log" 2>&1

# 8. Rkhunter Scan
echo "[*] Running Rkhunter..."
sudo rkhunter --check --sk --nocolors > "$LOG_DIR/rkhunter.log" 2>&1

# 9. AIDE Check
echo "[*] Running AIDE Integrity Check..."
sudo aide --check > "$LOG_DIR/aide.log" 2>&1

# 10. Lynis Audit
echo "[*] Running Lynis System Audit..."
sudo lynis audit system --quick > "$LOG_DIR/lynis.log" 2>&1

# 11. OpenSCAP Compliance Scan
echo "[*] Running OpenSCAP Evaluation..."
sudo oscap xccdf eval --profile xccdf_org.ssgproject.content_profile_cis_workstation_l1 --report "$LOG_DIR/openscap-report.html" /usr/share/xml/scap/ssg/content/ssg-fedora-ds.xml > "$LOG_DIR/openscap.log" 2>&1

echo "=================================================="
echo " All tool checks complete! Generating summary..."
echo "=================================================="

# Create a clean summary text file covering everything
SUMMARY_FILE="$LOG_DIR/summary.txt"
{
    echo "FULL SECURITY SUITE SUMMARY - $(date)"
    echo "=================================================="
    echo ""
    echo "--- 1. SELINUX ---"
    grep "Current mode" "$LOG_DIR/selinux.log" || echo "Check selinux.log"
    echo ""
    echo "--- 2. FAIL2BAN ---"
    tail -n 5 "$LOG_DIR/fail2ban.log"
    echo ""
    echo "--- 3. FIREJAIL ---"
    head -n 5 "$LOG_DIR/firejail.log"
    echo ""
    echo "--- 4. AUDITD & SURICATA STATUS ---"
    grep "Active:" "$LOG_DIR/auditd.log" || echo "Auditd status checked."
    grep "Active:" "$LOG_DIR/suricata.log" || echo "Suricata status checked."
    echo ""
    echo "--- 5. RUSTINEL ALERTS ---"
    if [ -s "$LOG_DIR/rustinel_alerts.log" ]; then
        echo "Alerts found! Check rustinel_alerts.log."
    else
        echo "No Rustinel alerts logged."
    fi
    echo ""
    echo "--- 6. CHKROOTKIT ---"
    grep -i "infct" "$LOG_DIR/chkrootkit.log" || echo "No explicit infection flags found."
    echo ""
    echo "--- 7. RKHUNTER WARNINGS ---"
    grep -i "warning" "$LOG_DIR/rkhunter.log" || echo "No warnings found by Rkhunter."
    echo ""
    echo "--- 8. AIDE STATUS ---"
    tail -n 5 "$LOG_DIR/aide.log"
    echo ""
    echo "--- 9. LYNIS HARDENING SCORE ---"
    grep -i "hardening index" "$LOG_DIR/lynis.log" || echo "Check full lynis.log for details."
    echo ""
    echo "=================================================="
    echo "All individual raw logs are saved in this folder."
} > "$SUMMARY_FILE"

echo "Summary generated at: $SUMMARY_FILE"
