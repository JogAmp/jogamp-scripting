#! /bin/bash

git_branch=master
dest_root=/srv/www/jogamp.org/deployment/autobuilds/${git_branch}/last

rm -rf ${dest_root}
mkdir -p ${dest_root}

modules="gluegen joal joal-demos jogl jogl-demos jocl jocl-demos"
modules_master="gluegen_onmaster joal_onmaster jogl_onmaster jogl-demos_onmaster jocl_onmaster"
nodes="android-arm64 android-x86_64 freebsd-x86_64 linux-arm32 linux-arm64 linux-x86_64 macos-x86_64 windows-x86_64 linux-x86_64-master-001"

this_dir=`pwd`

function node_expected() {
    node=$1
    for x in ${nodes}; do
        if [ "${x}" = "${node}" ]; then
            return 0
        fi
    done
    return 1
}

function copy_tree() {
    for module in ${modules} ${modules_master} ; do
        build_number=
        dest_dir=
        module_root_dir=/srv/jenkins/jobs/${module}/configurations/axis-label
        cd ${module_root_dir}
        for node in `find . -maxdepth 1 -type d` ; do 
            if [ "${node}" != "." -a "${node}" != ".." ] ; then
                node=`basename ${node}`
                if node_expected ${node} ; then
                    module_node_dir=${module_root_dir}/${node}/builds
                    cd ${module_node_dir}
                    if [ -z "${build_number}" ] ; then
                        build_number=`ls -rt  | egrep "^([0-9]+)$" | sort -ug | tail -1`
                        dest_dir=${dest_root}/${module}-b${build_number}
                    fi
                    build_dir=${module_node_dir}/${build_number}/archive/build
                    if [ ! -e ${build_dir} ] ; then
                        echo "Error: ${build_dir} doesn't exist: module ${module}, node ${node}, build ${build_number}!"
                        exit 1
                    fi
                    echo "Copying module ${module}, build ${build_number}, node ${node}"
                    mkdir -p ${dest_dir}
                    cp -a ${build_dir}/* ${dest_dir}/
                else
                    echo "Skipping module ${module}, node ${node}!"
                fi
            fi
        done
        echo ""
    done
}

copy_tree

