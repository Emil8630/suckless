
# Random wall
wall_dir="/home/$USER/github/wallpapers"

pick_random_file() {
    local files; files=("$wall_dir"/*)
    local random_file; random_file=${files[RANDOM % ${#files[@]}]}
    printf "%s\n" "$random_file"
}

wall_main() {
    if [[ ! -d "$wall_dir" ]]; then
        printf "Error: Directory %s does not exist.\n" "$wall_dir" >&2
        return 1
    fi

    local file; file=$(pick_random_file)
    printf "Chosen wall: %s\n" "$file"
    hsetroot -cover $file
}

wall_main "$@"

