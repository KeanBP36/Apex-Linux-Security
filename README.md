# Apex Linux Security Suite

A modern, native, and comprehensive security and threat-detection framework built specifically for Linux distributions (optimized for Fedora/RHEL-based systems). 

Unlike traditional consumer antiviruses designed for Windows, this suite focuses on **defense-in-depth**, combining proactive kernel-level sandboxing, behavioral monitoring, network intrusion detection, and deep file integrity verification.

## 🛡️ Included Security Stack
* **SELinux & Firejail:** Kernel-level Mandatory Access Control and application sandboxing.
* **Suricata:** High-speed Network Intrusion Detection System (NIDS).
* **Fail2ban & Auditd:** Automated brute-force prevention and system-call auditing.
* **AIDE, Rkhunter, & Chkrootkit:** Advanced file integrity monitoring and rootkit detection.
* **Lynis & OpenSCAP:** System hardening audits and compliance checking.

## 🚀 Quick Installation
Clone the repository and run the installer script with root privileges:

```bash
git clone [https://github.com/YOUR-USERNAME/Apex-Linux-Security.git](https://github.com/YOUR-USERNAME/Apex-Linux-Security.git)
cd Apex-Linux-Security
sudo chmod +x install.sh
sudo ./install.sh
