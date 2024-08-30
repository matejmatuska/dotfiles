#!/usr/bin/env bash
set -euo pipefail

readonly ENABLED="<span size='large' rise='-3000' font-weight='regular'></span>"
readonly DISABLED="<span size='large' rise='-3000' font-weight='regular'></span>"
dbus-monitor path='/org/freedesktop/Notifications',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged' --profile |
    while read -r _; do
        PAUSED="$(dunstctl is-paused)"
        if [ "$PAUSED" == 'false' ]; then
            CLASS="enabled"
            TEXT="$ENABLED"
        else
            CLASS="disabled"
            TEXT="$DISABLED"
            COUNT="$(dunstctl count waiting)"
            if [ "$COUNT" != '0' ]; then
                TEXT="$DISABLED ($COUNT)"
            fi
        fi
        printf '{"text": "%s", "class": "%s"}\n' "$TEXT" "$CLASS"
    done
