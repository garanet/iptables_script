# iptables_script
Bash script to enable the firewall on startup of your Ubuntu server.

@ Installation
~:$ git clone https://github.com/garanet/iptables_script.git
~:$ cd iptables_script/
~:$ sudo chmod a+x *.sh
~:$ sudo mv firewall.sh /etc/init.d/
~:$ sudo mv iptables.sh /usr/local/bin/
~:$ sudo update-rc.d /etc/init.d/firewall.sh defaults

Remember, it's tested on Ubuntu, change the variables for your own system !

2016 - www.garanet.net
