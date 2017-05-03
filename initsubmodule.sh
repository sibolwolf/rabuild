#!/bin/bash

cnt=1
GOPATH=`pwd`
base_path=`pwd`

echo "************************************************"
echo "${cnt}. Build base go_dep module_name and module_url"
modules_list=(`cat gomodules_dep.txt`)
sub_cnt=1
for module in ${modules_list[@]}
do
    echo "${cnt}.${sub_cnt}..................................."
    module=(${module//,/ })
    module_name=${module[0]//submodule=/ }
    module_url=${module[1]//path=/ }

    echo "module name is:${module_name}"
    echo "module url is:${module_url}"

    module_name=${module_name//src/.\/src}

    echo ${module_name}

    echo "${cnt}.${sub_cnt}.1 Create submodule"
    if [ -d ${module_name} ]; then
        echo "module exist, do not need create and init"
    else
        echo "git submodule add -f ${module_url} ${module_name}"
        git submodule add -f ${module_url} ${module_name}

        echo "git submodule update --init --recursive"
        git submodule update --init --recursive
    fi

    echo "${cnt}.${sub_cnt}.2 Get submodule status"
    echo "cd ${module_name}"
    cd ${module_name}
    pwd
    git branch -a
    git status
    cd ${base_path}

    let sub_cnt=sub_cnt+1
done

let cnt=cnt+1

echo "************************************************"
echo "${cnt}. Init go_dep module_name and module_url"
modules_list=(`cat gomodules_dep.txt`)
sub_cnt=1
for module in ${modules_list[@]}
do
    echo "${cnt}.${sub_cnt}..................................."
    module=(${module//,/ })
    module_name=${module[0]//submodule=/ }
    module_url=${module[1]//path=/ }

    echo "module name is:${module_name}"
    echo "module url is:${module_url}"

    module_name=${module_name//src/.\/src}

    echo "module name is:${module_name}"

    echo "${cnt}.${sub_cnt}.1 Go get submodule"
#    if [ -d ${module_name} ]; then
#        echo "module exist, do not need create and init"
#    else
#        echo "git submodule add -f ${module_url} ${module_name}"
#        git submodule add -f ${module_url} ${module_name}
#
#        echo "git submodule update --init --recursive"
#        git submodule update --init --recursive
#	module_name_host=${module_name/.\/src\//}
#	echo ${module_name_host}
#	go get -v ${module_name_host}
#    fi
    module_name_host=${module_name/.\/src\//}
    echo "module_name_host is: ${module_name_host}"
    go get -v ${module_name_host}

    echo "${cnt}.${sub_cnt}.2 Get submodule status"
    echo "cd ${module_name}"
    cd ${module_name}
    pwd
    git branch -a
    git status
    cd ${base_path}

    let sub_cnt=sub_cnt+1
done

let cnt=cnt+1

echo "************************************************"
echo "${cnt}. Init go module_name and module_url"
modules_list=(`cat gomodules.txt`)
sub_cnt=1
for module in ${modules_list[@]}
do
    echo "${cnt}.${sub_cnt}..................................."
    module=(${module//,/ })
    module_name=${module[0]//submodule=/ }
    module_url=${module[1]//path=/ }

    echo "module name is:${module_name}"
    echo "module url is:${module_url}"

    user_name=`git config user.name`
    module_name=${module_name//src/.\/src}
    #module_url=${module_url//git.nane.cn/${user_name}@git.nane.cn}

    echo "${cnt}.${sub_cnt}.1 Create submodule"
    if [ -d ${module_name} ]; then
        echo "module exist, do not need create and init"
    else
        echo "git submodule add -f ${module_url} ${module_name}"
        git submodule add -f ${module_url} ${module_name}

        echo "git submodule update --init --recursive"
        git submodule update --init --recursive
    fi

    echo "${cnt}.${sub_cnt}.2 Get submodule status"
    echo "cd ${module_name}"
    cd ${module_name}
    pwd
    git branch -a
    git status
    git checkout master
    git pull
    cd ${base_path}

    let sub_cnt=sub_cnt+1
done

let cnt=cnt+1
