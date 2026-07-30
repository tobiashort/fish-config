set -g th_select_mode off

function th-key-bindings

    function th-cursor-block
        printf '\e[2 q'
    end

    function th-cursor-bar
        printf '\e[6 q'
    end

    function th-restore-cursor --on-event fish_prompt
        if test "$fish_bind_mode" = default
            th-cursor-bar
        end
    end

    function th-to-custom-mode
        set fish_bind_mode th
        th-cursor-block
        commandline -f end-selection repaint
        set -g th_select_mode off
    end

    function th-to-default-mode
        set fish_bind_mode default
        th-cursor-bar
        commandline -f end-selection repaint
    end

    function th-forward-word
        if test $th_select_mode = off
            commandline -f forward-word backward-word begin-selection forward-word
        else
            commandline -f forward-word
        end
    end

    function th-forward-word-end
        if test $th_select_mode = off
            commandline -f forward-word backward-word begin-selection forward-word-end
        else
            commandline -f forward-word-end
        end
    end

    function th-backward-word
        if test $th_select_mode = off
            commandline -f begin-selection backward-word
        else
            commandline -f backward-word
        end
    end

    function th-append-to-line
        commandline -f end-of-line
        th-to-default-mode
    end

    function th-prepend-to-line
        commandline -f beginning-of-line
        th-to-default-mode
    end

    function th-toggle-selection
        if test "$th_select_mode" = on
            set -g th_select_mode off
            commandline -f end-selection
        else
            set -g th_select_mode on
            commandline -f begin-selection
        end
    end

    function th-delete-selection
        set -l start (commandline --selection-start)

        if test "$start"
            commandline -f kill-selection delete-char
        else
            commandline -f delete-char
        end
    end

    function th-change-selection
        commandline -f kill-selection delete-char
        th-to-default-mode
    end

    function th-select-line
        commandline -f beginning-of-line begin-selection end-of-line
    end

    function th-forward-char
        if test $th_select_mode = off
            commandline -f end-selection
        end
        commandline -f forward-char
    end

    function th-backward-char
        if test $th_select_mode = off
            commandline -f end-selection
        end
        commandline -f backward-char
    end

    function th-end-of-line
        if test $th_select_mode = off
            commandline -f end-selection
        end
        commandline -f end-of-line
    end

    function th-beginning-of-line
        if test $th_select_mode = off
            commandline -f end-selection
        end
        commandline -f beginning-of-line
    end

    bind -M default \e th-to-custom-mode
    bind -M default \e\[A history-search-backward
    bind -M default \e\[B history-search-forward
    if not bind -M default \cr >/dev/null 2>&1
        bind -M default \cr history-pager
    end

    bind -M th \e th-to-custom-mode
    bind -M th i th-to-default-mode
    bind -M th h th-backward-char
    bind -M th l th-forward-char
    bind -M th b th-backward-word
    bind -M th w th-forward-word
    bind -M th e th-forward-word-end
    bind -M th gl th-end-of-line
    bind -M th gh th-beginning-of-line
    bind -M th A th-append-to-line
    bind -M th I th-prepend-to-line
    bind -M th d th-delete-selection
    bind -M th c th-change-selection
    bind -M th x th-select-line
    bind -M th v th-toggle-selection
    bind -M th \e\[A history-search-backward
    bind -M th \e\[B history-search-forward
    bind -M th u undo
    bind -M th U redo

    th-to-default-mode
end
