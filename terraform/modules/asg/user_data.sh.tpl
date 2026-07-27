#!/bin/bash
set -euo pipefail

# Basic web server bootstrap for ${project_name}
dnf update -y
dnf install -y httpd amazon-cloudwatch-agent

systemctl enable httpd
systemctl start httpd

cat <<'EOF' > /var/www/html/health
OK
EOF

cat <<HTML > /var/www/html/index.html
<html>
  <head><title>${project_name}</title></head>
  <body>
    <h1>${project_name}</h1>
    <p>Served by $(hostname -f)</p>
  </body>
</html>
HTML

# Start the CloudWatch Agent with the default config (customize as needed)
systemctl enable amazon-cloudwatch-agent || true
