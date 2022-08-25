#!bin/bash

iptables -F
iptables -L

iptables -A INPUT -m length --length 600:65535 -m ttl --ttl-gt 10 -j DROP
iptables -A OUTPUT -m length --length 600:65535 -m ttl --ttl-gt 10 -j DROP

iptables -L

# Checking

# default with size=32 bytes and TTL=64
ping 192.168.40.131

# size=1024 bytes > 600 bytes, TTL =64
ping 192.168.40.131 -l 1024

