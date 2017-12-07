#!/bin/bash

# Demos:
#   msa-cicd-eap-full
#   msa-cicd-eap-min
#   msa--full
#   msa--min

ARG_DEMO=$1
ARG_PRJ_SUFFX=$2

PRJ_SUFFIX=${ARG_PRJ_SUFFX:-demo}
PRJ_CI="ci-$PRJ_SUFFIX"
PRJ_COOLSTORE_PROD="coolstore-prod-$PRJ_SUFFIX"
PRJ_COOLSTORE_STAGE="coolstore-test-$PRJ_SUFFIX"
PRJ_INVENTORY_TEST="inventory-dev-$PRJ_SUFFIX"
PRJ_DEVELOPER="developer-$PRJ_SUFFIX"
PRJ_DEFAULT="coolstore-$PRJ_SUFFIX"


echo "Deleting projects..."

case "$ARG_DEMO" in
    msa-cicd-eap-full|msa-cicd-eap-min)
        oc delete project $PRJ_CI $PRJ_COOLSTORE_PROD $PRJ_COOLSTORE_STAGE $PRJ_INVENTORY_TEST $PRJ_DEVELOPER
        ;;

    msa-full|msa-min)
        oc delete project $PRJ_DEFAULT
        ;;

    *)
        ;;
esac
