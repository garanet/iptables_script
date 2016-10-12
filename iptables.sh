#!/bin/bash
# www.garanet.net
# https://github.com/garanet/iptables_script.git

# Define IPs wit netmask like 8.8.8.8/32
ext_ip=""
ip_ftp=""
ip_ssh=""
ip_mysql=""

# No spoofing
if [ -e /proc/sys/net/ipv4/conf/all/rp_filter ]
then
for filtre in /proc/sys/net/ipv4/conf/*/rp_filter
do
echo 1 > $filtre
done
fi

# No icmp
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts

#load some modules you may need
modprobe ip_tables
modprobe ip_nat_ftp
modprobe ip_nat_irc
modprobe iptable_filter
modprobe iptable_nat
modprobe ip_conntrack_irc
modprobe ip_conntrack_ftp

# Remove all rules and chains
iptables -F
iptables -X

# Enabling Nagios 
sudo iptables -A INPUT -s 127.0.0.1/32 -p tcp -m tcp --dport 5666 -j ACCEPT
sudo iptables -A INPUT -s $ext_ip -p tcp -m tcp --dport 5666 -j ACCEPT
# Enabling FTP
sudo iptables -A INPUT -s $ip_ftp -p tcp -m tcp --dport 21 -j ACCEPT
# Enabling SSH
sudo iptables -A INPUT -s $ip_ssh -p tcp -m tcp --dport 22 -j ACCEPT
# Enabling Mysql
sudo iptables -A INPUT -s $ip_mysql -p tcp -m tcp --dport 3306 -j ACCEPT
sudo iptables -A INPUT -s 127.0.0.1/32 -p tcp -m tcp --dport 3306 -j ACCEPT
# Enabling Tomcat only localhost
sudo iptables -A INPUT -s 127.0.0.1/32 -p tcp -m tcp --dport 8009 -j ACCEPT
sudo iptables -A INPUT -s 127.0.0.1/32 -p tcp -m tcp --dport 8080 -j ACCEPT
# Enabling ICMP from WAN
sudo iptables -A INPUT -s $ext_ip -p icmp --icmp-type echo-request -j ACCEPT
# Enabling Web ports 443/80 for all ip
sudo iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
# Reject ICMP requests from others services
sudo iptables -A INPUT -p tcp -m tcp --dport 5666 -j REJECT --reject-with icmp-port-unreachable
sudo iptables -A INPUT -p tcp -m tcp --dport 21 -j REJECT --reject-with icmp-port-unreachable
sudo iptables -A INPUT -p tcp -m tcp --dport 3306 -j REJECT --reject-with icmp-port-unreachable
sudo iptables -A INPUT -p tcp -m tcp --dport 8080 -j REJECT --reject-with icmp-port-unreachable
sudo iptables -A INPUT -p tcp -m tcp --dport 8009 -j REJECT --reject-with icmp-port-unreachable
sudo iptables -A INPUT -p tcp -m tcp --dport 22 -j REJECT --reject-with icmp-port-unreachable
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j REJECT

echo " [End iptables rules setting]"
sudo iptables -A INPUT -p tcp -m tcp --dport 111 -j REJECT
