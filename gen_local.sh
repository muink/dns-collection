#!/bin/sh

inport='./localDNS.md'
outport='./localdns.yaml'

cat << EOF > "$outport"
# ipcidr
# Source: https://github.com/muink/dns-collection/blob/master/LocalDNS.yaml
# Last Modified: `date -u '+%F %T %Z'`
payload:
EOF

sed -En "3,$ p" "$inport" | cut -f3,4 -d'|' | sed -En "s|\s||g; s/\|/\n/g p" | grep -E [^[:space:]] | sed -En "s|^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)(:[0-9]+)?$|\1/32|; s|^(\[.+\])(:[0-9]+)?$|\1/128|; p" \
| sed -E "s|^|  - '|; s|$|'|" >> "$outport"

echo -e "\n" >> "$outport"
