#!/bin/bash
sudo apt install -y hostapd
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo mv /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf.bkp
sudo cp hostapd.conf /etc/hostapd/hostapd.conf
sudo cp br0-member-eth0-eth1.network /etc/systemd/network/
sudo cp bridge-br0.netdev /etc/systemd/network/
sudo systemctl enable systemd-networkd
if [ `cat /etc/dhcpcd.conf | grep deny | wc -l` == 0 ]
then
sudo cp /etc/dhcpcd.conf /etc/dhcpcd.conf.bkp
sudo echo "denyinterfaces wlan0 eth0 eth1" >> /etc/dhcpcd.conf
sudo echo "interface br0" >> /etc/dhcpcd.conf
sudo echo "static ip address=192.168.29.33/24" >> /etc/dhcpcd.conf
sudo echo "static routers=192.168.29.1" >> /etc/dhcpcd.conf
sudo echo "static domain_name servers=192.168.29.1" >> /etc/dhcpcd.conf
else
echo "/etc/dhcpcd.conf already configured..."
fi

sudo rfkill unblock wlan
