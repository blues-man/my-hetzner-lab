mount /dev/sr0 /media/
mkdir -p /var/www/html
tar -C /var/www/html -xf /media/ocp-3.11-data.tar repos/
yum install -y httpd docker-distribution
tar -C /var/lib/registry/ --strip-components=1 -xf /media/ocp-3.11-data.tar registry/docker
chcon -R -t httpd_sys_content_t /var/www/html/repos/
systemctl enable docker-distribution.service httpd.service
systemctl start docker-distribution.service httpd.service
systemctl status docker-distribution.service httpd.service
