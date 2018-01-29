# zimbra-caldav-testing

Bootstrapping for Zimbra runs of https://github.com/CalConnect/caldavtester

    git clone git@github.com:fatkudu/zimbra-caldav-testing.git
    cd zimbra-caldav-testing
    git clone git@github.com:CalConnect/caldavtester.git caldavtester
    cd caldavtester
    git clone git@github.com:apple/ccs-pycalendar.git pycalendar
    git clone git@github.com:CalConnect/caldavtester-tools

## edit serverinfo.xml: eg. url of your server, features, etc

    # inside caldavtester directory
    export SUT=zimbraiop.org.uk
    sed -e "s/localhost/${SUT}/" ../zimbra-serverinfo.xml >serverinfo.xml

## Run tests

    php caldavtester-tools/caldavtests.php --serverinfo=`pwd`/serverinfo.xml --testeroptions='--ssl --debug' --revision=1 --run=CalDAV/caldavIOP.xml

## Look at results

    # launch WebGUI - tells you the URL to goto
    php caldavtester-tools/caldavtests.php --serverinfo=`pwd`/serverinfo.xml --gui=`hostname`:8888
