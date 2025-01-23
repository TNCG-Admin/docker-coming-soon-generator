FROM nginx:1.27.3

# Install dependencies
RUN apt-get update && apt-get install -y \
  wget \
  git \
  php8.2-cli \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV BASE_DIR /usr/share/nginx/html
WORKDIR $BASE_DIR

ARG defaultTemplate="bootstrap4"
ENV TEMPLATE=$defaultTemplate

# Remove default Nginx content
RUN rm -rf /usr/share/nginx/html/*

# Add "Coming Soon" page content
ADD ./ $BASE_DIR

# Add run.sh script and set executable permissions
ADD run.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run.sh

# Expose ports
EXPOSE 80
EXPOSE 443

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/run.sh"]
