#!/bin/bash
noofITusers=0
myarray=($(awk -F: '{print $1}' /etc/passwd))
for i in "${myarray[@]}"
do
	group="$(sudo groups $i | awk '{print $3}')"
	if [ $group == "it" ]; then
		sudo iptables -A OUTPUT -p tcp --dport 443 -m owner --uid-owner $i -j ACCEPT
		sudo ip6tables -A OUTPUT -p tcp --dport 443 -m owner --uid-owner $i -j ACCEPT
		((noofITusers++))
	fi
done
sudo iptables -A OUTPUT -p tcp --dport 443 -d 192.168.2.3 -j ACCEPT
sudo iptables -t filter -A OUTPUT -p tcp --dport 80 -j DROP
sudo iptables -t filter -A OUTPUT -p tcp --dport 443 -j DROP
sudo ip6tables -t filter -A OUTPUT -p tcp --dport 80 -j DROP
sudo ip6tables -t filter -A OUTPUT -p tcp --dport 443 -j DROP
echo "$noofITusers from IT department were granted internet access"
