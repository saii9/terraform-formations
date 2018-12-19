Content-Type: multipart/mixed; boundary="==BOUNDARY=="
MIME-Version: 1.0

--==BOUNDARY==
Content-Type: text/cloud-config; charset="us-ascii"
output: { all: '| tee -a /var/log/cloud-init-output.log' }

--==BOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
set -e
set -x

mkdir -p /etc/ssl/nginx
cat > /etc/ssl/nginx/nginx-repo.crt <<SET
${nginx.repo-crt}
SET
cat > /etc/ssl/nginx/nginx-repo.key <<SET
${nginx.repo-key}
SET
curl https://cs.nginx.com/static/files/CA.crt > /etc/ssl/nginx/CA.crt
curl https://cs.nginx.com/static/files/nginx-plus-7.repo > /etc/yum.repos.d/nginx-plus-7.repo
yum install nginx-plus nginx-plus-module-geoip2 nginx-plus-module-headers-more
cat > /etc/nginx/conf.d/status.conf <<SET
# Provide status listener for datadog
server {
	listen 81;
	server_name _;

	access_log off;
	allow 127.0.0.1;
	deny all;

	location /nginx_status {
		status;
	}
}
SET

systemctl daemon-reload
setsebool -P httpd_can_network_relay 1
setsebool -P httpd_can_network_connect 1
setsebool -P httpd_run_stickshift 1
setsebool -P httpd_setrlimit 1
setsebool -P httpd_use_nfs 1
setsebool -P logrotate_use_nfs 1
setsebool -P use_nfs_home_dirs 1
systemctl restart nginx

--==BOUNDARY==--
