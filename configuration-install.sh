#!/bin/sh

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  echoerr
#   DESCRIPTION:  Echo errors to stderr.
#-------------------------------------------------------------------------------
echoerror() {
    printf "${RC} * ERROR${EC}: $@\n" 1>&2;
}


if [ -f /etc/libvirt/libvirtd.conf ]; then
    sed -i 's/#listen_tls/listen_tls/g' /etc/libvirt/libvirtd.conf
    sed -i 's/#listen_tcp/listen_tcp/g' /etc/libvirt/libvirtd.conf
    sed -i 's/#auth_tcp = "sasl"/auth_tcp="none"/g' /etc/libvirt/libvirtd.conf
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
if [ -f /etc/supervisord.conf ]; then
    wget -O /usr/local/bin/gstfsd https://raw.githubusercontent.com/retspen/webvirtcloud/master/conf/daemon/gstfsd
    chmod +x /usr/local/bin/gstfsd
    wget -O /etc/supervisor.d/gstfsd.ini https://raw.githubusercontent.com/retspen/webvirtcloud/master/conf/supervisor/gstfsd.conf
    # Correct python path
    sed -i 's/command=/srv/webvirtcloud/venv/bin/python3/command=/usr/bin/python3/g' /etc/supervisor.d/gstfsd.ini
else
    echoerror "Supervisor not found. Exiting..."
    exit 1
fi