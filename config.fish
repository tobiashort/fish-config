if status is-interactive
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

    function format_duration --argument ms
        set -l days (math "floor($ms / 86400000)")
        set ms (math "$ms % 86400000")

        set -l hours (math "floor($ms / 3600000)")
        set ms (math "$ms % 3600000")

        set -l minutes (math "floor($ms / 60000)")
        set ms (math "$ms % 60000")

        set -l seconds (math "floor($ms / 1000)")
        set ms (math "$ms % 1000")

        set -l out
        set -l started 0

        if test $days -gt 0
            set out "$out$days"d" "
            set started 1
        end

        if test $started -eq 1 -o $hours -gt 0
            set out "$out$hours"h" "
            set started 1
        end

        if test $started -eq 1 -o $minutes -gt 0
            set out "$out$minutes"m" "
            set started 1
        end

        if test $started -eq 1 -o $seconds -gt 0
            set out "$out$seconds"s" "
        end

        echo (string trim "$out$ms"'ms')
    end

    # Log execution time
    function postexec --on-event fish_postexec
        set last_status $status
        echo
        if [ "$last_status" -ne 0 ]
            echo "exited with code $(set_color yellow)$last_status$(set_color normal)"
        end
        echo "finished $(set_color yellow)$(date '+%Y-%m-%d %H:%M:%S ')$(set_color normal)"
        echo "took $(set_color yellow)$(format_duration $CMD_DURATION)$(set_color normal)"
        echo
        set CMD_DURATION 0
    end

    # Custom helix-like key bindings
    set -g fish_key_bindings th-key-bindings

    # MacOS, if highlighting in visual mode does not work:
    # set -g fish_color_selection --background=brblue --bold

    # Remove vi mode indicator from prompt
    function fish_mode_prompt
    end

    # th-utils integration
    th-change-directory --fish | source
    th-shell-history --integration --fish | source
end
