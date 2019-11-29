# set greeting to something cute and friendly
set -U fish_greeting "              ,---------------------------,
              |  /---------------------\  |
              | |                       | |
              | |  Welcome to fish,     | |
              | |    the friendly       | |
              | |    interactive shell  | |
              | |                       | |
              |  \_____________________/  |
              |___________________________|
            ,---\_____     []     _______/------,
          /         /______________\           /|
        /___________________________________ /  | ___
        |                                   |   |    )
        |  _ _ _                 [-------]  |   |   (
        |  o o o                 [-------]  |  /    _)_
        |__________________________________ |/     /  /
    /-------------------------------------/|      ( )/
  /-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/ /
/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/ /
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

# do not clobber old config
if test -d ~/.config/fish
    set backup_config_dir_name (date +"%Y-%m-%dT%H:%M")-(uuidgen | cut -c-8 -)
    set backup_config_dir ~/.config/fish/backups/$backup_config_dir_name
    echo "bootstrap: saving existing fish config at $backup_config_dir"
    mkdir -p $backup_config_dir

    set current_to_backup_sed_pattern "s/\/.config\/fish/\/.config\/fish\/backups\/$backup_config_dir_name/" 

    # create backup directory subdirectories
    for d in (find ~/.config/fish \( ! -regex '.*.config\/fish\/backups.*' \) -a \( -type d \) -print)
        mkdir -p (echo -n $d | sed -e "$current_to_backup_sed_pattern")
    end

    # move each file to backup directory
    for f in (find ~/.config/fish \( ! -regex '.*.config\/fish\/backups.*' \) -a \( ! -type d \) -print)
        mv $f (echo -n $f | sed -e "$current_to_backup_sed_pattern")
    end
end

# copy over fish config
echo "bootstrap: writing fish config"
cp -R ./fish_configs/** ~/.config/fish/

# install packages i use
echo "bootstrap: install packages"
brew install git cloc tmux nmap vim tree thefuck ripgrep youtube-dl

# install work specific stuff iff we are at work
if test -x ./affirm_dotfiles/boostrap.fish
    echo "bootstrap: running affirm bootstrap"
    ./affirm_dotfiles/bootstrap.fish
else
    echo "bootstrap: warning: affirm bootstrap script not found"
end
