
#!/bin/bash

set -e

# These values will come from Jenkins credentials/environment
EC2_USER="${EC2_USER:-ubuntu}"
: "${EC2_HOST:?EC2_HOST is not configured}"
: "${SSH_KEY:?SSH_KEY is not configured}"

REMOTE_DIR="/home/ubuntu/app"

# Find the generated JAR
JAR_FILE=$(find target -maxdepth 1 -type f -name "*.jar" | head -n 1)

if [ -z "$JAR_FILE" ]; then
    echo "Error: JAR file not found!"
    exit 1
fi

echo "Starting deployment..."

# Create application directory
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=accept-new \
    "$EC2_USER@$EC2_HOST" "mkdir -p $REMOTE_DIR"

# Copy JAR to EC2
scp -i "$SSH_KEY" -o StrictHostKeyChecking=accept-new \
    "$JAR_FILE" "$EC2_USER@$EC2_HOST:$REMOTE_DIR/app.jar"

echo "JAR copied successfully."

# Restart application
ssh -i "$SSH_KEY" "$EC2_USER@$EC2_HOST" \
    "pkill -f '[j]ava -jar /home/ubuntu/app/app.jar' || true; nohup java -jar /home/ubuntu/app/app.jar > /home/ubuntu/app/app.log 2>&1 < /dev/null &"

echo "Deployment completed!"
