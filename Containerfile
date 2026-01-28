# syntax=docker/dockerfile:1
# Frappe Custom Image with All Apps
# Based on: https://github.com/frappe/frappe_docker/blob/main/images/custom/Containerfile

ARG FRAPPE_VERSION=v15
FROM frappe/erpnext:${FRAPPE_VERSION}

# Switch to root to install apps
USER root

# Install any additional system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    && rm -rf /var/lib/apt/lists/*

# Switch back to frappe user
USER frappe

# Set working directory
WORKDIR /home/frappe/frappe-bench

# Copy apps.json for reference (optional)
COPY apps.json /opt/frappe/apps.json

# Clone and install all apps from apps.json
# Each app is cloned and installed using bench get-app
ARG APPS_JSON_BASE64
RUN if [ -n "${APPS_JSON_BASE64}" ]; then \
    echo "${APPS_JSON_BASE64}" | base64 -d > /tmp/apps.json && \
    for app_url in $(cat /tmp/apps.json | python3 -c "import sys,json; apps=json.load(sys.stdin); print(' '.join([a['url']+'@'+a.get('branch','main') for a in apps]))"); do \
    url=$(echo $app_url | cut -d@ -f1); \
    branch=$(echo $app_url | cut -d@ -f2); \
    app_name=$(basename $url .git); \
    echo "=== Getting $app_name from $url (branch: $branch) ==="; \
    if [ "$app_name" != "erpnext" ] && [ "$app_name" != "frappe" ]; then \
    bench get-app --branch $branch --skip-assets $url || echo "Failed to get $app_name, continuing..."; \
    fi; \
    done; \
    rm /tmp/apps.json; \
    fi

# Build assets
# Create a dummy common_site_config.json because some apps (LMS, Helpdesk) 
# expect socketio_port to be defined during asset compilation.
RUN echo '{"socketio_port": 9000}' > sites/common_site_config.json
RUN bench build --production

# Clean up
RUN rm -rf /home/frappe/.cache
