#!/bin/sh

grepzt() {
  [ -f /var/lib/zerotier-one/zerotier-one.pid -a -n "$(cat /var/lib/zerotier-one/zerotier-one.pid 2>/dev/null)" -a -d "/proc/$(cat /var/lib/zerotier-one/zerotier-one.pid 2>/dev/null)" ]
  return $?
}

mkztfile() {
  file=$1
  mode=$2
  content=$3

  mkdir -p /var/lib/zerotier-one
  echo "$content" > "/var/lib/zerotier-one/$file"
  chmod "$mode" "/var/lib/zerotier-one/$file"
}

if [ "x$ZEROTIER_API_SECRET" != "x" ]
then
  mkztfile authtoken.secret 0600 "$ZEROTIER_API_SECRET"
fi

if [ "x$ZEROTIER_IDENTITY_PUBLIC" != "x" ]
then
  mkztfile identity.public 0644 "$ZEROTIER_IDENTITY_PUBLIC"
fi

if [ "x$ZEROTIER_IDENTITY_SECRET" != "x" ]
then
  mkztfile identity.secret 0600 "$ZEROTIER_IDENTITY_SECRET"
fi

mkztfile zerotier-one.port 0600 "9993"

killzerotier() {
  log "Killing zerotier"
  kill "$(cat /var/lib/zerotier-one/zerotier-one.pid 2>/dev/null)"
  exit 0
}

log_header() {
  printf "\r=>"
}

log_detail_header() {
  printf "\r===>"
}

log() {
  echo "$(log_header)" "$@"
}

log_params() {
  title=$1
  shift
  log "$title" "[$@]"
}

log_detail() {
  echo "$(log_detail_header)" "$@"
}

log_detail_params() {
  title=$1
  shift
  log_detail "$title" "[$@]"
}

trap killzerotier INT TERM

log "Configuring networks to join"
mkdir -p /var/lib/zerotier-one/networks.d

if [ "x$@" != "x" ]
then
  log_params "Joining networks from command line:" "$@"
  for i in "$@"
  do
    log_detail_params "Configuring join:" "$i"
    touch "/var/lib/zerotier-one/networks.d/${i}.conf"
  done
fi

if [ "x$ZEROTIER_JOIN_NETWORKS" != "x" ]
then
  log_params "Joining networks from environment:" "$ZEROTIER_JOIN_NETWORKS"
  for i in $ZEROTIER_JOIN_NETWORKS
  do
    log_detail_params "Configuring join:" "$i"
    touch "/var/lib/zerotier-one/networks.d/${i}.conf"
  done
fi

DEFAULT_PRIMARY_PORT=9993
DEFAULT_PORT_MAPPING_ENABLED=true
DEFAULT_ALLOW_TCP_FALLBACK_RELAY=true

if [ "$ZT_OVERRIDE_LOCAL_CONF" = 'true' ] || [ ! -f "/var/lib/zerotier-one/local.conf" ]; then
  echo "{
    \"settings\": {
        \"primaryPort\": ${ZT_PRIMARY_PORT:-$DEFAULT_PRIMARY_PORT},
        \"portMappingEnabled\": ${ZT_PORT_MAPPING_ENABLED:-$DEFAULT_PORT_MAPPING_ENABLED},
        \"softwareUpdate\": \"disable\",
        \"allowTcpFallbackRelay\": ${ZT_ALLOW_TCP_FALLBACK_RELAY:-$DEFAULT_ALLOW_TCP_FALLBACK_RELAY}
    }
  }" > /var/lib/zerotier-one/local.conf
fi

if [ "x$ZT_PLANET_URL_FILE" != "x" ]; then
  log_params "Downloading Custom Planet File from Controller URL:" "$ZT_PLANET_URL_FILE"
  curl -s "$ZT_PLANET_URL_FILE" -o /var/lib/zerotier-one/planet
fi

