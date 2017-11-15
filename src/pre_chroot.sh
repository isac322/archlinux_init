#!/usr/bin/env zsh

# Select appropriate server
servers=(`pcregrep -M 'South Korea\nServer\s+=\s+.+' /etc/pacman.d/mirrorlist | sed -En 's/Server\s+=\s+(.+)/\1/p'`)

best=''
min_rtt=''

for server in ${servers}; do
	address=`echo ${server} | sed -En 's/http:\/\/([^\/]+).*/\1/p'`
	rtt=`ping -nqc 10 -s 1024 ${address} | tail -1 | awk -F '/' '{print $5}'`

	if [[ (! -z ${rtt}) && (-z ${min_rtt} || ${rtt} -le ${min_rtt}) ]]; then
		min_rtt=${rtt}
		best=${server}
	fi
done

echo ${best}
echo "Server = ${best}" > /etc/pacman.d/mirrorlist


pacstrap ${MOUNT_POINT} base base-devel zsh vim

genfstab -U -p ${MOUNT_POINT} >> ${MOUNT_POINT}/etc/fstab
