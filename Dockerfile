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

# --- STAGE 2: INSTALL APPS (ISOLATION MODE) ---

# HRMS - ADDED VERBOSE TO SEE THE ERROR
RUN bench get-app --verbose --branch version-15 hrms

# Payments
RUN bench get-app --branch version-15 payments

# --- TEMPORARILY DISABLED FOR DEBUGGING ---
# If HRMS works, we will uncomment these one by one.
# RUN bench get-app --branch main crm
# RUN bench get-app --branch main helpdesk
# RUN bench get-app --branch main builder
# RUN bench get-app --branch version-15 lms
# RUN bench get-app --branch version-15 insights
# RUN bench get-app --branch main lending
# RUN bench get-app --branch main gameplan

# --- STAGE 3: BUILD ASSETS ---
RUN echo "---- [DEBUG] BUILDING ASSETS... ----"
RUN bench build
