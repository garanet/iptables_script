#!/bin/bash
# www.garanet.net
# Bash script to enable the firewall on startup of your Ubuntu server.
# https://github.com/garanet/iptables_script.git

RETVAL=0

# To start the firewall
start() {
  echo -n "Iptables rules creation: "
  /usr/local/bin/iptables.sh
  RETVAL=0
}

# To stop the firewall
stop() {
  echo -n "Removing all iptables rules: "
  /sbin/iptables -F
  RETVAL=0
}

case $1 in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    stop
    start
    ;;
  status)
    /sbin/iptables -L
    /sbin/iptables -t nat -L
    RETVAL=0
    ;;
  *)
    echo "Usage: firewall {start|stop|restart|status}"
    RETVAL=1
esac

exit

