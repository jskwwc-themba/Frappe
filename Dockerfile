FROM frappe/erpnext:v15
# We need root to install build dependencies (git, gcc, etc)
USER root
RUN apt-get update && apt-get install -y git build-essential
# Switch back to the bench user
USER frappe
WORKDIR /home/frappe/frappe-bench
# Install HRMS App
RUN bench get-app --branch version-15 hrms
# Install Payments App (Required for some)
RUN bench get-app --branch version-15 payments
# --- The Full Suite ---
# HRMS (People Operations)
RUN bench get-app --branch version-15 hrms
# LMS (Learning)
RUN bench get-app --branch version-15 lms || bench get-app lms
# Insights (Data Analysis)
RUN bench get-app --branch version-15 insights || bench get-app insights
# CRM (Sales - specialized app)
RUN bench get-app --branch main crm
# Helpdesk (Customer Support)
RUN bench get-app --branch main helpdesk
# Builder (Website Builder)
RUN bench get-app --branch main builder
# Lending (Loan Management)
RUN bench get-app --branch main lending
# Gameplan (Team Forum)
RUN bench get-app --branch main gameplan
# (Note: 'Books' is Frappe Books (Desktop App). ERPNext has built-in Accounting)
# Re-build assets
RUN bench build