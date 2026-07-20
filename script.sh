#!/bin/bash
set -euxo pipefail

# Update package index
apt-get update -y

# Upgrade installed packages
apt-get upgrade -y

# Install Apache2
apt-get install -y apache2

# Enable and start Apache
systemctl enable apache2
systemctl restart apache2

# Get VM Metadata
HOSTNAME=$(hostname)
PRIVATE_IP=$(hostname -I | awk '{print $1}')
OS_NAME=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')
KERNEL=$(uname -r)
DATE=$(date)
ZONE=$(curl -H "Metadata-Flavor: Google" \
http://metadata.google.internal/computeMetadata/v1/instance/zone | awk -F/ '{print $NF}')

# Create Custom Web Page
cat <<EOF >/var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Apache2 Web Server</title>

<style>
body{
    margin:0;
    font-family:Arial,Helvetica,sans-serif;
    background:linear-gradient(135deg,#0f2027,#203a43,#2c5364);
    color:white;
}

.container{
    width:900px;
    margin:50px auto;
    background:white;
    color:#333;
    border-radius:15px;
    padding:40px;
    box-shadow:0 10px 30px rgba(0,0,0,.4);
}

h1{
    color:#0b5394;
    text-align:center;
}

.success{
    text-align:center;
    font-size:22px;
    color:green;
    font-weight:bold;
}

table{
    width:100%;
    border-collapse:collapse;
    margin-top:25px;
}

th{
    background:#0b5394;
    color:white;
    padding:12px;
}

td{
    padding:12px;
    border:1px solid #ddd;
}

.footer{
    margin-top:30px;
    text-align:center;
    color:#666;
}
</style>

</head>

<body>

<div class="container">

<h1>🚀 Google Cloud Platform</h1>

<h2 align="center">
Apache2 Web Server Successfully Installed
</h2>

<p class="success">
✅ Startup Script Executed Successfully
</p>

<table>

<tr>
<th>Property</th>
<th>Value</th>
</tr>

<tr>
<td>Project</td>
<td>gcp-dev-july-2026</td>
</tr>

<tr>
<td>VPC Network</td>
<td>vpc-demo</td>
</tr>

<tr>
<td>Operating System</td>
<td>$OS_NAME</td>
</tr>

<tr>
<td>Hostname</td>
<td>$HOSTNAME</td>
</tr>

<tr>
<td>Private IP</td>
<td>$PRIVATE_IP</td>
</tr>

<tr>
<td>Zone</td>
<td>$ZONE</td>
</tr>

<tr>
<td>Kernel Version</td>
<td>$KERNEL</td>
</tr>

<tr>
<td>Apache Status</td>
<td>Running</td>
</tr>

<tr>
<td>Deployment Time</td>
<td>$DATE</td>
</tr>

</table>

<div class="footer">

<h3>☁️ Google Cloud Compute Engine</h3>

<p>
This VM was automatically configured using a Startup Script.
</p>

<p>
Ubuntu 26.04 LTS Minimal | Apache2 | Compute Engine | VPC Demo
</p>

</div>

</div>

</body>
</html>
EOF

# Restart Apache
systemctl restart apache2