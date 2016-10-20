#!/bin/bash
# this code is part of azure-sh framework

echo Script name: $0
if [ "$#" -ne 1 ]; then
    echo "illegal number of parameters - usage './cleanup_rg.sh resource_group_name"
    echo "example: ./cleanup_rg.sh my-group"
    exit
fi

resource_group=$1


echo "Clean up all resources in resource group : $resource_group"
output=`azure resource list $resource_group  --json`
#output=`azure resource list $resource_group  --json > out`
#output=`cat out`
#output="$(< out)"


names=$(echo $output | jq --raw-output '.[] | .name ')
names_arr=($names)
# we don't need resourceType like "Microsoft.Web/smth", --raw-output give Microsoft.Web/smth
types=$(echo $output | jq --raw-output '.[] | .type ')
types_arr=($types)

t=0
for i in "${names_arr[@]}"
do
	type=${types_arr[$t]}
	resource_provider=$(echo $type| cut -d/ -f1)  # from Microsoft.Web/smth to Microsoft.Web

	# nice trick, get first and most new api-version, nevermind about resourcename, hope it works fine for all Microsoft* resource:-)
	api_version=$(azure provider show $resource_provider  --json | jq --raw-output ' .resourceTypes | .[] | .apiVersions[0]' | sort -u -r | grep -v preview | head -n 1)
        echo "delete resource : " $i ", provider: " $resource_provider ", type = " $type ", apiVersion: " $api_version

# use that for debugging
#       echo "azure resource show --resource-group" $resource_group "--name" $i "--resource-type" $type "--api-version" $api_version
#        azure resource show --resource-group $resource_group --name $i --resource-type $type --api-version $api_version
        azure resource delete -q --resource-group $resource_group --name $i --resource-type $type --api-version $api_version

        t=$((t+1))
done

