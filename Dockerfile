FROM frappe/erpnext:v15

# --- STAGE 1: SYSTEM SETUP ---
USER root

# 1. Install ALL known dependencies for Frappe Apps (HRMS, customized apps)
# This includes image processinglibs, database connectors, and compilers.
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    pkg-config \
    python3-dev \
    libmariadb-dev-compat \
    libmariadb-dev \
    libssl-dev \
    libffi-dev \
    liblcms2-dev \
    libldap2-dev \
    libtiff5-dev \
    libwebp-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libjpeg62-turbo-dev \
    curl \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# 2. Configure Git to handle large repositories (HRMS is big)
RUN git config --global http.postBuffer 1048576000
RUN git config --global https.postBuffer 1048576000
RUN git config --global core.compression 0

USER frappe
WORKDIR /home/frappe/frappe-bench

# 3. Upgrade pip to avoid wheel build failures
RUN pip install --upgrade pip setuptools wheel

RUN echo "---- [DEBUG] ENVIRONMENT READY. FETCHING APPS... ----"

# Fix permissions just in case
USER root
RUN chown -R frappe:frappe /home/frappe/frappe-bench
USER frappe

# --- STAGE 2: INSTALL APPS (AUTO-DETECT BRANCH) ---

# HRMS
RUN bench get-app hrms

# Payments
RUN bench get-app payments

# CRM (Sales)
RUN bench get-app crm

# Helpdesk
RUN bench get-app helpdesk

# Builder
RUN bench get-app builder

# LMS
RUN bench get-app lms

# Insights
RUN bench get-app insights

# Lending
RUN bench get-app lending

# Gameplan
RUN bench get-app gameplan

# --- STAGE 3: BUILD ASSETS ---
RUN echo "---- [DEBUG] BUILDING ASSETS... ----"
RUN bench build
