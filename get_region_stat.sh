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
for i in "${regions_arr[@]}"
do
	# list of unique resources from one location 
	regional_resource_types=$(echo $output | jq '.[] | select(.location == '$i') | .type' | sort -u ) 
        regional_resource_types_amount=$(echo $output | jq '.[] | select(.location == '$i') | .type' | wc -l ) 

	echo " "
	echo "Region = " $i ", amount of resources: " $regional_resource_types_amount 


	# json recond of all resource types from one location
	regional_resource_types_list=$(echo $output | jq '.[] | select(.location == '$i') ' ) 

	regional_resource_types_arr=($regional_resource_types)

	for j in "${regional_resource_types_arr[@]=}"
	do
	        regional_resource_item_num=$(echo $regional_resource_types_list | jq 'select(.type == '$j') | .id ' | wc -l)
		printf "%s%s%s%s\t" $j "(" $regional_resource_item_num ")"
	done
	echo ""
done



