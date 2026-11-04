
#!/bin/bash
set -euo pipefail

EC2_USER="${EC2_USER:-ubuntu}"
: "${EC2_HOST:?EC2_HOST is not configured}"
: "${SSH_KEY:?SSH_KEY is not configured}"

REMOTE_DIR="/home/ubuntu/app"

JAR_FILE=$(find target -maxdepth 1 -type f -name "*.jar" | head -n 1)

if [ -z "$JAR_FILE" ]; then
    echo "Error: JAR file not found!"
    exit 1
fi

echo "Creating application directory on EC2..."

ssh -i "$SSH_KEY" -o StrictHostKeyChecking=accept-new \
    "$EC2_USER@$EC2_HOST" "mkdir -p $REMOTE_DIR"

echo "Copying JAR to EC2..."

scp -i "$SSH_KEY" -o StrictHostKeyChecking=accept-new \
    "$JAR_FILE" "$EC2_USER@$EC2_HOST:$REMOTE_DIR/app.jar"

echo "Executing application on EC2..."

ssh -i "$SSH_KEY" "$EC2_USER@$EC2_HOST" \
    "java -jar $REMOTE_DIR/app.jar"

echo "Deployment completed successfully!"
