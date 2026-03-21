#!/bin/sh

DEFAULT_PRIMARY_PORT=9993
NETWORKS="${ZEROTIER_JOIN_NETWORKS}"

if [ -z "$ZT_PRIMARY_PORT" ]; then
    PORT="${DEFAULT_PRIMARY_PORT}"
else
    PORT="${ZT_PRIMARY_PORT}"
fi

# Check ZeroTier daemon status (common to both branches)
curl -s -o /dev/null --fail \
    -H "X-ZT1-Auth: $(sudo cat /var/lib/zerotier-one/authtoken.secret)" \
    http://localhost:$PORT/status
curlcode=$?

# On curl failure, print the status response for diagnostics
if [ $curlcode -ne 0 ]; then
    curl -s \
        -H "X-ZT1-Auth: $(sudo cat /var/lib/zerotier-one/authtoken.secret)" \
        http://localhost:$PORT/status
fi

if [ -z "$NETWORKS" ]; then

    # No networks configured, just check the daemon is reachable
    if [ $curlcode -eq 0 ]; then
        exit 0  # Service is running, healthcheck passes
    else
        exit 1  # Daemon unreachable
    fi

else

    # Check each joined network status, guard against checkhealth.sh not yet written
    if [ -f /var/lib/zerotier-one/checkhealth.sh ]; then
        /bin/sh /var/lib/zerotier-one/checkhealth.sh
        checkhealthcode=$?
    else
        checkhealthcode=0
    fi

    # On network check failure, print per-network status for diagnostics
    if [ $checkhealthcode -ne 0 ]; then
        for network in $NETWORKS; do
            sudo zerotier-cli get "$network" status
        done
    fi

    if [ $curlcode -eq 0 ] && [ $checkhealthcode -eq 0 ]; then
        exit 0  # Service is running and all networks are OK
    else
        exit 1  # Daemon unreachable or one or more networks not OK
    fi

fi
