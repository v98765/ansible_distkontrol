#!/bin/bash

set -o allexport
source /etc/default/dkmon
set +o allexport

DK_OID_UPTIME='.1.3.6.1.2.1.25.1.1.0'
DK_OID_PORT='.1.3.6.1.4.1.2021.20'

[ -d "${DKMON_TEXTFILE_DIR}" ] || exit 1
[ -x /usr/bin/snmpget ] || exit 1

cd "${DKMON_TEXTFILE_DIR}"

# port range 1..4 and 1..16. ie 1.1 to 4.16
id=1
for ip in `echo "${DKMON_IP}"` ; do
    >  "dkmon_snmp_${id}.tmp"
    if snmpget -Oqv -c "${DKMON_COMMUNITY}" -v2c "${ip}" "${DK_OID_UPTIME}" > /dev/null; then
        for i1 in {1..4} ; do
            for i2 in {1..16} ; do
                DK_PORT_ID="${DK_OID_PORT}.${i1}.${i2}"
                RESULT=$(snmpget -Oqv -c "${DKMON_COMMUNITY}" -v2c "${ip}" "${DK_PORT_ID}")
                if [ "${RESULT}" -le 1 ] ; then
                    echo "dkmon_snmp{ip=\"${ip}\",port=\"${i1}.${i2}\"} ${RESULT}" >> "dkmon_snmp_${id}.tmp"
                fi
            done
        done
    fi
    let id=1+${id}
done
cat dkmon_snmp_*.tmp > dkmon_snmp.prom
rm -f dkmon_snmp_*.tmp
