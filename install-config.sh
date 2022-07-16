#!/bin/bash

#
# This script is for (RHEL8, RHEL9, Fedora) Linux to configure XRDP for enhanced session mode
#

###############################################################################
# Install XRDP, Hyperv tools
#
# dnf install -y hyperv-tools
# Install epel-release: https://docs.fedoraproject.org/en-US/epel/
# dnf install -y xrdp xrdp-selinux


if [ "$(id -u)" -ne 0 ]; then
    echo 'This script must be run with root privileges' >&2
    exit 1
fi

# Use rpm -q to check for exact package name
if ! rpm -q xrdp 2>&1 > /dev/null ; then
    echo 'xrdp not installed. Run dnf install xrdp first to install xrdp.' >&2
    exit 1
fi

###############################################################################
# Configure XRDP
#
systemctl enable xrdp
systemctl enable xrdp-sesman

# Configure the installed XRDP ini files.
# use vsock transport.
sed -i_orig -e 's/port=3389/port=vsock:\/\/-1:3389/g' /etc/xrdp/xrdp.ini
# use rdp security.
sed -i_orig -e 's/security_layer=negotiate/security_layer=rdp/g' /etc/xrdp/xrdp.ini
# remove encryption validation.
sed -i_orig -e 's/crypt_level=high/crypt_level=none/g' /etc/xrdp/xrdp.ini
# disable bitmap compression since its local its much faster
sed -i_orig -e 's/bitmap_compression=true/bitmap_compression=false/g' /etc/xrdp/xrdp.ini

# rename the redirected drives to 'shared-drives'
sed -i_orig -e 's/FuseMountName=thinclient_drives/FuseMountName=shared-drives/g' /etc/xrdp/sesman.ini

# Change the allowed_users
echo "allowed_users=anybody" > /etc/X11/Xwrapper.config


#Ensure hv_sock gets loaded
if [ ! -e /etc/modules-load.d/hv_sock.conf ]; then
	echo "hv_sock" > /etc/modules-load.d/hv_sock.conf
fi

# Open port
firewall-cmd --add-port=3389/tcp --permanent
firewall-cmd --reload

###############################################################################

echo "####### Configuration Done #######"
echo "Next to do"
echo "Shutdown this VM"
echo "On your host machine in an Administrator powershell prompt, execute this command: "
echo "             Set-VM -VMName <your_vm_name> -EnhancedSessionTransportType HvSocket"
echo "Start this VM, and you will see Enhanced mode available!"