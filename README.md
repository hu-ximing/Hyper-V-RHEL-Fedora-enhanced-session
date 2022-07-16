# Hyper-V-RHEL-Fedora-enhanced-session
This bash script is used for RHEL and Fedora virtual machines to configure XRDP for enhanced session in Hyper-V.

It should work on Fedora 3x, RHEL 8, RHEL 9 and their variants.

## Steps
1. Enable Extra Packages for Enterprise Linux (EPEL).

For RHEL and its variants, follow instructions on [Fedora documentary](https://docs.fedoraproject.org/en-US/epel/#_el9).  
However, this is not required on Fedora, since it has the extra repositories enabled by default.

2. Install the following packages

```
sudo dnf install hyperv-tools xrdp xrdp-selinux
```

3. Run the script as root

```
sudo bash install-config.sh
```

4. Poweroff vm

5. Run in elevated PowerShell on Windows host

```
Set-VM -VMName <your_vm_name> -EnhancedSessionTransportType HvSocket
```
Check:
```
Get-VM <your_vm_name> | select EnhancedSessionTransportType
# should print "HvSocket"
```

6. Start the vm

Now the vm can be connected as enhanced session.



## Credits
It is a fork/combination of scripts below:  
https://github.com/EtienneBarbier/Hyper-V-RHEL-8-VM/blob/main/install_configure_esm_el8.sh  
https://github.com/microsoft/linux-vm-tools/pull/124/files  
