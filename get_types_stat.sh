#!/bin/bash
# this code is part of azure-sh framework


#echo "Getting resources list..."
output=`azure resource list --json`
#output=`cat out`
#output="$(< out)"
#echo $output
#echo "Parsing results..."


regions=$(echo $output | jq '.[] | .location ' | sort -u )
regions_arr=($regions)
types=$(echo $output | jq '.[] | .type '| sort -u)
types_arr=($types)

types_num=$(echo $output | jq '.[] | .type '| sort -u | wc -l)
resources_num=$(echo $output | jq '.[] | .id ' | wc -l)

echo "resources:" $resources_num ", types: " $types_num ""
echo "Regions: "  $regions

resources=""
t=0
echo ""
for i in "${types_arr[@]=}"
do
        # list of unique resources from one location 
        all_location_for_resources_of_that_type=$(echo $output | jq '.[] | select(.type == '$i') | .location ' )
        all_location_for_resources_of_that_type_num=$(echo $output | jq '.[] | select(.type == '$i') | .location ' | wc -l)
	resources[$t]=$i
	resources[$t]+=$(printf " ")
	resources[$t]+=$all_location_for_resources_of_that_type_num

	t=$((t+1))
done

printf '%s\n' "${resources[@]}" | sort -k2 -n -r


