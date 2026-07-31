#!/usr/bin/env bash

echo "Completed! Backing a tar of chezmoi settings..."; sleep 1s
tar cf dotfiles.tar "${HOME}/.local/share/chezmoi/"*
