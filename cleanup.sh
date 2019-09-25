#!/usr/bin/env bash

xrandr --output VIRTUAL1 --off
xrandr --delmode VIRTUAL1 "1280x800_60.00"
xrandr --rmmode "1280x800_60.00"
