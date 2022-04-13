#!/bin/sh

nvxrandr()
{
	case "$disport" in
		" DP-0") xrandr --output eDP-1-1 --mode 1920x1080 --rate 60 --output DP-0 --mode 1920x1080 --rate 60 --primary --right-of eDP-1-1 ;;
		"") xrandr --output eDP-1-1 --mode 1920x1080 --rate 30 ;;
	esac
}

state=$(system76-power graphics)
disport=$(xrandr --listactivemonitors | grep -o -P " DP-0")
pulseaudio=$(pidof pulseaudio)


case "$state" in
	nvidia) nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }" && nvxrandr ;;
	hybrid) nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }" && nvxrandr ;;
	compute) xrandr --output eDP-1 --mode 1920x1080 --rate 30 ;;
esac

oledinit=$(xrandr --listactivemonitors | grep -o -P "  eDP-.{0,5}")

brightinit=$(cat /home/exaset/.brightness)

case "$brightinit" in
	1) xrandr --output $oledinit --brightness .1 ;;
	2) xrandr --output $oledinit --brightness .2 ;;
	3) xrandr --output $oledinit --brightness .3 ;;
	4) xrandr --output $oledinit --brightness .4 ;;
	5) xrandr --output $oledinit --brightness .5 ;;
	6) xrandr --output $oledinit --brightness .6 ;;
	7) xrandr --output $oledinit --brightness .7 ;;
	8) xrandr --output $oledinit --brightness .8 ;;
	9) xrandr --output $oledinit --brightness .9 ;;
	10) xrandr --output $oledinit --brightness 1 ;;
esac

kill $pulseaudio && pulseaudio --start

dunst & mullvad-vpn & feh --bg-fill /home/exaset/.dwm/wallpaper.jpg & bluetoothctl power off

#alacritty -t termfloat -e sh ~/.dwm/razer.sh
/usr/share/razercontrol/daemon && sh ~/.dwm/razer.sh

if [ "$state" = "nvidia" ]; then
	sleep 4s && discord
elif [ "$state" = "hybrid" ]; then
	sleep 4s && discord
fi
