# for gaming setup 

apt install -t stable-backports linux-image-amd64
apt install -t stable-backports linux-headers-amd64
apt install nvidia-driver
apt install -t stable-backports firmware-misc-nonfree
apt install -t stable-backports nvidia-cuda-dev
apt install -t stable-backports nvidia-cuda-toolkit

# for network
apt install htop iftop

# for querying debian repository to see stable backport codename (only tagged for current codename, not stable)
# curl -fsSL 'http://ftp.fr.debian.org/debian/dists/stable-backports/Release' | grep -E '^Suite|^Codename'
