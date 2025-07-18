function j --description "Fuzzy cd into a directory from ~/.cache/cd_history"
    set cache_file "$HOME/.cache/fish/cd_history"

    # Exit if cache doesn't exist or is empty
    if not test -s $cache_file
        echo "No cached directories found." >&2
        return 1
    end

    # Use fzf to select a directory
    set selection (fzf --reverse --height 10 < $cache_file)

    if test -n "$selection" -a -d "$selection"
        cd "$selection"
    else
        echo "Invalid or no selection." >&2
        return 1
    end
end
