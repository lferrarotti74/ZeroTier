#!/bin/sh

export NETWORKS="${ZEROTIER_JOIN_NETWORKS}"

if [ -z "$NETWORK" ]; then

    curl -s -o /dev/null --fail -H "X-ZT1-Auth: $(cat /var/lib/zerotier-one/authtoken.secret)" http://localhost:9993/status; curlcode=$?

    if [ $curlcode -ne 0 ]; then
        curl -s -H "X-ZT1-Auth: $(cat /var/lib/zerotier-one/authtoken.secret)" http://localhost:9993/status
    fi

    if [ $curlcode -eq 0 ]; then
        exit 0  # Service is running, healthcheck passes
    else
        exit 1  # Something is wrong, not all healthchecks are okay
    fi

else

    curl -s -o /dev/null --fail -H "X-ZT1-Auth: $(cat /var/lib/zerotier-one/authtoken.secret)" http://localhost:9993/status; curlcode=$?

    /checkhealth.sh; checkhealthcode=$?

    if [ $curlcode -ne 0 ]; then
        curl -s -H "X-ZT1-Auth: $(cat /var/lib/zerotier-one/authtoken.secret)" http://localhost:9993/status
    fi

    if [ $checkhealthcode -ne 0 ]; then
        zerotier-cli get "$NETWORKS" status
    fi

    if [ $curlcode -eq 0 ] && [ $checkhealthcode -eq 0 ]; then
        exit 0  # Service is running, healthcheck passes
    else
        exit 1  # Something is wrong, not all healthchecks are okay
    fi

fi