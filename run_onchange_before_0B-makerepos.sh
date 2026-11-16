#!/usr/bin/env bash
#set -euo pipefail

# Enable external repos
repo_path="/usr/share/dnf5/repos.d"
#repo_path="/etc/yum.repos.d"

repo_files=(
"${repo_path}/zoetools.repo"
"${repo_path}/rpmfusion-free.repo"
"${repo_path}/terra.repo"
"${repo_path}/home:mkittler.repo"
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
path_local="${HOME}/Applications/Local-Repo"

[[ -e "${repo_files[0]}" ]] || {
	echo "Creating a local repo."

sudo tee "${repo_path}/zoetools.repo" <<EOF
[zoribtools]
name = "Zorib's Tools Repo"
baseurl = file://"${path_local}"
gpgcheck = 1
enabled = 1
gpgkey = file://"${path_local}/rpm-repo-gpgkey"
EOF

    rpm --delsign "${path_local}/Packages/*.rpm"
    rpm --addsign "${path_local}/Packages/*.rpm"
	createrepo "${path_local}"
}

#sudo dnf -y copr enable
