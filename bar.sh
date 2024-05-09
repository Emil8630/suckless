#!/usr/bin/bash

interval=0

# Weather

weather() {
  weather_info=$(curl -s wttr.in/$WEATHER_LOCATION?format="%t+%C")
  if [ -n "$weather_info" ]; then
    condition=$(echo "$weather_info" | cut -d'+' -f2)

    # Parse the first word from the condition
    temp=$(echo "$condition" | awk '{print $1}')

    # Remove the first word from the condition
    weather=$(echo "$condition" | sed 's/^[^ ]* //')

    # Map weather conditions to corresponding Nerd Font icons
    case "$weather" in
      "Clear" | "Sunny" )
          weather_icon="" # Nerd Font icon for clear weather
          ;;
      "Partly cloudy" | "Cloudy" | "Partly Cloudy " | "Cloudy ")
          weather_icon="" # Nerd Font icon for partly cloudy or cloudy weather
          ;;
      "Light rain" | "Rain" | "Moderate rain" | "Heavy rain" | "Patchy rain pouring" | "Light Drizzle" | "Light drizzle" | "Patchy rain possible" | "Drizzle" | "Light freezing drizzle" | "Light rain shower, mist" | "Light rain shower" | "Light rain shower" )
          weather_icon="" # Nerd Font icon for rain
          ;;
      "Thunder" )
          weather_icon="" # Nerd Font icon for thunder
          ;;
      "Overcast" | "Overcast ")
          weather_icon="" # Nerd Font icon for overcast
          ;;
      "Snow" | "Light snow" | "Light snow" | "Light snow shower" | "Snow shower" | "Snow grains" )
          weather_icon="" # Nerd Font icon for snow
          ;;
      "Mist" | "Fog" | "Haze" | "Patches of fog")
          weather_icon="" # Nerd Font icon for mist, fog, or haze
          ;;
      *)
          weather_icon="" # Default Nerd Font icon for unknown weather
          ;;
    esac

    printf "^c#B8BAB4^^b#1b1b1b^ $weather_icon $temp "
    printf "^c#0f100f^^b#0f100f^  "
  fi
}


## Time

clockdark() {
    current_month=$(date +%m)
    current_day=$(date +%d)

    if [ "$current_month" -eq 3 ] && [ "$current_day" -ge 25 ] && [ "$current_day" -le 31 ]; then
      printf "^c#B8BAB4^^b#1b1b1b^ 󰪰 $(date '+%a %d %b, %H:%M') "
    elif [ "$current_month" -eq 2 ] && [ "$current_day" -ge 14 ] && [ "$current_day" -le 15 ]; then
      printf "^c#B8BAB4^^b#1b1b1b^ ♥ $(date '+%a %d %b, %H:%M') "
    elif [ "$current_month" -eq 10 ] && [ "$current_day" -ge 30 ] && [ "$current_day" -le 31 ]; then
      printf "^c#B8BAB4^^b#1b1b1b^ 󰮣 $(date '+%a %d %b, %H:%M') "
    elif [ "$current_month" -eq 12 ] && [ "$current_day" -ge 24 ] && [ "$current_day" -le 26 ]; then
      printf "^c#B8BAB4^^b#1b1b1b^  $(date '+%a %d %b, %H:%M') "
    elif [ "$current_month" -eq 12 ] && [ "$current_day" -ge 30 ] && [ "$current_day" -le 31 ]; then
      printf "^c#B8BAB4^^b#1b1b1b^  $(date '+%a %d %b, %H:%M') "
    else
      printf "^c#B8BAB4^^b#1b1b1b^  $(date '+%a %d %b, %H:%M') "
    fi
}

## System Update
updates() {
    updates=$(checkupdates | wc -l)

    if [ "$updates" -ge 300 ]; then
    printf "^c#B8BAB4^^b#1b1b1b^  $updates updates "
    printf "^c#0f100f^^b#0f100f^  "
    #printf "^c#e1e3da^  Updated"
  elif [[ "$updates" -ge 1000 ]]; then
#    printf "^c#e06c75^  $updates"" updates"
    printf "^c#B8BAB4^^b#e06c75^  $updates updates "
    printf "^c#0f100f^^b#0f100f^  "
    else
    :
    fi
}

## Kernel Version
kernel() {
	#printf "^c#B8BAB4^^b#0f100f^  "
	printf "^c#B8BAB4^^b#1b1b1b^  $(uname -r) "
	printf "^c#0f100f^^b#0f100f^  "
}

## Main
while true; do
  [ "$interval" == 0 ] || [ $(("$interval" % 3600)) == 0 ] && updates=$(updates)
  interval=$((interval + 1))

  sleep 1 && xsetroot -name "$(updates) $(weather) $(kernel) $(clockdark)"
done
