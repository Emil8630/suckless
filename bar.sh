#!/usr/bin/bash


interval=0

# Weather
weather() {
  WEATHER_LOCATION=$(cat .wl)

  # URL-encode the city name to handle spaces and special characters
  ENCODED_LOCATION=$(echo "$WEATHER_LOCATION" | jq -sRr @uri)

  # Get coordinates from Nominatim API
  geocode_info=$(curl -s "https://nominatim.openstreetmap.org/search?q=${ENCODED_LOCATION}&format=json&limit=1")

  # Debugging: Print the raw geocode response
  #echo "Geocode response: $geocode_info" >&2

  # Extract latitude and longitude
  latitude=$(echo "$geocode_info" | jq -r '.[0].lat')
  longitude=$(echo "$geocode_info" | jq -r '.[0].lon')

  if [ -n "$latitude" ] && [ -n "$longitude" ]; then
    # Use Open-Meteo API to get weather data
    weather_info=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=${latitude}&longitude=${longitude}&current_weather=true")

    if [ -n "$weather_info" ]; then
      # Extract temperature and weather condition from the JSON response
      temp=$(echo "$weather_info" | jq -r '.current_weather.temperature')

      # Format the temperature to get the integer part and add the Celsius symbol
      temp_int=$(printf "%.0f" "$temp") # Round to the nearest integer
      temp_celsius="${temp_int}°C" # Append the Celsius symbol

      condition=$(echo "$weather_info" | jq -r '.current_weather.weathercode')

      # Map weather codes to corresponding conditions
      case "$condition" in
        0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 )
            weather="Clear" # Adjust based on Open-Meteo weather codes
            weather_icon="" # Nerd Font icon for clear weather
            ;;
        10 | 11 | 12 | 13 | 14 | 15 )
            weather="Partly cloudy" # Adjust based on Open-Meteo weather codes
            weather_icon="" # Nerd Font icon for partly cloudy or cloudy weather
            ;;
        16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 )
            weather="Rain" # Adjust based on Open-Meteo weather codes
            weather_icon="" # Nerd Font icon for rain
            ;;
        24 )
            weather="Thunder" # Adjust based on Open-Meteo weather codes
            weather_icon="" # Nerd Font icon for thunder
            ;;
        25 | 26 )
            weather="Overcast" # Adjust based on Open-Meteo weather codes
            weather_icon="" # Nerd Font icon for overcast
            ;;
        27 | 28 | 29 | 30 )
            weather="Snow" # Adjust based on Open-Meteo weather codes
            weather_icon="" # Nerd Font icon for snow
            ;;
        31 | 32 | 33 | 34 )
            weather="Mist" # Adjust based on Open-Meteo weather codes
            weather_icon="" # Nerd Font icon for mist, fog, or haze
            ;;
        *)
            weather="Unknown weather type please make a pull request adding said weather type." # Default case
            weather_icon="" # Default Nerd Font icon for unknown weather
            ;;
      esac

      printf "^c#B8BAB4^^b#1b1b1b^ $weather_icon $temp_celsius "
      printf "^c#0f100f^^b#0f100f^  "
    fi
  else
    echo "Could not find coordinates for $WEATHER_LOCATION." >&2
  fi
}




## Time

clockdark() {
    current_month=$(date +%m)
    current_day=$(date +%d)

    if [ "$current_month" -eq 3 ] && [ "$current_day" -ge 25 ] && [ "$current_day" -le 31 ]; then
      printf "^c#B8BAB4^^b#1b1b1b^ 󰪰 $(date '+%a %d %b, %H:%M') "
    elif [ "$current_month" -eq 2 ] && [ "$current_day" -ge 13 ] && [ "$current_day" -le 14 ]; then
      printf "^c#B8BAB4^^b#1b1b1b^  $(date '+%a %d %b, %H:%M') "
    elif [ "$current_month" -eq 10 ] && [ "$current_day" -ge 30 ] && [ "$current_day" -le 31 ]; then
      printf "^c#B8BAB4^^b#1b1b1b^ 󰮣 $(date '+%a %d %b, %H:%M') "
    elif [ "$current_month" -eq 12 ] && [ "$current_day" -ge 24 ] && [ "$current_day" -le 26 ]; then
      printf "^c#B8BAB4^^b#1b1b1b^  $(date '+%a %d %b, %H:%M') "
    elif [ "$current_month" -eq 12 ] && [ "$current_day" -ge 30 ] && [ "$current_day" -le 31 ]; then
      printf "^c#B8BAB4^^b#1b1b1b^  $(date '+%a %d %b, %H:%M') "
    else
      printf "^c#B8BAB4^^b#1b1b1b^ 󰥔 $(date '+%a %d %b, %H:%M') "
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
