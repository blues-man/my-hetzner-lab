FROM centos
# Enable openstack repo
# Use centos-release-openstack-rocky, because ansible want openstacksdk > 0.12.
RUN yum install -y centos-release-openstack-rocky  epel-release
# Install packages
RUN yum install -y python2-openstackclient python2-heatclient git python2-shade python2-openstacksdk ansible

WORKDIR /work

CMD while true; do sleep 1; date; done;
