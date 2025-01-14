echo "Starting installer"

# Add archlinux mirrorlist 2021-06-09 https://wiki.artixlinux.org/Main/Repositories#Arch_repositories
echo "Adding archlinux repositories"
pacman -Sy --noconfirm artix-archlinux-support > /dev/null
printf '

# Arch
[extra]
Include = /etc/pacman.d/mirrorlist-arch

[community]
Include = /etc/pacman.d/mirrorlist-arch
' >> /etc/pacman.conf
echo "Populating keys from archlinux"
pacman-key --populate archlinux


mkfs.ext4 -F /dev/sda
mount /dev/sda /mnt/

basestrap /mnt $(cat /tmp/packages.arch.txt | xargs)

artix-chroot /mnt /bin/bash -c '

echo "Cleaning installation"
{
    TARGET=""

    rm -f $TARGET/usr/lib/udev/*.sh
    rm -f $TARGET/usr/bin/66-*
    rm -f $TARGET/usr/bin/s6-*
}
'

sync
poweroff
