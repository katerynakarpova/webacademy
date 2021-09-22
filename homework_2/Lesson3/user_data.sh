#!/bin/bash
yum -y update
sudo yum install httpd -y 
sudo systemctl start httpd
sudo systemctl enable httpd
sudo chmod -R 777 /var/www
echo "<h2>Webserver</h2><br>Build by Terrfaorm!Using External Script" > /var/www/html/index.html
echo "<br><font color="blue">Hello World!" > /var/www/html/index.html