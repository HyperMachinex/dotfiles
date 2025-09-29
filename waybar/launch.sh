#!/bin/sh


killall waybar

#if [[$USER = "YOUR_USERNAME"]] or
if [[true]]
then 
	waybar -c /etc/xdg/waybar/config & -s /etc/xdg/waybar/style.css
else
	waybar &
fi
