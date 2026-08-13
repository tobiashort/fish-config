set -g th_select_mode off
set -g th_select_mode_backward_char_first_time true

function th-key-bindings

    function th-noop
    end

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
        th-select-mode-off
    end

    function th-to-default-mode
        set fish_bind_mode default
        th-cursor-bar
        commandline -f end-selection repaint
    end

    function th-select-mode-on
        set -g th_select_mode on
        set -g th_select_mode_backward_char_first_time true
    end

    function th-select-mode-off
        set -g th_select_mode off
    end

    function th-toggle-selection
        if test "$th_select_mode" = on
            th-select-mode-off
            commandline -f end-selection
        else
            th-select-mode-on
            commandline -f begin-selection
        end
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
        else
            if $th_select_mode_backward_char_first_time
                set -g th_select_mode_backward_char_first_time false
                commandline -f end-selection forward-char begin-selection backward-char
            end
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

    function th-yank
        fish_clipboard_copy
        th-select-mode-off
        commandline -f end-selection
    end

    function th-paste-after
        if test $cursor -eq (string length -- $commandline)
            commandline -i ' '
        else
            commandline -f forward-char
        end
        fish_clipboard_paste
    end

    function th-paste-before
        fish_clipboard_paste
    end

    function th-execute
        commandline -f execute
        th-to-default-mode
    end

    bind -M default \e th-to-custom-mode
    bind -M default \e\[200~ th-noop
    bind -M default \e\[201~ th-noop
    bind -M default \e\[A history-search-backward
    bind -M default \e\[B history-search-forward
    if not bind -M default \cr >/dev/null 2>&1
        bind -M default \cr history-pager
    end

    bind -M th \e th-to-custom-mode
    bind -M th \e\[200~ th-noop
    bind -M th \e\[201~ th-noop
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
    bind -M th y th-yank
    bind -M th p th-paste-after
    bind -M th P th-paste-before
    bind -M th \r th-execute

    th-to-default-mode
end
