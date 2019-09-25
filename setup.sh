#!/usr/bin/env bash

res_x=1280
res_y=800
cvt_out=$(cvt $res_x $res_y | sed -nE 's/Modeline (.*)/\1/p')
res_whole=$(echo $cvt_out | sed -nE 's/.*"(.*)".*/\1/p')
xrandr --newmode $cvt_out

xrandr --addmode VIRTUAL1 "$res_whole"
xrandr --output VIRTUAL1 --mode "$res_whole" --left-of eDP1
x11vnc -clip xinerama0 --forever
