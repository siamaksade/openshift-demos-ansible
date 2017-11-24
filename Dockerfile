FROM ansible/ansible:centos7

ARG OPENSHIFT_VERSION=v3.7.0-rc.0-e92d5c5

ADD . /opt/demo-playbooks

RUN curl -L -o /tmp/oc.tar.gz https://github.com/openshift/origin/releases/download/v3.7.0-rc.0/openshift-origin-client-tools-${OPENSHIFT_VERSION}-linux-64bit.tar.gz \
    && cd /tmp \
    && tar xvfz oc.tar.gz \
    && cp openshift-origin-client-tools-${OPENSHIFT_VERSION}-linux-64bit/oc /usr/bin/

