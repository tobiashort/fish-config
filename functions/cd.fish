function cd --description 'Change directory and log path to ~/.cache/fish/cd_history'
    # Run builtin cd with all original arguments
    builtin cd $argv
    or return

    # Resolve current directory after cd
    set full_path (pwd)

    # Cache file location
    set cache_file "$HOME/.cache/fish/cd_history"
    mkdir -p (dirname $cache_file)
    touch $cache_file

    # Add path to top of cache file, remove duplicates
    set tmp (mktemp)
    echo $full_path >$tmp
    grep -Fxv "$full_path" $cache_file >>$tmp
    mv $tmp $cache_file
end
