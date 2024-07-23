echo $HOME

# sudo swapon /dev/nvme0n1p3; 
swww init;
swww-daemon --format xrgb;


export PATH=$PATH:$HOME/bin/Vscode/bin
export SCRIPTS="$HOME/.scripts" 
export PATH=$PATH:$SCRIPTS
export PATH=$PATH:"$(go env GOPATH)/bin"
