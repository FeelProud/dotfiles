#!/bin/sh

set -e # -e: exit on error

# Set some colors for output messages
OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 5)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

if [ ! "$(command -v paru)" ]; then
  if [ ! "$(command -v git)" ]; then
    pacman -Sy --noconfirm git 2>&1 || { printf "%s - Failed to install git using AUR\n" "${ERROR}"; exit 1; }
  fi
  if [ ! "$(command -v curl)" ]; then
    pacman -Sy --noconfirm curl 2>&1 || { printf "%s - Failed to install git using AUR\n" "${ERROR}"; exit 1; }
  fi

  git clone https://aur.archlinux.org/paru.git || { printf "%s - Failed to clone paru from AUR\n" "${ERROR}"; exit 1; }
  cd paru || { printf "%s - Failed to enter paru directory\n" "${ERROR}"; exit 1; }
  makepkg -si --noconfirm 2>&1 || { printf "%s - Failed to install paru from AUR\n" "${ERROR}"; exit 1; }
  paru -Syu --noconfirm 2>&1 || { printf "%s - Failed to update system\n" "${ERROR}"; exit 1; }
fi

if [ ! "$(command -v chezmoi)" ]; then
  bin_dir="$HOME/.local/bin"
  chezmoi="$bin_dir/chezmoi"
  sh -c "$(curl -fsSL https://git.io/chezmoi)" -- -b "$bin_dir"
else
  chezmoi=chezmoi
fi