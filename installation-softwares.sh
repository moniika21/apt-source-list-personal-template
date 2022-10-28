# for gaming setup 

apt install -t stable-backports linux-image-amd64
apt install -t stable-backports linux-headers-amd64
apt install nvidia-driver
apt install -t stable-backports firmware-misc-nonfree
apt install -t stable-backports nvidia-cuda-dev
apt install -t stable-backports nvidia-cuda-toolkit
apt install htop iftop
# curl -fsSL 'http://ftp.fr.debian.org/debian/dists/stable-backports/Release' | grep -E '^Suite|^Codename'
