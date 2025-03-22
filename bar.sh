#!/usr/bin/bash


interval=30

# Weather
weather() {
  WEATHER_LOCATION=$(cat ~/github/suckless/.wl)

  # URL-encode the city name to handle spaces and special characters
  ENCODED_LOCATION=$(echo "$WEATHER_LOCATION" | jq -sRr @uri)

  # Get coordinates from Nominatim API
  geocode_info=$(curl -s "https://nominatim.openstreetmap.org/search?q=${ENCODED_LOCATION}&format=json&limit=1")

  # Extract latitude and longitude
  latitude=$(echo "$geocode_info" | jq -r '.[0].lat')
  longitude=$(echo "$geocode_info" | jq -r '.[0].lon')

  if [ -n "$latitude" ] && [ -n "$longitude" ]; then
    # Use Open-Meteo API to get weather data
    weather_info=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=${latitude}&longitude=${longitude}&current_weather=true")

    # Check for API request limit error
    if echo "$weather_info" | jq -e '.error' >/dev/null 2>&1; then
      error_reason=$(echo "$weather_info" | jq -r '.reason')
      if [[ "$error_reason" == *"Daily API request limit exceeded"* ]]; then
        echo "Daily API request limit exceeded. Weather information will not be printed." >&2
        return  # Exit the function early
      fi
    fi

    # Proceed only if weather_info is valid and contains current weather data
    if [ -n "$weather_info" ]; then
      # Extract temperature and weather condition from the JSON response
      temp=$(echo "$weather_info" | jq -r '.current_weather.temperature')

      # Check if temp is a valid number
      if [[ "$temp" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
        temp_int=$(printf "%.0f" "$temp") # Round to the nearest integer
        temp_celsius="${temp_int}°C" # Append the Celsius symbol
      else
        echo "Invalid temperature value: $temp" >&2
        temp_celsius="N/A" # Or handle it in another way
      fi

      condition=$(echo "$weather_info" | jq -r '.current_weather.weathercode')

      # Map weather codes to corresponding conditions
      case "$condition" in
        0 | 1)
            weather="Clear"
            weather_icon=""
            ;;
        10 | 11 | 12 | 13 | 14 | 15 | 2 )
            weather="Partly cloudy"
            weather_icon=""
            ;;
        3 )
            weather="Overcast"
            weather_icon=""
            ;;
        61 | 63 | 65 )
            weather="Rain"
            weather_icon=""
            ;;
        66 | 67 )
            weather="Freezing Rain"
            weather_icon="󰙿"
            ;;
        80 | 81 | 82 )
            weather="Rain Showers"
            weather_icon=""
            ;;
        24 | 95 | 96 | 99 )
            weather="Thunder"
            weather_icon=""
            ;;
        71 | 73 | 75 | 86 )
            weather="Snow"
            weather_icon="󰼶"
            ;;
        77 | 85)
            weather="Snow grains"
            weather_icon="󰖘"
            ;;
        45 | 48 | 33 | 34 )
            weather="Mist"
            weather_icon=""
            ;;
        51 | 53 | 55 )
            weather="Drizzle"
            weather_icon="󰖗"
            ;;
        56 | 57 )
            weather="Freezing Drizzle"
            weather_icon="󰙿"
            ;;
        *)
            weather="Unknown weather type please make a pull request adding said weather type."
            weather_icon=""
            ;;
      esac

      # Only print if temp_celsius is valid
      if [ -n "$temp_celsius" ]; then
        printf "^c#B8BAB4^^b#1b1b1b^ $weather_icon $temp_celsius "
        printf "^c#0f100f^^b#0f100f^  "
      fi
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
    printf "^c#B8BAB4^^b#1b1b1b^   $updates updates "
    printf "^c#0f100f^^b#0f100f^  "
    #printf "^c#e1e3da^  Updated"
  elif [[ "$updates" -ge 1000 ]]; then
#    printf "^c#e06c75^  $updates"" updates"
    printf "^c#B8BAB4^^b#e06c75^   $updates updates "
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

disc_free() {
  total_space=$(df / | awk 'NR==2 {print $2}')
  used_space=$(df / | awk 'NR==2 {print $3}')
  used_space_percent=$(( used_space * 100 / total_space ))
  printf "^c#B8BAB4^^b#1b1b1b^ 󰗮 $used_space_percent%% "
	printf "^c#0f100f^^b#0f100f^  "
}

## Main
while true; do
  [ "$interval" == 0 ] || [ $(("$interval" % 3600)) == 0 ] && updates=$(updates)
  interval=$((interval + 1))

  xsetroot -name "$(updates) $(weather) $(disc_free) $(clockdark)"
done
