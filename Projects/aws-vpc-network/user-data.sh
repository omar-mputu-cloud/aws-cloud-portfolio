#!/bin/bash
dnf install -y httpd
systemctl enable httpd
systemctl start httpd
echo "<h1>My AWS Cloud Portfolio</h1><p>Day 3 - EC2 Web Server running in my custom VPC.</p>" > /var/www/html/index.html
