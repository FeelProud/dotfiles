#!/bin/bash

if [ -z "$1" ]
then
    echo "PLEASE CHOOSE AN OPTION : dleft / dright / none "
    echo "exiting..."
    exit
fi

#display1=$(xrandr --listmonitors | grep -Eo '[A-Za-z]+\-1$' -m1)
#display2=$(xrandr --listmonitors | grep -Eo '[A-Za-z]+\-1$' -m2 | tail -n1)
display1=eDP
display2=HDMI-1-0

if [ $1 = "dleft" ]
then
    echo "setting second screen to left screen"
    xrandr --auto
    xrandr --output $display1 --auto --right-of $display2
    #reload wallpaper
    source ~/sc/randwall.sh
    exit
fi

if [ $1 = "dright" ]
then
    echo "setting second screen to right screen"
    xrandr --auto
    xrandr --output $display1 --auto --left-of $display2
    #reload wallpaper
    source ~/sc/randwall.sh
    exit
fi

if [ $1 = "none" ]
then
    echo "removing second screen"
    xrandr --output $display2 --off
    #reload wallpaper
    source ~/sc/randwall.sh
    exit
fi

echo "PLEASE CHOOSE AN OPTION : dleft / dright / none "
echo "exiting..."

