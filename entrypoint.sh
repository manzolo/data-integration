#!/bin/bash

# Sets script to fail if any command fails.
set -e

set_xauth() {
	echo xauth add $DISPLAY . $XAUTH
	touch /root/.Xauthority
	xauth add $DISPLAY . $XAUTH
}

custom_properties() {
	if [ -f /jobs/.kettle/kettle.properties ] ; then
		cp /jobs/.kettle/kettle.properties $KETTLE_HOME/.kettle/kettle.properties
		echo "Custom kettle.properties ok!"
	else 
		echo "Using standard kettle.properties"
	fi
	if [ -f /jobs/.kettle/shared.xml ] ; then
		cp /jobs/.kettle/shared.xml $KETTLE_HOME/.kettle/shared.xml
		echo "Custom shared.xml ok!"
	else 
		echo "No shared.xml selected"
	fi
	driver_lists=(`find /libs -maxdepth 1 -name "*.jar"`)
	if [ ${#driver_lists[@]} -gt 0 ]; then 
		cp /libs/* $KETTLE_HOME/lib
		echo "Custom libs ok!"
	else 
		echo "No custom libs selected"
	fi
}

run_pan() {
	custom_properties
	echo ./pan.sh -file $@
	pan.sh -file /jobs/$@
}

run_kitchen() {
	custom_properties
	echo ./kitchen.sh -file $@
	kitchen.sh -file /jobs/$@
}

run_spoon() {
	custom_properties
	set_xauth
	echo /data-integration/spoon.sh
	/data-integration/spoon.sh
}

print_usage() {
echo "
Usage:	$0 COMMAND
Pentaho Data Integration (PDI)
Options:
  runj filename		Run job file
  runt filename		Run transformation file
  spoon			Run spoon (GUI)
  help		        Print this help
"
}

case "$1" in
    help)
        print_usage
        ;;
    runt)
	shift 1
        run_pan "$@"
        ;;
    runj)
	shift 1
        run_kitchen "$@"
        ;;
    spoon)
	run_spoon
        ;;
    *)
        exec "$@"
esac
