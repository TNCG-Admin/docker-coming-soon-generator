#!/usr/bin/env bash

# Clone the repository
echo "=== Cloning repository... ==="
git clone https://github.com/BlackrockDigital/startbootstrap-coming-soon /tmp/bootstrap4
cd /tmp/bootstrap4 || { echo "=== ERROR: Failed to navigate to /tmp/bootstrap4 ==="; exit 1; }
git reset --hard 0b23abbcf2a4cb53538f6bbe818307e0af27218a

# Ensure the destination directory exists
echo "=== Preparing destination directory... ==="
mkdir -p /usr/share/nginx/html/templates/bootstrap4
rm -rf /usr/share/nginx/html/templates/bootstrap4/*

# Move new content to the destination directory
echo "=== Moving content to /usr/share/nginx/html/templates/bootstrap4... ==="
mv /tmp/bootstrap4/* /usr/share/nginx/html/templates/bootstrap4

# Clean up temporary directory
echo "=== Cleaning up temporary directory... ==="
rm -rf /tmp/bootstrap4

# Remove the script file if it exists
if [ -f "/usr/share/nginx/html/templates/bootstrap4/checkout.sh" ]; then
    echo "=== Removing checkout.sh... ==="
    rm /usr/share/nginx/html/templates/bootstrap4/checkout.sh
fi

# Setup TWIG
echo "=== Setting up TWIG... ==="
wget https://github.com/okdana/twigc/releases/download/v0.2.0/twigc.phar -O /tmp/twig.phar \
    && chmod +x /tmp/twig.phar \
    && mv /tmp/twig.phar /usr/local/bin/twig

cd /usr/share/nginx/html || { echo "=== ERROR: Failed to navigate to /usr/share/nginx/html ==="; exit 1; }

# Ensure scss directory and handle existing files
echo "=== Preparing SCSS directory... ==="
rm -rf ./scss
mv -f templates/${TEMPLATE}/* ./ || { echo "=== ERROR: Failed to move SCSS files. ==="; exit 1; }

# Handle missing nginx.conf
echo "=== Checking for nginx.conf... ==="
if [ -f "./nginx.conf" ]; then
    echo "=== Moving nginx.conf to /etc/nginx/conf.d/default.conf... ==="
    mv ./nginx.conf /etc/nginx/conf.d/default.conf
else
    echo "=== WARNING: nginx.conf not found. Skipping... ==="
fi

rm -R templates

# Ensure config directory exists
echo "=== Preparing config directory... ==="
mkdir -p config

# Create config.json if it doesn't exist
if [ ! -f config/config.json ]; then
    echo "=== Generating config/config.json from environment variables... ==="
    variables=(TEMPLATE TITLE SUBLINE FACEBOOK_URL TWITTER_URL GITHUB_URL BASE_DIR)
    config="{"
    for var in ${variables[@]}; do
        content=$(echo ${!var} | sed 's/"/\\"/g') # Escape quotes for JSON validity
        config+="\"$var\":\"$content\","
    done
    config+="\"config\":true}" # Provide valid JSON
    echo "=== Config parameters: $config ==="
    echo $config > config/config.json
else
    echo "=== Existing config/config.json found. Skipping creation... ==="
fi

# Compile index.html file
echo "=== Compiling index.html file... ==="
twig "index.html.twig" -j config/config.json > index.html || {
    echo "=== ERROR: Failed to compile index.html. ==="
    exit 1
}

# Clean up
echo "=== Cleaning up config and Git directory... ==="
rm -rf config
rm -rf .git

# Start Nginx if not already running
echo "=== Checking if Nginx is running... ==="
if pgrep -x "nginx" > /dev/null; then
    echo "=== Nginx is already running. Skipping start. ==="
else
    echo "=== Starting Nginx... ==="
    nginx -g "daemon off;" || {
        echo "=== ERROR: Failed to start Nginx. Check logs for details. ==="
        exit 1
    }
fi

echo "=== Script completed successfully. ==="
exit 0
