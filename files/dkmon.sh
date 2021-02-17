#!/bin/bash


set -o allexport
source /etc/default/dkmon
set +o allexport

# check if dir and file exists
[ -d "${DKMON_TEXTFILE_DIR}" ] || exit 1
[ -x /usr/local/bin/dkclientx86_64 ] || exit 1

cd "${DKMON_TEXTFILE_DIR}"

/usr/local/bin/dkclientx86_64 -t list > /tmp/dkclient_list

# check distcontrol available
if ! grep -q ' USB ' /tmp/dkclient_list ; then
    > dkmon.tmp
    mv dkmon.tmp dkmon.prom
    exit 0
else
    # generate metrics for node_exporter
    grep ' USB ' /tmp/dkclient_list | while read line ; do
        str=$(echo $line | tr -d '\r\n()')
        echo $str | awk '{ if ($5 ~ /In-use/) {print "dkport{port=\""$3"\",id=\""$4"\"} 1"} else {print "dkport{port=\""$3"\",id=\""$4"\"} 0"}}'
    done > dkmon.tmp
    mv dkmon.tmp dkmon.prom
fi
