# OpenShift Demos Ansible Roles and Playbooks

### Deploy CoolStore Microservices with CI/CD
In order to deploy the complete demo infrastructure for demonstrating Microservices, CI/CD, 
agile integrations and more, either order the demo via RHPDS or use the following script to provision the demo
on any OpenShift environment:

```
$ git clone https://github.com/siamaksade/openshift-demos-ansible.git
$ cd openshift-demos-ansible
$ docker run --rm -it  \
    -v ~/.kube:/opt/app-root/src/.kube \
    -v $(pwd):/playbooks 
    -w /playbooks openshift/origin-ansible:v3.7 \
    ansible-playbook demos/coolstore-msa/deploy.yml --extra-vars "ephemeral=true"
```

### Variables

| Variable         | Default | Description                                                          |
|------------------|---------|----------------------------------------------------------------------|
| `project_suffix` | demo    | A suffix to be added to all project names e.g. cicd-demo             |
| `ephemeral`      | false   | If set to true, all pods will be deployed without persistent storage |

```
ephemeral           
```
