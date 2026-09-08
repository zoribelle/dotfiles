#!/usr/bin/env bash
#set -euo pipefail

# Enable external repos
repo_files=(
"/etc/yum.repos.d/zoetools.repo"
"/etc/yum.repos.d/rpmfusion-free.repo"
"/etc/yum.repos.d/terra.repo"
"https://download.opensuse.org/repositories/home:/mkittler/Fedora_44/home:mkittler.repo"
)

# RPM Fusion
[[ -e "${repo_files[1]}" ]] || {
sudo dnf -y install \
"https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
"https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
}

# Terra Fyra Labs
[[ -e "${repo_files[2]}" ]] || {
sudo dnf -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
}

# Extra RPM Repos
[[ -e "${repo_files[3]}" ]] || {
sudo dnf -y config-manager addrepo --from-repofile="https://download.opensuse.org/repositories/home:/mkittler/Fedora_$(rpm -E %fedora)/home:mkittler.repo"
}

# Local Repo for RPMs unavailable in remote repos

[[ -e "${repo_files[0]}" ]] || {
	echo "Creating a local repo."

sudo tee "/etc/yum.repos.d/zoetools.repo" <<EOF
[zoribtools]
name = "Zorib's Tools Repo"
baseurl = file://"${HOME}/Applications/Local-Repo"
gpgcheck = 0
enabled = 1
EOF

	createrepo "$HOME/Applications/Local-Repo/"
}

#sudo dnf -y copr enable "lizardbyte/stable" # Sunshine
#sudo dnf -y copr enable "errornointernet/quickshell"
#sudo dnf -y copr enable "ilyaz/LACT"
#sudo dnf -y copr enable "luwxs/input-actions-editor"
