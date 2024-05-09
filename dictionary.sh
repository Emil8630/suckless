#!/usr/bin/env bash

set -euo pipefail


main() {
    WORD="$(echo "" >/dev/null | dmenu -i -p "Enter word to lookup:")"
    TESTWORD="$(dym -c -n=1 "$WORD")"

    if [ "$WORD" != "$TESTWORD" ]; then
        KEYWORD=$(dym -c "$WORD" | dmenu -i -p "was $WORD a misspelling?(select/no)")
        if [ "$KEYWORD" = "no" ] || [ "$KEYWORD" = "n" ]; then
            KEYWORD="$WORD"
        fi
    else
        KEYWORD="$WORD"
    fi

    if ! [ "${KEYWORD}" ]; then
        printf 'No word inserted\n' >&2
        exit 0
    fi
    echo "$KEYWORD" | xclip -selection clipboard
    alacritty -e trans -v -d "$KEYWORD"
}


noOpt=1

[ $noOpt = 1 ] && MENU="dmenu" && [[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"

