#!/bin/sh

gpu()
{
	razer-cli write fan 0 && razer-cli write power 4 3 2 && sleep 1s
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
