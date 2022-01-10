## Author: Mohammad Chehab
## Split traffic to the router instead of the global protect tunnel.
## if i want to automated globalprotect https://github.com/dlenski/openconnect

ip=$(netstat -rn | head -n 5 | grep 172 | awk {'print $2'})
pc="YOUR_PC"
router="192.168.0.1"

echo "IP Address : ${ip}"
echo "Gateway    : ${router}"
echo "PC Name    : ${pc}"

[[ -z "${ip}" ]] && {
    echo "IP Address could not find 172 in the top 5 records netstat -rn"
    exit 1;
}

sudo route delete 0.0.0.0 > /dev/null 2>&1 

[[ "$?" -gt 0 ]] && {
    echo "0.0.0.0 is already deleted"
}

sudo route -n add -net 0.0.0.0 "${router}" > /dev/null 2>&1

[[ "$?" -gt 0 ]] && {
    echo "failed to forward 0.0.0.0 to ${router}"
}

##prod pc
sudo route -n add -net ${pc}.cbd.prd "${ip}" > /dev/null 2>&1

[[ "$?" -gt 0 ]] && {
    echo "failed to forward ${pc}.cbd.prd to ${ip}"
}

echo "Connected to GlobalProtect and traffic is now being routed to the router ${router}"
