#!/bin/bash
# Wait for IAM to propagate
sleep 30

# Install packages
yum update -y
amazon-linux-extras install -y php8.0
yum install -y httpd php-mysqlnd jq aws-cli

# Start Apache
systemctl start httpd
systemctl enable httpd

# Get region
REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region)

# Retrieve secret with retries
max_retries=5
retry_count=0

while [ $retry_count -lt $max_retries ]; do
    SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id ${secret_arn} --region $REGION --query SecretString --output text 2>/dev/null)
    
    if [ $? -eq 0 ] && [ ! -z "$SECRET_JSON" ]; then
        break
    fi
    
    retry_count=$((retry_count + 1))
    sleep 10
done

# Parse credentials
DB_USERNAME=$(echo $SECRET_JSON | jq -r '.username')
DB_PASSWORD=$(echo $SECRET_JSON | jq -r '.password')
DB_NAME=$(echo $SECRET_JSON | jq -r '.dbname')

# Create PHP page
cat > /var/www/html/index.php <<EOF
<?php
\$db_endpoint = "${db_endpoint}";
\$db_name = "$DB_NAME";
\$db_username = "$DB_USERNAME";
\$db_password = "$DB_PASSWORD";

// Create connection
\$conn = new mysqli(\$db_endpoint, \$db_username, \$db_password, \$db_name);

// Check connection
if (\$conn->connect_error) {
    die("Connection failed: " . \$conn->connect_error);
}
echo "Connected successfully to MySQL database!<br>";

// Create table if not exists
\$sql = "CREATE TABLE IF NOT EXISTS visits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    visit_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)";
\$conn->query(\$sql);

// Insert visit record
\$sql = "INSERT INTO visits () VALUES ()";
\$conn->query(\$sql);

// Count visits
\$result = \$conn->query("SELECT COUNT(*) as total FROM visits");
\$row = \$result->fetch_assoc();
echo "Total visits: " . \$row["total"] . "<br>";

\$conn->close();
?>
<h1>Welcome to our Auto-Scaling Web Application!</h1>
<p>Server hostname: <?php echo gethostname(); ?></p>
<p>Current time: <?php echo date('Y-m-d H:i:s'); ?></p>
EOF

# Set permissions
chown apache:apache /var/www/html/index.php
