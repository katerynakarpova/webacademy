#!/bin/bash
yum -y update
sudo yum install httpd -y 
sudo systemctl start httpd
sudo systemctl enable httpd
sudo chmod -R 777 /var/www

myip=`curl http://169.254.169.254/latest/meta-deta/local-ipv4`

cat <<-EOF > /var/www/html/index.html
<html>
<h2>Build by Power of Terraform <font color="red"> v.1.0.7</h2><br>
Owner ${f_name} ${l_name} <br>
%{ for x in names ~}
Hello to ${x} from ${f_name}<br>
%{ endfor ~}

</html>

EOF