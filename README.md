# Apex Linux Security Suite

A comprehensive, automated local security auditing and hardening suite designed for Fedora Workstation. This tool integrates multiple enterprise-grade and open-source Linux security layers into a single scheduled workflow with automated log aggregation.

## Features

* **Kernel & Access Controls:** Automated SELinux status and policy compliance checks.
* **Sandbox & Isolation:** Firejail application containment monitoring.
* **Intrusion Prevention & Auditing:** Active Fail2ban status evaluation, Auditd monitoring, and Suricata network threat detection logging.
* **Rootkit & Integrity Scans:** Integrated Chkrootkit, Rkhunter, and AIDE file integrity checks.
* **Hardening & Compliance:** Automated system auditing via Lynis and SCAP Security Guide OpenSCAP evaluations.
* **Automation:** Managed completely via systemd timers and oneshot services for weekly unattended execution.

---

## Directory Structure


Apex-Linux-Security/
├── README.md               # Documentation
├── install.sh              # Automated setup and dependency installer script
├── run_security_scans.sh   # Core scanning and log aggregation script
├── secscan.service         # Systemd service unit definition
└── secscan.timer           # Systemd timer unit definition

```bash
git clone [https://github.com/KeanBP36/Apex-Linux-Security.git](https://github.com/KeanBP36/Apex-Linux-Security.git) && cd Apex-Linux-Security && sudo ./install.sh
