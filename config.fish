# Remove greeting
set fish_greeting

# Prompt style
function fish_prompt
    set -g __fish_git_prompt_showdirtystate 1
    set -g __fish_git_prompt_showuntrackedfiles 1
    set -g __fish_git_prompt_showstashstate 1
    set -g __fish_git_prompt_showupstream auto
    set -l symbol ' $ '
    if fish_is_root_user
        set symbol ' # '
    end
    echo -n $USER@$hostname
    echo -n (prompt_pwd)
    echo -n (fish_git_prompt)
    echo -n $symbol
end

# Use vi bindings
fish_vi_key_bindings
# MacOS, if highlighting in visual mode does not work:
# set -g fish_color_selection --background=brblue --bold

# Use different cursor shapes for different vi modes
# set -g fish_vi_force_cursor 1
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_visual block

# Remove vi mode indicator from prompt
function fish_mode_prompt
end