if [ "x$@" != "x" ] && [ "x$ZT_DEVICEMAP" != "x" ]; then
  log_params "Special Device Mapping was selected for joining Network from command line:" "$@"
  echo $@="$ZT_DEVICEMAP" > /var/lib/zerotier-one/devicemap
fi

if [ "x$ZEROTIER_JOIN_NETWORKS" != "x" ] && [ "x$ZT_DEVICEMAP" != "x" ]; then
  log_params "Special Device Mapping was selected for joining Network from environment:" "$ZEROTIER_JOIN_NETWORKS"
  echo "$ZEROTIER_JOIN_NETWORKS"="$ZT_DEVICEMAP" > /var/lib/zerotier-one/devicemap
fi

if [ "x$ZT_INTERFACE_PREFIX_BLACKLIST" != "x" ]; then
  log_params "Special list of Interfaces that need to be blacklisted is provided:" "$ZT_INTERFACE_PREFIX_BLACKLIST"
  tmpfile=$(mktemp)
  INTERFACEPREFIXBLACKLIST=$(echo "$ZT_INTERFACE_PREFIX_BLACKLIST" | jq -R 'split(",")');
  cp /var/lib/zerotier-one/local.conf "$tmpfile" &&
  jq --argjson interfacePrefixBlacklist "$INTERFACEPREFIXBLACKLIST" '.settings += { interfacePrefixBlacklist: $interfacePrefixBlacklist }' "$tmpfile" >/var/lib/zerotier-one/local.conf &&
  rm -f -- "$tmpfile"
fi

if [ "x$ZT_ALLOW_MANAGEMENT_FROM" != "x" ]; then
  log_params "Special list of Management Networks is provided:" "$ZT_ALLOW_MANAGEMENT_FROM"
  tmpfile=$(mktemp)
  ALLOWMANAGEMENTFROM=$(echo "$ZT_ALLOW_MANAGEMENT_FROM" | jq -R 'split(",")');
  cp /var/lib/zerotier-one/local.conf "$tmpfile" &&
  jq --argjson allowManagementFrom "$ALLOWMANAGEMENTFROM" '.settings += { allowManagementFrom: $allowManagementFrom }' "$tmpfile" >/var/lib/zerotier-one/local.conf &&
  rm -f -- "$tmpfile"
fi

if [ "x$ZT_TCP_FALLBACK_RELAY" != "x" ]; then
  log_params "Special value for TCP Fallback Relay is provided:" "$ZT_TCP_FALLBACK_RELAY"
  tmpfile=$(mktemp)
  TCPFALLBACKRELAY=$(echo "$ZT_TCP_FALLBACK_RELAY");
  cp /var/lib/zerotier-one/local.conf "$tmpfile" &&
  jq --arg tcpFallbackRelay $TCPFALLBACKRELAY '.settings = { tcpFallbackRelay: $tcpFallbackRelay } + .settings' "$tmpfile" >/var/lib/zerotier-one/local.conf &&
  rm -f -- "$tmpfile"
fi

if [ "x$ZT_FORCE_TCP_RELAY" != "x" ]; then
  log_params "Special value for Force TCP Relay is provided:" "$ZT_FORCE_TCP_RELAY"
  tmpfile=$(mktemp)
  FORCETCPRELAY=$(echo "$ZT_FORCE_TCP_RELAY");
  cp /var/lib/zerotier-one/local.conf "$tmpfile" &&
  jq --arg forceTcpRelay $FORCETCPRELAY '.settings = { forceTcpRelay: $forceTcpRelay } + .settings' "$tmpfile" >/var/lib/zerotier-one/local.conf &&
  rm -f -- "$tmpfile"
fi

