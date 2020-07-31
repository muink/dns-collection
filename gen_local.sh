#!/bin/sh

CURRENTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $CURRENTDIR

inport='LocalDNS.md'
outport='LocalDNS.yml'

cat << EOF > "$outport"
# ipcidr
# Source: https://github.com/muink/dns-collection/blob/master/LocalDNS.yml
# Last Modified: `date -u '+%F %T %Z'`
payload:
EOF

sed -En "3,$ p" "$inport" | cut -f3,4 -d'|' | sed -En "s|\s||g; s/\|/\n/g p" | grep -E [^[:space:]] | sed -En "s|^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)(:[0-9]+)?$|\1/32|; s|^\[(.+)\](:[0-9]+)?$|\1/128|; p" \
| sed -E "s|^|  - '|; s|$|'|" >> "$outport"

echo >> "$outport"
