echo "Adding a new disk to the VM..."

set -e
set -x

if [ -f /etc/disk_added_date ]
then
   echo "disk already added so exiting."
   exit 0
fi


sudo fdisk -u /dev/sdb <<EOF
n
p
1


t
8e
w
EOF

pvcreate /dev/sdb1
vgextend data-science-toolbox-vg /dev/sdb1
lvextend /dev/data-science-toolbox-vg/lv_root
resize2fs /dev/data-science-toolbox-vg/lv_root

date > /etc/disk_added_date