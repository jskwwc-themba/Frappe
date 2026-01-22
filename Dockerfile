FROM frappe/erpnext:v15

# We install system dependencies so that we CAN install apps manually later
USER root
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    pkg-config \
    python3-dev \
    libmariadb-dev-compat \
    libmariadb-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

USER frappe
WORKDIR /home/frappe/frappe-bench

# --- NO APPS PRE-INSTALLED ---
# We will get the site running first.
# Then valid we can install apps manually.
