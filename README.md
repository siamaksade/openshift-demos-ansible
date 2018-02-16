# OpenShift Demos Ansible Roles and Playbooks
[![Build Status](https://travis-ci.org/siamaksade/openshift-demos-ansible.svg?branch=master)](https://travis-ci.org/siamaksade/openshift-demos-ansible)

### Deploy CoolStore Microservices with CI/CD
In order to deploy the complete demo infrastructure for demonstrating Microservices, CI/CD, 
agile integrations and more, either order the demo via RHPDS or use the following script to provision the demo
on any OpenShift environment:

#### Prerequisites
* [JBoss](https://raw.githubusercontent.com/jboss-openshift/application-templates/ose-v1.4.8-1/jboss-image-streams.json) and [Fuse](https://raw.githubusercontent.com/openshift/openshift-ansible/master/roles/openshift_examples/files/examples/v3.7/xpaas-streams/fis-image-streams.json) image streams installed on OpenShift ([instructions](https://docs.openshift.com/container-platform/3.7/install_config/imagestreams_templates.html#creating-image-streams-for-xpaas-middleware-images))
* Jenkins 3.7 tag imported to OpenShift, if not running the playbooks as `system:admin`
  ```
  oc import-image jenkins:v3.7 --from='registry.access.redhat.com/openshift3/jenkins-2-rhel7:v3.7' --confirm -n openshift
  ```

### Run Playbooks Locally (Ansible installed)

* [Install Ansible](http://docs.ansible.com/ansible/latest/intro_installation.html)
* Run the playbooks

```
$ git clone https://github.com/siamaksade/openshift-demos-ansible.git
$ cd openshift-demos-ansible
$ git checkout ocp-3.7
$ oc login http://openshiftmaster
$ ansible-galaxy install -r playbooks/coolstore/requirements.yml
$ ansible-playbook playbooks/coolstore/msa-cicd-eap-min.yml -e "github_ref=stable-ocp-3.7"
```

### Run Playbooks Locally (Docker installed)

* Install Docker
* Run the playbooks

```
$ oc login http://openshiftmaster
$ docker run --rm -it siamaksade/openshift-demos-ansible:ocp-3.7 playbooks/coolstore/msa-cicd-eap-min.yml \
      -e "openshift_master=$(oc whoami --show-server)" \
      -e "oc_token=$(oc whoami -t)" \
      -e "github_ref=stable-ocp-3.7"
```

### Run Playbooks on OpenShift (with cluster admin)

The [provided templates](helpers/coolstore-ansible-installer.yaml) creates an OpenShift Job to run 
the Ansible playbooks. Check out the template for the complete list of parameters available.

  ```
  $ oc login -u system:admin
  $ oc new-project demo-installer
  $ oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:demo-installer:default
  
  $ oc new-app -f http://bit.ly/coolstore-ansible-template \
      --param=DEMO_NAME=msa-full \
      --param=PROJECT_ADMIN=developer \
      --param=COOLSTORE_GITHUB_REF=stable-ocp-3.7
      --param=ANSIBLE_PLAYBOOKS_VERSION=ocp-3.7

  $ oc logs -f jobs/coolstore-ansible-installer
  ```

### Playbooks

| Playbook                                                      | Description                                                             | Memory     | CPU     |
|---------------------------------------------------------------|-------------------------------------------------------------------------|------------|---------|
| [msa-min](playbooks/coolstore/msa-min.yml)                    | Deploys CoolStore with min required services                            | 4 GB       | 1 cores |
| [msa-full](playbooks/coolstore/msa-full.yml)                  | Deploys CoolStore with all services                                     | 8 GB       | 2 cores |
| [msa-cicd-eap-min](playbooks/coolstore/msa-cicd-eap-min.yml)  | Deploys CoolStore with CI/CD and min services (Dev-Prod)                | 8 GB       | 2 cores |
| [msa-cicd-eap-full](playbooks/coolstore/msa-cicd-eap-full.yml)| Deploys CoolStore with CI/CD and all services (Dev-Test-Prod)           | 20 GB      | 8 cores |
| [undeploy](playbooks/coolstore/undeploy.yml)                  | Delete the demos                                                        | -          | -       |


### Variables

You can modify the playbooks behavior by specifying extra variables

```
$ ansible-playbook demos/coolstore/msa-min.yml -e "github_ref=stable-ocp-3.7 ephemeral=true project_suffix=demo1"
```

| Variable             | Default   | Description                                                                                                            |
|----------------------|-----------|------------------------------------------------------------------------------------------------------------------------|
| `openshift_master`   | *none*    | OpenShift master url. Not required if playbooks run on a host that is already authenticated to OpenShift               |
| `oc_token`           | *none*    | Authentication token for OpenShift. Not required if playbooks run on a host that is already authenticated to OpenShift |
| `oc_kube_config`     | *none*    | Path to .kube config if not using the default                                                                          |
| `project_suffix`     | demo      | A suffix to be added to all project names e.g. cicd-demo                                                               |
| `ephemeral`          | false     | If set to true, all pods will be deployed without persistent storage                                                   |
| `maven_mirror_url`   | false     | Maven repository for Java S2I builds. If empty, Sonatype Nexus gets deployed and used                                  |
| `github_account`     | master    | GitHub account to deploy from in forked: https://github.com/[github-account]/coolstore-microservice                    |
| `github_ref`         | master    | GitHub branch to deploy from: https://github.com/jbossdemocentral/coolstore-microservice                               |
| `project_admin`      | none      | OpenShift user to be assigned as the project admin. Default is the logged-in user                                      |
| `deploy_guides`      | true      | Deploy demo guides as a pod in the CI/CD project                                                                       |


For a list of all options, check [demo variables](playbooks/coolstore/group_vars/all)