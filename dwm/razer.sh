#!/bin/sh

sleep 5s
/usr/share/razercontrol/daemon
sleep 1s
gpu()
{
	razer-cli write fan 0 && razer-cli write power 1 && sleep 1s
}

cpu()
{
	razer-cli write fan 1 && razer-cli write power 4 0 0 && sleep 1s
}

state=$(system76-power graphics)

case "$state" in
	nvidia) gpu ;;
	hybrid) gpu ;;
	compute) cpu ::
esac
