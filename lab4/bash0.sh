#!/bin/sh

# flush
iptables -F

# default settings
iptables -L

# block all incoming traffics
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# SSH, HTTP, HTTPS traffic
iptables -A INPUT -p tcp -m tcp -m multiport --dports 22,80,443 -j ACCEPT
iptables -A INPUT -m conntrack -j ACCEPT  --ctstate RELATED,ESTABLISHED
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Open port for checking
service ssh start # port 22
service apache2 start # port 80 and 443

# Checking
telnet localhost 22
telnet localhost 80
telnet localhost 443
