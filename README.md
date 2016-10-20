[Azure-sh](https://github.com/abokov/azure-sh) framework and library for management and optimization Azure Resource Group (ARM) resources and services. 
__Azure-Sh__ framework targeted for linux environment and works perfectly on Ubuntu, CentOS and other popular distros.

-----

### Prerequisites:

#### JQ tool
You need to install [JQ tool for JSON parsing](https://stedolan.github.io) - inside __Azure-Sh__ json is most popular format and using this tool makes most of things related to parsing and searching inside json much easier.

```
        sudo apt-get install jq
```

#### Azure xplat sdk

*tbd* how to get/build from github source code 

--------

### Quick reference

* Get all statistic about all resources
```
./get_all_stat.sh
```

* Get all statistic grouped by regions:
```
./get_region_stat.sh
```

* Get statistics grouped by resource type:
```
./get_types_stat.sh
```

* Full list of all resource groups 
It's not a really part of azure-sh, just oneline helper 
```
azure resource list | awk ' {print $3} ' | sort -u
```

* Cleaup all resources inside specified resource group

```
./cleanup_rg.sh %resource_group_name%
```

------
