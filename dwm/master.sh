#!/bin/sh

appmenu()
{
	rofi -show drun -show-icons
}

vinote()
{
	date=$(date +%a_%b_%d_%I_%M_%N)
	name=$(echo -n "$date.txt")
	st -e nvim ~/Documents/Notes/$name -c :E
}

brightinc()
{
	if [[ "$brightness" -lt 10 ]] ; then
		brightness=$((brightness+=1))
		echo "$brightness" > ~/.brightness
	fi

	brightness=$(cat ~/.brightness)

	case "$brightness" in
		1) xrandr --output $oled --brightness .1 ;;
		2) xrandr --output $oled --brightness .2 ;;
		3) xrandr --output $oled --brightness .3 ;;
		4) xrandr --output $oled --brightness .4 ;;
		5) xrandr --output $oled --brightness .5 ;;
		6) xrandr --output $oled --brightness .6 ;;
		7) xrandr --output $oled --brightness .7 ;;
		8) xrandr --output $oled --brightness .8 ;;
		9) xrandr --output $oled --brightness .9 ;;
		10) xrandr --output $oled --brightness 1 ;;
	esac
}

brightdec()
{
	if [[ "$brightness" -gt 1 ]] ; then
		brightness=$((brightness-=1))
		echo "$brightness" > ~/.brightness
	fi

	brightness=$(cat ~/.brightness)

	case "$brightness" in
		1) xrandr --output $oled --brightness .1 ;;
		2) xrandr --output $oled --brightness .2 ;;
		3) xrandr --output $oled --brightness .3 ;;
		4) xrandr --output $oled --brightness .4 ;;
		5) xrandr --output $oled --brightness .5 ;;
		6) xrandr --output $oled --brightness .6 ;;
		7) xrandr --output $oled --brightness .7 ;;
		8) xrandr --output $oled --brightness .8 ;;
		9) xrandr --output $oled --brightness .9 ;;
		10) xrandr --output $oled --brightness 1 ;;
	esac
}

btmenu()
{
	bluetooth=$(echo -e "\n\n\n" | rofi -no-click-to-exit -theme btmenu.rasi -hover-select -dmenu -i -p " ")

	case "$bluetooth" in
		) st -t termfloat -e sh .dwm/master.sh btonscreen ;;
		) st -t termfloat -e sh .dwm/master.sh btoffscreen ;;
		) st -t termfloat -e bluetoothctl ;;
		) st -t termfloat -e iwctl ;;
	esac
}

nvidiascreen()
{
	echo "Switching to hybrid graphics..."
	fortune | cowsay
	sleep 60s
}

intelscreen()
{
	echo "Switching to Intel graphics..."
	fortune | cowsay
	sleep 60s
}

btoffscreen()
{
	bluetoothctl agent off
	bluetoothctl power off
	sleep 2s
}

btonscreen()
{
	bluetoothctl default-agent
	bluetoothctl agent on
	bluetoothctl power on
	sleep 2s
}

powermenu()
{
	choices="\n\n\n\n\n"

	chosen=$(echo -e "$choices" | rofi -no-click-to-exit -hover-select -theme pmenu -dmenu -i -p " " )

	case "$chosen" in
		) shutdown 0 ;;
		) systemctl hibernate ;;
		) reboot ;;
		) st -t termfloat -e .dwm/master.sh nvidiascreen & system76-power graphics hybrid && reboot  ;;
		) st -t termfloat -e .dwm/master.sh intelscreen & system76-power graphics integrated && reboot ;;
		) kill $dwm ;;
	esac
}

oled=$(xrandr --listactivemonitors | grep -o -P "  eDP-.{0,5}")

brightness=$(cat ~/.brightness)

dwm=$(pidof dwm)

case "$1" in
	nvidiascreen) nvidiascreen ;;
	intelscreen) intelscreen ;;
	powermenu) powermenu ;;
	btmenu) btmenu ;;
	brightinc) brightinc ;;
	brightdec) brightdec ;;
	vinote) vinote ;;
	btoffscreen) btoffscreen ;;
	btonscreen) btonscreen ;;
	appmenu) appmenu ;;
esac
