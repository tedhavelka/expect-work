#!/bin/bash

user=default_user
passphrase=${user}
# remote_command="ip=\`ifconfig | grep inet | grep Bcast | awk '{ print \$2 }' | cut -d\":\" -f2\`; hn=\`hostname\`; echo \"\$ip   \$hn\""
remote_command=`cat ./command.txt`
expect_script="./capture-remote-result.sh"


echo "$0:  starting,"
echo "$0:  to remote hosts will send command:"
echo
echo $remote_command
echo

# exit 0

echo "calling remote hosts one at a time . . ."
echo

for host_ip in `cat ./list-of-stations.txt`
# for host_ip in `cat ./short-list.txt`
do
    echo "calling expect script with host IP number $host_ip . . ."
    ${expect_script} ${host_ip} ${user} ${passphrase} "${remote_command}"
    sleep 1
done


echo
echo "$0:  done."
echo
exit 0
