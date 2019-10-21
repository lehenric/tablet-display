#!/usr/bin/env bash

res_x=1280
res_y=800
export VIRTUAL_DISP=VIRTUAL1

set -euo pipefail

cleanup() {
    echo "Exiting"
    set +eu #disable errors when killing children (ps prints itself)
    # kill all children heh
    for child in $(ps -o pid= --ppid $$)
    do
        kill $child
    done
    set -eu # enable it again
    xrandr --output $VIRTUAL_DISP --off
    xrandr --delmode $VIRTUAL_DISP "$MODE"
    xrandr --rmmode "$MODE"
    [[ -n $FORWARD ]] && adb reverse --remove tcp:5900
}
trap "cleanup" TERM INT HUP

export CVT=$(cvt $res_x $res_y | sed -nE 's/Modeline (.*)/\1/p')
export MODE=$(echo $CVT | sed -nE 's/.*"(.*)".*/\1/p')

xrandr --newmode `xargs printf '%s ' <<< "$CVT"` # use echo to bypass adding quotes
xrandr --addmode $VIRTUAL_DISP "$MODE"
xrandr --output $VIRTUAL_DISP --mode "$MODE" --left-of eDP1

# TODO check if andorid higher then 4.4
if [[ $(adb devices | wc -l) -ge 3 ]]; then
    echo "Reversing port 5900 on usb"
    adb reverse tcp:5900 tcp:5900
    export FORWARD=1
    fi
echo "Prepared xrandr for x11vnc, press ENTER to start x11vnc"
read
x11vnc -clip xinerama0 --forever &
wait
