function j --description "Fuzzy cd into a directory from ~/.cache/cd_history"
    set cache_file "$HOME/.cache/fish/cd_history"

    # Exit if cache doesn't exist or is empty
    if not test -s $cache_file
        echo "No cached directories found." >&2
        return 1
    end

    # Use fzf to select a directory
    set selection (FZF_DEFAULT_OPTS="--bind tab:down,shift-tab:up" fzf --reverse --height=10 --scheme=path < $cache_file)

    if test -n "$selection" -a -d "$selection"
        cd "$selection"
    else
        echo "Invalid or no selection." >&2
        grep -vFx -- "$selection" $cache_file | sponge $cache_file
        return 1
    end
end
