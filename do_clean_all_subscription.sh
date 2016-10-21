#!/bin/bash
# this code is part of azure-sh framework

confirm () {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case $response in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}


echo "Do clean all resources in your subscription"
echo "DO you want to start procedure of complete cleanup for all resource in your subscription ? "
confirm   || exit

resource_groups=`azure resource list | tail -n +5 | awk ' {print $4} ' | sort -u`
resource_groups_arr=($resource_groups)

echo "you have " ${#resource_groups_arr[@]} " resource groups"

for i in "${resource_groups_arr[@]}" 
do
	echo "Clean up _everything_ in resource group \""$i"\" ? No - skip that resource group and continue, Ctrl-Break - stop script "
	confirm || continue
#	echo "we do _delete_ for resource group " $i
	./cleanup_rg.sh $i
done

