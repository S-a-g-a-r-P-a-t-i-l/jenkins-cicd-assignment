
#!/bin/bash

set -e

# EC2 Configuration
EC2_USER="ubuntu"
EC2_HOST="YOUR_EC2_PUBLIC_IP"
SSH_KEY="/path/to/your-key.pem"

# Application Configuration
JAR_FILE="target/*.jar"
REMOTE_DIR="/home/ubuntu/app"

echo "Starting deployment..."

# Create application directory on EC2
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=accept-new \
    "$EC2_USER@$EC2_HOST" "mkdir -p $REMOTE_DIR"

# Copy JAR file to EC2
scp -i "$SSH_KEY" -o StrictHostKeyChecking=accept-new \
    $JAR_FILE "$EC2_USER@$EC2_HOST:$REMOTE_DIR/app.jar"

echo "JAR file copied successfully."

# Restart application on EC2
ssh -i "$SSH_KEY" "$EC2_USER@$EC2_HOST" \
    "pkill -f 'java -jar $REMOTE_DIR/app.jar' || true"

ssh -i "$SSH_KEY" "$EC2_USER@$EC2_HOST" \
    "nohup java -jar $REMOTE_DIR/app.jar > $REMOTE_DIR/app.log 2>&1 < /dev/null &"

echo "Deployment completed successfully!"
