# Remove greeting
set fish_greeting

# Prompt style
function fish_prompt
    set -g __fish_git_prompt_showdirtystate 1
    set -g __fish_git_prompt_showuntrackedfiles 1
    set -g __fish_git_prompt_showstashstate 1
    set -g __fish_git_prompt_showupstream auto
    set -l symbol ' $ '
    set -l user_color blue
    if fish_is_root_user
        set symbol ' # '
        set user_color red
    end
    set_color $user_color
    echo -n "$USER"
    set_color normal
    echo -n "@"
    echo -n (prompt_hostname)
    echo -n " "
    echo -n (prompt_pwd)
    echo -n (fish_git_prompt)
    set_color $user_color
    echo -n $symbol
    set_color normal
end

# Log execution time
function postexec --on-event fish_postexec
    set last_status $status
    echo
    if [ "$last_status" -ne 0 ]
        echo "exited with code $(set_color yellow)$last_status$(set_color normal)"
    end
    echo "finished $(set_color yellow)$(date '+%Y-%m-%d %H:%M:%S ')$(set_color normal)"
    echo "took $(set_color yellow)$CMD_DURATION$(set_color normal) milliseconds"
    echo
    set CMD_DURATION 0
end

# Custom helix-like key bindings
fish_th_key_bindings

# MacOS, if highlighting in visual mode does not work:
# set -g fish_color_selection --background=brblue --bold

# Remove vi mode indicator from prompt
function fish_mode_prompt
end

# th-utils integration
# th-change-directory --fish | source
# th-shell-history --integration --fish | source
