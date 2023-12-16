#!/bin/sh

CURRENTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $CURRENTDIR

inport='LocalDNS.md'
tmpout='LocalDNS.tmp'

sed -En "3,$ p" "$inport" | cut -f3,4 -d'|' | sed -En "s|\s||g; s/\|/\n/g p" | grep -E [^[:space:]] | sed -En "s|^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)(:[0-9]+)?$|\1/32|; s|^\[(.+)\](:[0-9]+)?$|\1/128|; p" > "$tmpout"

clashout='LocalDNS.yml'
singout='LocalDNS.json'

# clash
cat << EOF > "$clashout"
# ipcidr
# Source: https://github.com/muink/dns-collection/blob/master/LocalDNS.yml
# Last Modified: `date -u '+%F %T %Z'`
payload:
EOF
cat "$tmpout" | sed -E "s|^|  - '|; s|$|'|" >> "$clashout"
echo >> "$clashout"

# sing-box
cat <<-EOF > "$singout"
	{
	  "__Source__": "https://github.com/muink/dns-collection/blob/master/LocalDNS.json",
	  "__last_modified__": "$(date -u '+%F %T %Z')",
	  "version": 1,
	  "rules": [
	    {
	      "ip_cidr": [
EOF
sed -En 's|^|        "|; s|$|",|; p' "$tmpout" >> "$singout"
sed -i '${s|,$||}' "$singout"
cat <<-EOF >> "$singout"
	      ]
	    }
	  ]
	}
EOF

# cleanup
rm -f "$tmpout"
