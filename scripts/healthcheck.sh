#!/bin/sh

DEFAULT_PRIMARY_PORT=9993
export NETWORKS="${ZEROTIER_JOIN_NETWORKS}"

if [ -z "$ZT_PRIMARY_PORT" ]; then

    export PORT="${DEFAULT_PRIMARY_PORT}"

else

    export PORT="${ZT_PRIMARY_PORT}"

fi

if [ -z "$NETWORKS" ]; then

    curl -s -o /dev/null --fail -H "X-ZT1-Auth: $(cat /var/lib/zerotier-one/authtoken.secret)" http://localhost:$PORT/status; curlcode=$?

    if [ $curlcode -ne 0 ]; then
        curl -s -H "X-ZT1-Auth: $(cat /var/lib/zerotier-one/authtoken.secret)" http://localhost:$PORT/status
    fi

    if [ $curlcode -eq 0 ]; then
        exit 0  # Service is running, healthcheck passes
    else
        exit 1  # Something is wrong, not all healthchecks are okay
    fi

else

    curl -s -o /dev/null --fail -H "X-ZT1-Auth: $(cat /var/lib/zerotier-one/authtoken.secret)" http://localhost:$PORT/status; curlcode=$?

    /checkhealth.sh; checkhealthcode=$?

    if [ $curlcode -ne 0 ]; then
        curl -s -H "X-ZT1-Auth: $(cat /var/lib/zerotier-one/authtoken.secret)" http://localhost:$PORT/status
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