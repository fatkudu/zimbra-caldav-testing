#!/bin/bash

sc_name=`basename $0`
usage="usage : $sc_name [-r caldavtester-dir]"

usage_error ()
{
    echo $usage
    echo "         -r  Root of caldavtester repo cloned from git@github.com:CalConnect/caldavtester.git"
    exit 1
}

caldavtesterRepo=../caldavtester

now=`date '+%b%d-%H.%M'`
while getopts r: CurrOpt
do
    case $CurrOpt in
    r)        caldavtesterRepo="$OPTARG";;
    ?)        usage_error;;
    esac
done


REPO_SERVERINFO_XML=${caldavtesterRepo}/scripts/server/serverinfo.xml
SERVERINFO_XML=serverinfo-caldav.xml

if [ ! -f "${REPO_SERVERINFO_XML}" ]
then
    echo "${REPO_SERVERINFO_XML} does not exist"
    usage_error
fi

echo "Processing ${REPO_SERVERINFO_XML}..."

function editXmlElement {
    xmlName="$1"
    value="$2"
    cat ${SERVERINFO_XML} |sed \
        -e "s%<${xmlName}>.*</${xmlName}>%<${xmlName}>${value}</${xmlName}>%" \
        > new.xml
    mv new.xml ${SERVERINFO_XML}
}

function disableFeature {
    feature="$1"
    grep "<feature>${feature}</feature>" ${SERVERINFO_XML} >/dev/null 2>&1
    if [ $? -ne 0 ]
    then
        echo "Cannot disable feature:$feature"
        return
    fi
    cat ${SERVERINFO_XML} |sed \
        -e "s%<feature>${feature}</feature>%<!-- ZIMBRA <feature>${feature}</feature> -->%" \
        > new.xml
    mv new.xml ${SERVERINFO_XML}
}

function doSubstitution {
    xmlName="$1"
    value="$2"
    cat ${SERVERINFO_XML} |sed \
        -e "s%<${xmlName}>.*</${xmlName}>%<${xmlName}>${value}</${xmlName}>%" \
        > new.xml
    mv new.xml ${SERVERINFO_XML}
}

cp ${REPO_SERVERINFO_XML} ${SERVERINFO_XML}
editXmlElement host `hostname`
editXmlElement nonsslport 80
editXmlElement sslport 443
disableFeature 'CalDAV text-match'
disableFeature 'this-and-future'
disableFeature 'shared-properties-mod'
disableFeature 'COPY Method'
disableFeature 'MOVE Method'
disableFeature 'Sync invalid token'
disableFeature 'ACL Method'
disableFeature 'calendarserver-principal-search REPORT'
disableFeature 'add-member'
# auth-on-root disabled by default already
disableFeature 'brief'
disableFeature 'bulk-post'
disableFeature 'ctag'
disableFeature 'current-user-principal'
disableFeature 'conditional-directory listing'
disableFeature 'extended-principal-search'
disableFeature 'expand-property'
disableFeature 'only-proxy-groups'
disableFeature 'limits'
disableFeature 'own-root'
disableFeature 'prefer-representation'
disableFeature 'prefer-noroot'
disableFeature 'quota'
# quota-on-resources disabled by default already
disableFeature 'resource-id'
# server-info disabled by default already
disableFeature 'sync-report'
# sync-report-limit disabled by default already
disableFeature 'sync-report-home'
disableFeature 'sync-report-config-token'
# per-object-ACLs disabled by default already
# regular-collection disabled by default already
disableFeature 'json-data'
disableFeature 'attachments-collection'
disableFeature 'auto-accept'        # ?
disableFeature 'auto-accept-modes'
disableFeature 'client-fix-TRANSP'
# dropbox disabled by default already
disableFeature 'default-alarms'
disableFeature 'EMAIL parameter'
disableFeature 'extended-freebusy'
disableFeature 'freebusy-url'        # ?
disableFeature 'group-attendee-expansion'
disableFeature 'location-resource-tracking'
disableFeature 'managed-attachments'
disableFeature 'maskuid'
disableFeature 'partstat-timestamp'
# podding disabled by default already
disableFeature 'private-comments'
disableFeature 'private-events'
disableFeature 'proxy'    # ?
# proxy-authz disabled by default already
disableFeature 'recurrence-splitting'
disableFeature 'remove-duplicate-alarms'
disableFeature 'query-extended'
disableFeature 'shared-calendars'
disableFeature 'share-calendars-to-groups'
disableFeature 'external-sharees-disallowed'
disableFeature 'schedule-changes'
disableFeature 'timezones-by-reference'
disableFeature 'timezone-service'
disableFeature 'timezone-std-service'
disableFeature 'trash-collection'
disableFeature 'travel-time-busy'
disableFeature 'vavailability'
# vpoll disabled by default already
disableFeature 'webcal'   # ?
disableFeature 'default-addressbook'   # ?
disableFeature 'shared-addressbooks'   # ?
disableFeature 'shared-addressbook-groups'   # ?
disableFeature 'directory-gateway'
doSubstitution '<value>infinite' '<value>infinity'

cat <<EOF
${SERVERINFO_XML} created

This has only done a partial job - manually merge other substitutions from
zimbra-serverinfo.xml into ${SERVERINFO_XML}

When happy that it is the best "new known good" commit the result as a new
zimbra-serverinfo.xml
EOF

exit 0
