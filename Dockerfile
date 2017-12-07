FROM openshift/origin-ansible:v3.7

RUN mkdir -p /opt/demos
WORKDIR /opt/demos

ADD playbooks /opt/demos/playbooks
ADD roles /opt/demos/roles
ADD ansible.cfg /opt/app-root/src/


