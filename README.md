# ERPNext Complete Suite

A production-ready Docker setup for ERPNext v15 with the complete Frappe application suite.

## 🚀 Included Apps

This setup includes **all official Frappe apps**:

| App | Description |
|-----|-------------|
| **ERPNext** | Core ERP - Accounting, Inventory, Manufacturing, HR, etc. |
| **HRMS** | Human Resource Management System |
| **CRM** | Customer Relationship Management |
| **Helpdesk** | Customer Support & Ticketing |
| **Builder** | No-code website builder |
| **LMS** | Learning Management System |
| **Insights** | Business Intelligence & Analytics |
| **Lending** | Loan Management |
| **Gameplan** | Project & Team Collaboration |
| **Payments** | Payment Gateway Integrations |
| **Print Designer** | Custom Print Format Designer |

## 📋 Prerequisites

- **VPS**: 4GB+ RAM recommended (8GB for full suite)
- **Docker** & **Docker Compose v2**
- **Domain**: Point your domain to your server IP

## 🛠️ Deployment Options

### Option 1: Using Coolify (Recommended)

1. **Create Project** in Coolify Dashboard
2. **Add New Resource** → **Docker Compose**
3. **Paste** the contents of `docker-compose.yml`
4. **Set Environment Variables**:
   - `SITE_NAME`: Your domain (e.g., `erp.jskwwc.com`)
   - `DB_ROOT_PASSWORD`: Secure database password
   - `ADMIN_PASSWORD`: Your admin login password
5. **Configure Frontend Service**:
   - Set domain to `https://your-domain.com`
6. **Deploy**

### Option 2: Direct Docker Compose

```bash
# Clone and navigate
cd /path/to/this/repo

# Copy and edit environment file
cp .env.example .env
nano .env  # Update passwords and domain

# Start all services
docker compose up -d

# Watch the site creation logs
docker compose logs -f create-site
```

## ⏱️ First-Time Setup

The `create-site` service automatically:
1. Waits for database and Redis to be ready
2. Creates a new Frappe site
3. Installs all apps one by one
4. Sets the site as default

**This takes 10-15 minutes** for all apps to install. Monitor progress:

```bash
docker compose logs -f create-site
```

## 🔐 Access

Once setup completes:

- **URL**: `https://your-domain.com`
- **Username**: `Administrator`
- **Password**: The `ADMIN_PASSWORD` you set

## 📁 Files Overview

```
.
├── apps.json           # List of all Frappe apps to include
├── docker-compose.yml  # Full stack configuration
├── .env.example        # Environment variables template
└── README.md           # This file
```

## 🔧 Customization

### Adding/Removing Apps

Edit `apps.json` to customize which apps are included:

```json
[
  {"url": "https://github.com/frappe/erpnext", "branch": "version-15"},
  {"url": "https://github.com/frappe/hrms", "branch": "version-15"}
  // Add or remove apps here
]
```

### Building Custom Image

If you modify `apps.json`, you'll need to build a custom image:

```bash
# Generate base64 encoded apps list
export APPS_JSON_BASE64=$(base64 -w 0 apps.json)

# Build (requires frappe_docker Containerfile)
docker build \
  --build-arg=FRAPPE_BRANCH=version-15 \
  --build-arg=APPS_JSON_BASE64=$APPS_JSON_BASE64 \
  --tag=custom-erpnext:v15 \
  --file=Containerfile .
```

Then update `.env`:
```
CUSTOM_IMAGE=custom-erpnext
CUSTOM_TAG=v15
PULL_POLICY=never
```

## 🔄 Backup & Restore

### Create Backup
```bash
docker compose exec backend bench --site erp.jskwwc.com backup --with-files
```

### List Backups
```bash
docker compose exec backend ls -la sites/erp.jskwwc.com/private/backups/
```

## 📊 Resource Requirements

| Configuration | RAM | CPU | Apps |
|---------------|-----|-----|------|
| Minimal | 4GB | 2 cores | ERPNext only |
| Standard | 8GB | 4 cores | ERPNext + HRMS + CRM |
| Full Suite | 16GB | 4+ cores | All apps |

## 🐛 Troubleshooting

### Site not loading
```bash
# Check all services are running
docker compose ps

# Check backend logs
docker compose logs backend
```

### App installation failed
```bash
# Manually install an app
docker compose exec backend bench --site erp.jskwwc.com install-app <app_name>
```

### Reset everything
```bash
docker compose down -v  # WARNING: Deletes all data!
docker compose up -d
```

## 📚 Documentation

- [ERPNext Docs](https://docs.erpnext.com/)
- [Frappe Framework](https://frappeframework.com/docs)
- [Frappe Docker](https://github.com/frappe/frappe_docker)

---

Made with ❤️ for JSKWWC
