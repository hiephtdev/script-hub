#!/bin/bash

# Cập nhật hệ thống
sudo apt update
sudo apt upgrade -y

# Cài đặt Squid
sudo apt install squid -y

# Tạo file mật khẩu cho xác thực người dùng
sudo touch /etc/squid/passwd
sudo chmod o+r /etc/squid/passwd

# Cài đặt htpasswd để tạo tài khoản
sudo apt install apache2-utils -y

# Tạo tài khoản người dùng với tên hiepht và mật khẩu 12345678@Abc
sudo htpasswd -b /etc/squid/passwd hiepht 12345678@Abc

# Cấu hình Squid để yêu cầu xác thực
sudo bash -c "cat >> /etc/squid/squid.conf <<EOL
http_port 8888
# Xác thực người dùng
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic realm proxy
acl authenticated proxy_auth REQUIRED
http_access allow authenticated
EOL"

# Mở cổng 3128 trên firewall
sudo ufw allow 3128/tcp
sudo ufw reload

# Khởi động lại dịch vụ Squid
sudo systemctl restart squid

# Kiểm tra trạng thái của Squid
sudo systemctl status squid
