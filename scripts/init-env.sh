set -x

# Initialization
REGISTRY_NAME=quay.io
#REGISTRY_NAME=cnfcert-local.redhat.com
REGISTRY=$REGISTRY_NAME/
DIRECTORY=testnetworkfunction/
OPERATOR_BUNDLE_BASE_IMAGE=nginx-operator
OPERATOR_IMAGE=$OPERATOR_BUNDLE_BASE_IMAGE:v0.0.1
OPERATOR_BUNDLE_IMAGE=$OPERATOR_BUNDLE_BASE_IMAGE-bundle:v0.0.1
OPERATOR_BUNDLE_IMAGE_FULL_NAME=$REGISTRY$DIRECTORY$OPERATOR_BUNDLE_IMAGE
OPERATOR_IMAGE_FULL_NAME=$REGISTRY$DIRECTORY$OPERATOR_IMAGE
OPERATOR_REGISTRY_POD_NAME_FULL=$(echo $OPERATOR_BUNDLE_IMAGE_FULL_NAME|sed 's/[\/|\.|:]/-/g')

# Truncate registry pod name if more than 63 characters
if [[ ${#OPERATOR_REGISTRY_POD_NAME_FULL} > 63 ]];then
    OPERATOR_REGISTRY_POD_NAME=${OPERATOR_REGISTRY_POD_NAME_FULL: -63}
else
    OPERATOR_REGISTRY_POD_NAME=$OPERATOR_REGISTRY_POD_NAME_FULL
fi
SECRET_NAME=foo-cert-sec
# Container executable
TNF_CONTAINER_CLIENT="docker"
CONTAINER_CLIENT="${CONTAINER_EXECUTABLE:-$TNF_CONTAINER_CLIENT}"

# Test Namespace
export TNF_EXAMPLE_CNF_NAMESPACE="${TNF_EXAMPLE_CNF_NAMESPACE:-tnf}"

# Create namespace if it does not exist
oc create namespace ${TNF_EXAMPLE_CNF_NAMESPACE} 2>/dev/null

# Default Namespace
export DEFAULT_NAMESPACE="${DEFAULT_NAMESPACE:-default}"

#Partner repo
export TNF_PARTNER_REPO="${TNF_PARTNER_REPO:-quay.io/testnetworkfunction}"
export TNF_DEPLOYMENT_TIMEOUT="${TNF_DEPLOYMENT_TIMEOUT:-240s}"

TNF_NON_OCP_CLUSTER=false
MULTUS_ANNOTATION=""
# Check for Minikube 
res=`oc version | grep  Server`
if [ -z "$res" ]
then
   echo "Minikube or similar detected"
   TNF_NON_OCP_CLUSTER=true
   MULTUS_ANNOTATION="macvlan-conf # multus network"
fi

