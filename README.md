# My Hetzner lab

Based on https://github.com/andyneeb/ansible-hetzner - Thanks!

Notes
-----

**Caution when using. Systems are rebooted and installed without further inquiry.**

Platforms
---------

Tested on RHEL / CentOS. Should work on all platforms.

Activate webservice
-------------------

To use the webservice, go to ``Settings > Webservice settings`` in portal and define a password. You will receive your user via Mail from Hetzner.

Example playbook
----------------

```yml
- name: provision hetzner root server
  hosts: hetzner
  gather_facts: no
  remote_user: root

  vars:
    hetzner_webservice_username: "your_hetzner_webservice_user"
    hetzner_webservice_password: "your_hetzner_webservice_password"
    hetzner_image: "/root/.oldroot/nfs/install/../images/CentOS-75-64-minimal.tar.gz"
    hetzner_hostname: "hostname.example.com"

  tasks:
  - import_role:
      name: provision-hetzner

```

Example autosetup file
----------------------

The following ``autosetup`` file  will be used by default. Modify ``roles/provision-hetzner/templates/autosetup`` or create your own and set ``{{ hetzner_autosetup_file }}``.
 Further details regarding the file can be found at [Hetzner in the wiki](https://wiki.hetzner.de/index.php/Installimage/en#autosetup).

```
DRIVE1 /dev/sda
DRIVE2 /dev/sdb
SWRAID 1
SWRAIDLEVEL 0
BOOTLOADER grub
HOSTNAME {{ hetzner_hostname }}
PART /boot ext3 512M
PART lvm vg0 500G
PART lvm cinder-volumes all

LV vg0 root / ext4 100G
LV vg0 swap swap swap 5G

IMAGE {{ hetzner_image }}
```

Hetzner offers a collection of images which can be set via ``{{ hetzner_image }}``. Examples include:

* archlinux-latest-64-minimal.tar.gz
* CentOS-610-64-minimal.tar.gz
* CentOS-75-64-minimal.tar.gz
* CoreOS-1298-64-production.bin.bz2
* Debian-811-jessie-64-minimal.tar.gz
* Debian-95-stretch-64-minimal.tar.gz
* Ubuntu-1604-xenial-64-minimal.tar.gz
* Ubuntu-1710-artful-64-minimal.tar.gz
* Ubuntu-1804-bionic-64-minimal.tar.gz

You can alos build a custom image and host it on a public webserver. In that case {{ hetzner_image }} needs to point to that location.

# Install Red Hat OpenStack 14 - Rocky

 1) Create or hosts file, example ```hosts.sample```
 2) *Optional*
    Create certificates with 
    ```
    ./00_letsencrypt_with_cloudflare.yml -i hosts
    ```
 2) Basis os Installation: 
      ```
      ./01_install_os.yml -i hosts
      ```
 3) Prepare hetzner server: 
      ``` 
      ./02_prepare-openstack-14.yml -i hosts
      ```
 4) Run openstack installation within tmux* **ON the hetzer 
 box** : 
      
      *because wo do a lot of network configuration, at one point your ssh connection get lost!
     ``` 
     ./03_install-openstack-14.yml -i hosts
     ```
 5) And now, final reboot your hetzner box

# Install OpenShift on BareMetal

Requirements:
 - DNS at [Cloudflare](https://www.cloudflare.com/), if you like you can remove the certificate stuff

Installation
 1) Create or hosts file, example ```hosts.openshift.example```
 2) Request certificates: 
      ```
      ./00_letsencrypt_with_cloudflare.yml
      ```
 3) Basis os Installation: 
      ```
      ./01_install_os.yml
      ```
 4) Prepare OpenShift installation:   
      ```
      ./02_prepare-openshift.yml
      ```
 5) Install OpenShift: **Connect to your host and run**
    ``` 
    cd ~/ansible/ 
    ansible-playbook -i hosts /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml
    ansible-playbook -i hosts /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml
    867453
    448665
    ```
 6) *Optional*: Install Kubevirt - [OpenShift Blog](https://blog.openshift.com/getting-started-with-kubevirt/)
    ```
    # add permissions if using OpenShift
    oc adm policy add-scc-to-user privileged -n kube-system -z kubevirt-privileged
    oc adm policy add-scc-to-user privileged -n kube-system -z kubevirt-controller
    oc adm policy add-scc-to-user privileged -n kube-system -z kubevirt-apiserver
    # apply the KubeVirt configuration, adjust RELEASE for the current version
    RELEASE=v0.11.0
    kubectl apply -f https://github.com/kubevirt/kubevirt/releases/download/${RELEASE}/kubevirt.yaml
    curl -O -L https://github.com/kubevirt/kubevirt/releases/download/${RELEASE}/virtctl-${RELEASE}-linux-amd64
    sudo mv virtctl-${RELEASE}-linux-amd64 /usr/local/bin/virtctl
    sudo chmod +x /usr/local/bin/virtctl
    ```
 7) *Optional*: Deploy Kubevirt Web-UI
    - [Start Operator](https://github.com/kubevirt/web-ui-operator#variant-1-the-openshift-console-is-installed)
    - [Start WebUI Instance](https://github.com/kubevirt/web-ui-operator#fire-web-ui-deployment)

 8) *Optional*: Deploy [containerized-data-importer](https://github.com/kubevirt/containerized-data-importer)
    ```
    oc project kube-system
    oc adm policy add-scc-to-user privileged -z cdi-sa
    VERSION=v1.4.1
    kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$VERSION/cdi-controller.yaml
    ```

## Usefull OpenStack commands 

| Desc | Command |
|------|---------|
| List resources     |    ```openstack hypervisor stats show ```     |
| List server/instances with instance id     | ```openstack server list  -c Name -f value \| xargs -n1 openstack server show -f table -c 'name' -c 'OS-EXT-SRV-ATTR:instance_name'```        |
|      |         |

License
-------

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


