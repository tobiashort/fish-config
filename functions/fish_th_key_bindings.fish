set -g fish_key_bindings fish_th_key_bindings

function fish_th_key_bindings

    function cursor-block
        printf '\e[2 q'
    end

    function cursor-bar
        printf '\e[6 q'
    end

    function restore_cursor --on-event fish_prompt
        if test "$fish_bind_mode" = default
            cursor-bar
        end
    end

    function to-normal-mode
        set fish_bind_mode normal
        cursor-block
        commandline -f end-selection repaint
    end

    function to-default-mode
        set fish_bind_mode default
        cursor-bar
        commandline -f end-selection repaint
    end

    function forward-select-word
        commandline -f begin-selection forward-word
    end

    function backward-select-word
        commandline -f begin-selection backward-word
    end

    function append-to-line
        commandline -f end-of-line
        to-default-mode
    end

    function prepend-to-line
        commandline -f beginning-of-line
        to-default-mode
    end

    function delete-selection
        commandline -f kill-selection
    end

    function change-selection
        commandline -f kill-selection
        to-default-mode
    end

    function select-line
        commandline -f beginning-of-line begin-selection end-of-line
    end

    bind -M default \e to-normal-mode

    bind -M normal \e to-normal-mode
    bind -M normal i to-default-mode
    bind -M normal h backward-char
    bind -M normal l forward-char
    bind -M normal b backward-select-word
    bind -M normal w forward-select-word
    bind -M normal gl end-of-line
    bind -M normal gh beginning-of-line
    bind -M normal A append-to-line
    bind -M normal I prepend-to-line
    bind -M normal d delete-selection
    bind -M normal c change-selection
    bind -M normal x select-line
    bind -M normal v begin-selection

    to-default-mode
end
