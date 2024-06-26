#!/bin/bash

note_dir="$(pwd)/.notes"

main() {
    # Picking our options.
    choice=$(printf 'Copy note\nNew note\nDelete note\nQuit' | dmenu -i -p 'Notes:' "$@")

    # Choose what we should do with our choice.
    case "$choice" in
    'Copy note')
        # shellcheck disable=SC2154
        note_pick=$(dmenu -i -p 'Copy:' "$@" <"${note_dir}")
        [ -n "${note_pick}" ] && echo "${note_pick}" | cp2cb && notify-send -u normal "Note copied" "${note_pick}"
        ;;
    'New note')
        note_new=$(echo "" | dmenu -i -p 'Enter new note:' "$@")
        # Making sure the input is not empty and not already exist in note_dir.
        # The sed command should prevent grep from taking certain characters as a regex input.
        [ -n "$note_new" ] && ! grep -q "^$(echo "${note_new}" | sed -e 's/\[/\\[/g;s/\]/\\]/g')\$" "${note_dir}" \
            && echo "${note_new}" >>"${note_dir}" && notify-send -u normal "Note created" "${note_new}"
        ;;
    'Delete note')
        note_del=$(${MENU} 'Delete:' "$@" <"${note_dir}")
        # grep should always returns 0 regardless what happens.
        grep -v "^$(echo "${note_del}" | sed -e 's/\[/\\[/g;s/\]/\\]/g')\$" "${note_dir}" >"/tmp/dmnote" || true
        [ -n "${note_del}" ] && cp -f "/tmp/dmnote" "${note_dir}" && notify-send -u normal "Note deleted" "${note_del}"
        ;;
    'Quit')
        echo "Program terminated." && exit 0
        ;;
    *)
        exit 0
        ;;
    esac
}

MENU="dmenu -i" && [[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
