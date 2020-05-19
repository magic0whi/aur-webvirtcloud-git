#!/bin/sh

if [ -f /etc/libvirt/libvirtd.conf ]; then
    sed -i 's/#listen_tls/listen_tls/g' /etc/libvirt/libvirtd.conf
    sed -i 's/#listen_tcp/listen_tcp/g' /etc/libvirt/libvirtd.conf
    sed -i 's/#auth_tcp/auth_tcp/g' /etc/libvirt/libvirtd.conf
else
    echoerror "/etc/libvirt/libvirtd.conf not found. Exiting..."
    exit 1
fi
if [ -f /etc/libvirt/qemu.conf ]; then
    sed -i 's/#[ ]*vnc_listen.*/vnc_listen = "0.0.0.0"/g' /etc/libvirt/qemu.conf
    sed -i 's/#[ ]*spice_listen.*/spice_listen = "0.0.0.0"/g' /etc/libvirt/qemu.conf
else
    echoerror "/etc/libvirt/qemu.conf not found. Exiting..."
    exit 1
fi

# Need install python-libguestfs from AUR
if [ -f /etc/supervisor/supervisord.conf ]; then
    wget -O /usr/local/bin/gstfsd https://raw.githubusercontent.com/retspen/webvirtcloud/master/conf/daemon/gstfsd
    chmod +x /usr/local/bin/gstfsd
    wget -O /etc/supervisor.d/gstfsd.ini https://raw.githubusercontent.com/retspen/webvirtcloud/master/conf/supervisor/gstfsd.conf
else
    echoerror "Supervisor not found. Exiting..."
    exit 1
fi