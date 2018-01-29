#!/bin/bash
sc_name=`basename $0`
hn=`zmhostname`
domain=example.test

value=true
[ $# -ge 1 ] && value="$1"

# VAL=`echo $value | tr '[:lower:]' '[:upper:]'`
(set -x;zmlocalconfig -e debug_caldav_enable_dav_client_can_choose_resource_basename="${value}")
(set -x;zmlocalconfig -e debug_caldav_allow_attendee_for_organizer="${value}")

(set -x;sleep 3)
zmcontrol restart
echo createDomain $domain>/tmp/zimbraSetup.prov
for acct in 01 02 03 04 05 06 07 08 09 10 \
    11 12 13 14 15 16 17 18 19 20 \
    21 22 23 24 25 26 27 28 29 30 \
    31 32 33 34 35 36 37 38 39 40
do
    echo "deleteAccount cdt${acct}@${domain}" >> /tmp/zimbraSetup.prov
    echo "createAccount cdt${acct}@${domain} test123 zimbraMailHost ${hn} cn \"Cdt ${acct}\" displayName \"Cdt ${acct}\"" >> /tmp/zimbraSetup.prov
done
(set -x; zmprov </tmp/zimbraSetup.prov)
exit 0
