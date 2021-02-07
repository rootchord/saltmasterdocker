FROM koji/image-build

LABEL maintainer="Red Hat, Inc."

LABEL com.redhat.component="rhel7-atomic-container" \
      name="rhel7-atomic" \
      version="7.9"

LABEL com.redhat.license_terms="https://www.redhat.com/licenses/eulas"

#labels for container catalog
LABEL summary="Provides the latest release of Red Hat Enterprise Linux 7 in a minimal, fully supported base image where several of the traditional operating system components such as python an systemd have been removed."
LABEL description="The Red Hat Enterprise Linux Base image is designed to be a minimal, fully supported base image where several of the traditional operating system components such as python an systemd have been removed. The Atomic Image also includes a simple package manager called microdnf which can add/update packages as needed."
LABEL io.k8s.display-name="Red Hat Enterprise Linux 7"
LABEL io.openshift.tags="minimal rhel7"

ENV container oci
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN rm -rf /var/log/*

RUN yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest.el7.noarch.rpm 
RUN yum update -y
RUN yum install -y salt-master git 

RUN yum –y install openssh-server openssh-clients

RUN systemctl start sshd

RUN systemctl enable sshd

RUN systemctl status sshd

RUN sed -i 's/#auto_accept: False/auto_accept: True/' /etc/salt/master
RUN systemctl enable salt-master

CMD ["/usr/sbin/init"]

EXPOSE 8080 4505 4505
