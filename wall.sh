#!/bin/bash

# Base wallpaper directory
base_wall_dir="/home/$USER/github/wallpapers"
echo "Base wallpaper directory: $base_wall_dir"

# Define directories for each season and holiday
declare -A season_dirs=(
    ["spring"]="$base_wall_dir/spring"
    ["summer"]="$base_wall_dir/summer"
    ["autumn"]="$base_wall_dir/autumn"
    ["winter"]="$base_wall_dir/winter"
    ["valentine"]="$base_wall_dir/valentine"
    ["christmas"]="$base_wall_dir/christmas"
    ["new_year"]="$base_wall_dir/new_year"
    ["halloween"]="$base_wall_dir/halloween"
    ["space"]="$base_wall_dir/space"
)

# Function to determine the current season or holiday
get_current_theme() {
    local month day
    month=$(date +%m)
    day=$(date +%d)

    # Remove leading zero from month
    month=$((10#$month))

    # Debug output (redirected to stderr)
    echo "Current month: $month" >&2
    echo "Current day: $day" >&2

    # Check for holidays first
    if [[ "$month" -eq 2 && "$day" -eq 14 ]]; then
        echo "valentine"
    elif [[ "$month" -eq 12 && "$day" -ge 23 && "$day" -le 26 ]]; then
        echo "christmas"
    elif [[ ( "$month" -eq 12 && "$day" -eq 31 ) || ( "$month" -eq 1 && "$day" -eq 1 ) ]]; then
        echo "new_year"
    elif [[ "$month" -eq 10 && "$day" -eq 31 ]]; then
        echo "halloween"
    else
        # Check for seasons
        if [[ "$month" -ge 3 && "$month" -le 5 ]]; then
            echo "spring"  # March to May
        elif [[ "$month" -ge 6 && "$month" -le 8 ]]; then
            echo "summer"  # June to August
        elif [[ "$month" -ge 9 && "$month" -le 11 ]]; then
            echo "autumn"  # September to November
        else
            echo "winter"   # December to February
        fi
    fi
}

# Function to pick a random file from a given directory
pick_random_file() {
    local dir="$1"
    local files; files=("$dir"/*)
    if [ ${#files[@]} -eq 0 ]; then
        printf "Error: No wallpapers found in %s.\n" "$dir" >&2
        return 1
    fi
    local random_file; random_file=${files[RANDOM % ${#files[@]}]}
    printf "%s\n" "$random_file"
}

# Main function to set the wallpaper
wall_main() {
    local current_theme=""

    # Check if the user provided a manual override flag
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -spring) current_theme="spring"; shift ;;
            -summer) current_theme="summer"; shift ;;
            -autumn) current_theme="autumn"; shift ;;
            -winter) current_theme="winter"; shift ;;
            -valentine) current_theme="valentine"; shift ;;
            -christmas) current_theme="christmas"; shift ;;
            -newyear) current_theme="new_year"; shift ;;
            -halloween) current_theme="halloween"; shift ;;
            -space) current_theme="space"; shift ;;
            *) echo "Unknown option: $1"; return 1 ;;
        esac
    done

    # If no manual flag is set, use automatic detection
    if [[ -z "$current_theme" ]]; then
        current_theme=$(get_current_theme)
    fi

    # Debug output to check the current theme
    printf "Current theme: %s\n" "$current_theme"  # Output the current theme

    # Check if the current theme exists in the season_dirs array
    if [[ -z "${season_dirs[$current_theme]}" ]]; then
        echo "Fallback to space theme" >&2
        current_theme="space"
    fi

    local wall_dir="${season_dirs[$current_theme]}"

    # Debug output to check the wall_dir variable
    printf "Checking directory: %s\n" "$wall_dir"  # Print the directory being checked

    if [[ ! -d "$wall_dir" ]]; then
        printf "Error: Directory %s does not exist.\n" "$wall_dir" >&2
        return 1
    fi

    local file; file=$(pick_random_file "$wall_dir")
    printf "Chosen wall: %s\n" "$file"
    hsetroot -cover "$file"
}

wall_main "$@"

