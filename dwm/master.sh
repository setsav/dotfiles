#!/bin/sh

mutevol()
{
	/usr/bin/pactl set-sink-mute $activevolsink toggle && volumenotify
}

downvol()
{
	/usr/bin/pactl set-sink-volume $activevolsink -5% && volumenotify
}

upvol()
{
	/usr/bin/pactl set-sink-volume $activevolsink +5% && volumenotify
}

volumenotify()
{
	volume=$(pactl list sinks | perl -000ne 'if(/RUNNING/){/\/  *(\d\d*)/; print "$1\n"}')

	if [[ "$volume" -lt 101 ]] ; then
		dunstify -r 836683 -h int:value:$volume "                                  " "                          $volume%"
	else
		dunstify -r 836683 -u critical -h int:value:$volume "                                  " "                          $volume%"
	fi
}

appmenu()
{
	rofi -show drun -show-icons
}

vinote()
{
	date=$(date +%a_%b_%d_%I_%M_%N)
	name=$(echo -n "$date.txt")
	alacritty -e nvim ~/Documents/Notes/$name -c :E
}

brightinc()
{
	if [[ "$brightness" -lt 10 ]] ; then
		brightness=$((brightness+=1))
		echo "$brightness" > ~/.brightness
	fi

	brightness=$(cat ~/.brightness)

	case "$brightness" in
		1) xrandr --output $oled --brightness .1 & dunstify -r 836683 -h int:value:10 "                                  " " 10" ;;
		2) xrandr --output $oled --brightness .2 & dunstify -r 836683 -h int:value:20 "                                  " "    20" ;;
		3) xrandr --output $oled --brightness .3 & dunstify -r 836683 -h int:value:30 "                                  " "        30" ;;
		4) xrandr --output $oled --brightness .4 & dunstify -r 836683 -h int:value:40 "                                  " "           40" ;;
		5) xrandr --output $oled --brightness .5 & dunstify -r 836683 -h int:value:50 "                                  " "              50" ;;
		6) xrandr --output $oled --brightness .6 & dunstify -r 836683 -h int:value:60 "                                  " "                 60" ;;
		7) xrandr --output $oled --brightness .7 & dunstify -r 836683 -h int:value:70 "                                  " "                    70" ;;
		8) xrandr --output $oled --brightness .8 & dunstify -r 836683 -h int:value:80 "                                  " "                       80" ;;
		9) xrandr --output $oled --brightness .9 & dunstify -r 836683 -h int:value:90 "                                  " "                          90" ;;
		10) xrandr --output $oled --brightness 1 & dunstify -r 836683 -h int:value:100 "                                  " "                            100" ;;
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
		1) xrandr --output $oled --brightness .1 & dunstify -r 836683 -h int:value:10 "                                  " " 10" ;;
		2) xrandr --output $oled --brightness .2 & dunstify -r 836683 -h int:value:20 "                                  " "    20" ;;
		3) xrandr --output $oled --brightness .3 & dunstify -r 836683 -h int:value:30 "                                  " "        30" ;;
		4) xrandr --output $oled --brightness .4 & dunstify -r 836683 -h int:value:40 "                                  " "           40" ;;
		5) xrandr --output $oled --brightness .5 & dunstify -r 836683 -h int:value:50 "                                  " "              50" ;;
		6) xrandr --output $oled --brightness .6 & dunstify -r 836683 -h int:value:60 "                                  " "                 60" ;;
		7) xrandr --output $oled --brightness .7 & dunstify -r 836683 -h int:value:70 "                                  " "                    70" ;;
		8) xrandr --output $oled --brightness .8 & dunstify -r 836683 -h int:value:80 "                                  " "                       80" ;;
		9) xrandr --output $oled --brightness .9 & dunstify -r 836683 -h int:value:90 "                                  " "                          90" ;;
		10) xrandr --output $oled --brightness 1 & dunstify -r 836683 -h int:value:100 "                                  " "                            100" ;;
	esac
}

btmenu()
{
	bluetooth=$(echo -e "\n\n\n" | rofi -no-click-to-exit -theme btmenu.rasi -hover-select -dmenu -i -p " ")

	case "$bluetooth" in
		) alacritty -t termfloat -e sh .dwm/master.sh btonscreen ;;
		) alacritty -t termfloat -e sh .dwm/master.sh btoffscreen ;;
		) alacritty -t termfloat -e bluetoothctl ;;
		) alacritty -t termfloat -e iwctl ;;
	esac
}

nvidiascreen()
{
	fortune | cowsay
	echo -e " \n\n"
	system76-power graphics nvidia && reboot
}

intelscreen()
{
	fortune | cowsay
	echo -e " \n\n"
	system76-power graphics integrated && reboot
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
		) alacritty -t termfloat -e .dwm/master.sh nvidiascreen ;;
		) alacritty -t termfloat -e .dwm/master.sh intelscreen ;;
		) kill $dwm ;;
	esac
}

oled=$(xrandr --listactivemonitors | grep -o -P "  eDP-.{0,5}")

brightness=$(cat ~/.brightness)

dwm=$(pidof dwm)

activevolsink=$(pactl list sinks | perl -000ne 'if(/RUNNING/){/Sink #(\d*)/; print "$1\n"}')

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
	volumenotify) volumenotify ;;
	upvol) upvol ;;
	downvol) downvol ;;
	mutevol) mutevol ;;
esac
