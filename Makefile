.PHONY:
	install \
  clean \
  delete-deployment \
  create-statefulset \
  install-litmus

# Deploys the partner and test pods and the operator
install:
	./scripts/fix-node-labels.sh
	./scripts/deploy-multus-network.sh
	./scripts/deploy-test-pods.sh
	./scripts/deploy-statefulset-test-pods.sh
	./scripts/deploy-test-crds.sh
	./scripts/deploy-debug-ds.sh
	./scripts/install-olm.sh
	./scripts/deploy-community-operator.sh

# creates a k8s cluster instance
rebuild-cluster:
	./scripts/deploy-k8s-cluster.sh

# launch Vagrant env
vagrant-build:
	mkdir -p config/vagrant/kubeconfig
	vagrant plugin install vagrant-reload
	cd config/vagrant;vagrant up;cd ../..
	cp config/vagrant/kubeconfig/config ~/.kube/config

# destroy Vagrant env
vagrant-destroy:
	cd config/vagrant;vagrant destroy

# create a new docker configuration
new-docker-config:
	./scripts/configure-docker.sh

# deploys the partner pods
install-partner-pods:
	./scripts/deploy-debug-ds.sh
	
# Instal operator requires OLM and operator SDK
install-operator:
	./scripts/deploy-operator.sh

install-community-operator:
	./scripts/deploy-community-operator.sh

delete-community-operator:
	./scripts/delete-community-operator.sh

# Install test CRDs
install-crds:
	./scripts/deploy-test-crds.sh

install-litmus:
	oc apply -f https://litmuschaos.github.io/litmus/2.7.0/litmus-2.7.0.yaml
	oc apply -f ./scripts/operator-ce.yaml

# delete deployment pods
delete-deployment:
	./scripts/delete-test-pods.sh

# create statefulset pods
create-statefulset:
	./scripts/deploy-statefulset-test-pods.sh

delete-litmus:
    oc delete -f https://litmuschaos.github.io/litmus/2.7.0/litmus-2.7.0.yaml
	oc delete -f ./scripts/operator-ce.yaml

# deletes the namespace completely
clean-all:
	./scripts/clean-all.sh

# deletes, the partner and test pods and the operator
# pre-existing objects are preserved
clean:
	./scripts/clean.sh