if [ "x$ZT_SECONDARY_PORT" != "x" ]; then
  log_params "Special value for Secondary Port is provided:" "$ZT_SECONDARY_PORT"
  tmpfile=$(mktemp)
  SECONDARYPORT=$(echo "$ZT_SECONDARY_PORT");
  cp /var/lib/zerotier-one/local.conf "$tmpfile" &&
  jq --argjson secondaryPort "$SECONDARYPORT" '.settings += { secondaryPort: $secondaryPort }' "$tmpfile" >/var/lib/zerotier-one/local.conf &&
  rm -f -- "$tmpfile"
fi

if [ "x$ZT_TERTIARY_PORT" != "x" ]; then
  log_params "Special value for Tertiary Port is provided:" "$ZT_TERTIARY_PORT"
  tmpfile=$(mktemp)
  TERTIARYPORT=$(echo "$ZT_TERTIARY_PORT");
  cp /var/lib/zerotier-one/local.conf "$tmpfile" &&
  jq --argjson tertiaryPort "$TERTIARYPORT" '.settings += { tertiaryPort: $tertiaryPort }' "$tmpfile" >/var/lib/zerotier-one/local.conf &&
  rm -f -- "$tmpfile"
fi

if [ "x$ZT_ALLOW_SECONDARY_PORT" != "x" ]; then
  log_params "Special value for enable/disable Secondary Port is provided:" "$ZT_ALLOW_SECONDARY_PORT"
  tmpfile=$(mktemp)
  SECONDARY_PORT=$(echo "$ZT_ALLOW_SECONDARY_PORT");
  cp /var/lib/zerotier-one/local.conf "$tmpfile" &&
  jq --argjson allowSecondaryPort "$SECONDARY_PORT" '.settings += { allowSecondaryPort: $allowSecondaryPort }' "$tmpfile" >/var/lib/zerotier-one/local.conf &&
  rm -f -- "$tmpfile"
fi

if [ "x$ZT_BIND" != "x" ]; then
  log_params "Special list of IPs to bind instead of all interfaces is provided:" "$ZT_INTERFACE_PREFIX_BLACKLIST"
  tmpfile=$(mktemp)
  BINDIPLIST=$(echo "$ZT_BIND" | jq -R 'split(",")');
  cp /var/lib/zerotier-one/local.conf "$tmpfile" &&
  jq --argjson bind "$BINDIPLIST" '.settings += { bind: $bind }' "$tmpfile" >/var/lib/zerotier-one/local.conf &&
  rm -f -- "$tmpfile"
fi

log "Starting ZeroTier"
nohup /usr/sbin/zerotier-one &

while ! grepzt
do
  log_detail "ZeroTier hasn't started, waiting a second"

  if [ -f nohup.out ]
  then
    tail -n 10 nohup.out
  fi

  sleep 1
done

if [ "x$@" != "x" ]; then
  log_params "Writing healthcheck for networks:" "$@"

  cat >/checkhealth.sh <<EOF
#!/bin/bash
for i in $@
do
  [ "\$(zerotier-cli get \$i status)" = "OK" ] || exit 1
done
EOF

  chmod +x /checkhealth.sh
fi

if [ "x$ZEROTIER_JOIN_NETWORKS" != "x" ]; then
  log_params "Writing healthcheck for networks:" "$ZEROTIER_JOIN_NETWORKS"

  cat >/checkhealth.sh <<EOF
#!/bin/bash
for i in $ZEROTIER_JOIN_NETWORKS
do
  [ "\$(zerotier-cli get \$i status)" = "OK" ] || exit 1
done
EOF

  chmod +x /checkhealth.sh
fi

if [ -z "$ZT_PRIMARY_PORT" ]; then

  while ! nc -z localhost $DEFAULT_PRIMARY_PORT; do   
    sleep 0.1 # wait for 1/10 of the second before check again
  done

else

  while ! nc -z localhost $ZT_PRIMARY_PORT; do   
    sleep 0.1 # wait for 1/10 of the second before check again
  done

fi

log_params "zerotier-cli info:" "$(zerotier-cli info)"

log "Sleeping infinitely"
while true
do
  sleep 1
done
