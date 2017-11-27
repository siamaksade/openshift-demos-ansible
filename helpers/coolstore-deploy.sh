#!/bin/bash

# Demos:
#   msa-cicd-eap-full
#   msa-cicd-eap-min
#   msa--full
#   msa--min

ARG_DEMO=$1
ARG_PRJ_SUFFX=$2

PRJ_SUFFIX=${ARG_PRJ_SUFFX:-demo}
PRJ_CI=("ci-$PRJ_SUFFIX" "CI/CD" "CI/CD Components (Jenkins, Gogs, etc)")
PRJ_COOLSTORE_PROD=("coolstore-prod-$PRJ_SUFFIX" "CoolStore PROD" "CoolStore Production Environment")
PRJ_COOLSTORE_STAGE=("coolstore-test-$PRJ_SUFFIX" "CoolStore TEST" "CoolStore Test Environment")
PRJ_INVENTORY_TEST=("inventory-dev-$PRJ_SUFFIX" "Inventory DEV" "Inventory DEV Environment")
PRJ_DEVELOPER=("developer-$PRJ_SUFFIX" "Developer Project" "Personal Developer Project")
PRJ_DEFAULT=("coolstore-$PRJ_SUFFIX" "CoolStore MSA" "CoolStore MSA")

function create_project() {
  echo "Creating project..."
  local _name=$1
  local _display=$2
  local _desc=$3

  oc new-project $1 --display-name="$2" --description="$3" >/dev/null
  oc adm policy add-role-to-group admin system:serviceaccounts:${PRJ_CI[0]} -n $1 >/dev/null 2>&1
  oc adm policy add-role-to-group admin system:serviceaccounts:$1 -n $1 >/dev/null 2>&1
  # oc adm policy add-role-to-user admin $ARG_USERNAME -n $_name >/dev/null 2>&1
  # oc annotate --overwrite namespace $_name demo=demo1-$PRJ_SUFFIX demo=demo-modern-arch-$PRJ_SUFFIX >/dev/null 2>&1
  # oc adm pod-network join-projects --to=${PRJ_CI[0]} $_name >/dev/null 2>&1
}


case "$ARG_DEMO" in
    msa-full)
    msa-min)
        create_project ${PRJ_DEFAULT[0]} "${PRJ_DEFAULT[1]}" "${PRJ_DEFAULT[2]}"
        ;;

    msa-cicd-eap-full)
        create_project ${PRJ_CI[0]} "${PRJ_CI[1]}" "${PRJ_CI[2]}"
        create_project ${PRJ_COOLSTORE_PROD[0]} "${PRJ_COOLSTORE_PROD[1]}" "${PRJ_COOLSTORE_PROD[2]}"
        create_project ${PRJ_COOLSTORE_STAGE[0]} "${PRJ_COOLSTORE_STAGE[1]}" "${PRJ_COOLSTORE_STAGE[2]}"
        create_project ${PRJ_INVENTORY_TEST[0]} "${PRJ_INVENTORY_TEST[1]}" "${PRJ_INVENTORY_TEST[2]}"
        create_project ${PRJ_DEVELOPER[0]} "${PRJ_DEVELOPER[1]}" "${PRJ_DEVELOPER[2]}"
        ;;
        
    msa-cicd-eap-min)
        create_project ${PRJ_CI[0]} "${PRJ_CI[1]}" "${PRJ_CI[2]}"
        create_project ${PRJ_COOLSTORE_PROD[0]} "${PRJ_COOLSTORE_PROD[1]}" "${PRJ_COOLSTORE_PROD[2]}"
        create_project ${PRJ_INVENTORY_TEST[0]} "${PRJ_INVENTORY_TEST[1]}" "${PRJ_INVENTORY_TEST[2]}"
        create_project ${PRJ_DEVELOPER[0]} "${PRJ_DEVELOPER[1]}" "${PRJ_DEVELOPER[2]}"
        ;;

    *)
        ;;
esac

if [ "$ARG_DEMO" == "msa-full" ] || [ "$ARG_DEMO" == "msa-min" ] ; then
elif [] ; then
  create_project ${PRJ_CI[0]} "${PRJ_CI[1]}" "${PRJ_CI[2]}"
  create_project ${PRJ_COOLSTORE_PROD[0]} "${PRJ_COOLSTORE_PROD[1]}" "${PRJ_COOLSTORE_PROD[2]}"
  create_project ${PRJ_COOLSTORE_STAGE[0]} "${PRJ_COOLSTORE_STAGE[1]}" "${PRJ_COOLSTORE_STAGE[2]}"
  create_project ${PRJ_INVENTORY_TEST[0]} "${PRJ_INVENTORY_TEST[1]}" "${PRJ_INVENTORY_TEST[2]}"
  create_project ${PRJ_DEVELOPER[0]} "${PRJ_DEVELOPER[1]}" "${PRJ_DEVELOPER[2]}"
fi
