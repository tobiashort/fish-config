set -g th_visual_mode off

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

    function th-to-normal-mode
        set fish_bind_mode normal
        th-cursor-block
        commandline -f end-selection repaint
        set -g th_visual_mode off
    end

    function th-to-default-mode
        set fish_bind_mode default
        th-cursor-bar
        commandline -f end-selection repaint
    end

    function th-forward-word
        if test $th_visual_mode = off
            commandline -f forward-word backward-word begin-selection forward-word
        else
            commandline -f forward-word
        end
    end

    function th-forward-word-end
        if test $th_visual_mode = off
            commandline -f forward-word backward-word begin-selection forward-word-end
        else
            commandline -f forward-word-end
        end
    end

    function th-backward-word
        if test $th_visual_mode = off
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
        if test "$th_visual_mode" = on
            set -g th_visual_mode off
            commandline -f end-selection
        else
            set -g th_visual_mode on
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
        if test $th_visual_mode = off
            commandline -f end-selection
        end
        commandline -f forward-char
    end

    function th-backward-char
        if test $th_visual_mode = off
            commandline -f end-selection
        end
        commandline -f backward-char
    end

    bind -M default \e th-to-normal-mode
    bind -M default \e\[A history-search-backward
    bind -M default \e\[B history-search-forward

    bind -M normal \e th-to-normal-mode
    bind -M normal i th-to-default-mode
    bind -M normal h th-backward-char
    bind -M normal l th-forward-char
    bind -M normal b th-backward-word
    bind -M normal w th-forward-word
    bind -M normal e th-forward-word-end
    bind -M normal gl end-of-line
    bind -M normal gh beginning-of-line
    bind -M normal A th-append-to-line
    bind -M normal I th-prepend-to-line
    bind -M normal d th-delete-selection
    bind -M normal c th-change-selection
    bind -M normal x th-select-line
    bind -M normal v th-toggle-selection
    bind -M normal \e\[A history-search-backward
    bind -M normal \e\[B history-search-forward
    bind -M normal u undo
    bind -M normal U redo

    th-to-default-mode
end
