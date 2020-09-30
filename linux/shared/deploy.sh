#!/bin/bash

usage() { 
cat << EOF
Usage: $0 
    -a <up|destroy|halt|resume|reload|suspend>  vagrant action
    -p <virtualbox|vmware_desktop>              vagrant provider type
    [-f]                                        force packer rebuild
EOF
exit 1; 
}

while getopts ":a:fp:" o; do
    case "${o}" in
        a)
            if [ "${OPTARG}" == "up" ] || [ "${OPTARG}" == "destroy" ] || [ "${OPTARG}" == "halt" ] || [ "${OPTARG}" == "resume" ] || [ "${OPTARG}" == "suspend" ]; then
                a=${OPTARG}
            else
                echo "Invalid value provided for action option"
                usage
            fi
            ;;
        p)
            if [ "${OPTARG}" == "virtualbox" ] || [ "${OPTARG}" == "vmware_desktop" ]; then
                p=${OPTARG}
                
                if [ "${p}" == "virtualbox" ]; then
                    only="virtualbox-iso"
                else
                    only="vmware-iso"
                fi
            else
                echo "Invalid value provided for provider option"
                usage
            fi
            ;;
        f)
            force="true"
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${a}" ] || [ -z "${p}" ]; then
    usage
fi

if [ "${force}" == "true" ]; then
    echo "Starting packer build"
    packer build -only ${only} -var 'version=1.2.0' box-config.json
fi
export VAGRANT_DEFAULT_PROVIDER=${p}
vagrant ${a}