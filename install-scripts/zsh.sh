#!/bin/bash
# zsh and oh my zsh including pokemon-color-scripts#
if [[ $USE_PRESET = [Yy] ]]; then
  source ./preset.sh
fi

zsh=(
	eza
	zsh
	zsh-completions
	fzf
)


## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_zsh.log"

# Installing zsh packages
printf "${NOTE} Installing core zsh packages...${RESET}\n"
for ZSH in "${zsh[@]}"; do
  install_package "$ZSH" 2>&1 | tee -a "$LOG"
  if [ $? -ne 0 ]; then
     echo -e "\e[1A\e[K${ERROR} - $ZSH Package installation failed, Please check the installation logs"
  fi
done

clear
