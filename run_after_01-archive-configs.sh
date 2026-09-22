#!/usr/bin/env bash

echo "Completed! Backing a tar of chezmoi settings..."; sleep 1s
chezmoi archive --gzip --output="${HOME}"/dotfiles.tar.gz
