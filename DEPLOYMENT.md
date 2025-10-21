# Fly.io Deployment Guide for NH Tourism

This guide will help you deploy the New Hampshire Tourism website to Fly.io.

## Prerequisites

- A Fly.io account (sign up at https://fly.io)
- Git installed on your local machine
- The flyctl CLI tool

## Step 1: Install Flyctl CLI

### macOS/Linux
```bash
curl -L https://fly.io/install.sh | sh
```

### Windows (PowerShell)
```powershell
iwr https://fly.io/install.ps1 -useb | iex
```

## Step 2: Authenticate with Fly.io

```bash
flyctl auth login
```

This will open your browser for authentication.

## Step 3: Clone the Repository

```bash
git clone https://github.com/repfigit/nh-tourism.git
cd nh-tourism
```

## Step 4: Create the Fly.io App

```bash
flyctl launch --no-deploy
```

When prompted:
- Choose app name: `nh-tourism` (or your preferred name)
- Choose region: `bos` (Boston) - closest to New Hampshire
- Don't add any services yet (we'll add PostgreSQL next)

## Step 5: Create PostgreSQL Database

```bash
# Create a PostgreSQL cluster
flyctl postgres create --name nh-tourism-db --region bos --initial-cluster-size 1

# Attach it to your app
flyctl postgres attach --app nh-tourism nh-tourism-db
```

This will automatically set the `DATABASE_URL` secret.

## Step 6: Set Required Secrets

Generate and set the required environment variables:

```bash
# Generate a secret key
SECRET_KEY=$(openssl rand -hex 64)

# Set all required secrets
flyctl secrets set \
  SECRET_KEY_BASE=$SECRET_KEY \
  PUBLIC_HOST=nh-tourism.fly.dev \
  RAILS_ENV=production
```

## Step 7: Deploy the Application

```bash
flyctl deploy
```

This will:
1. Build the Docker image
2. Push it to Fly.io's registry
3. Deploy the container
4. Run `rails db:prepare` (migrations)
5. Run `rails db:seed` (populate with NH tourism data)
6. Start the application

## Step 8: Open Your Application

```bash
flyctl open
```

Your site will be available at: **https://nh-tourism.fly.dev**

## Admin Access

- **URL**: https://nh-tourism.fly.dev/admin/login
- **Username**: `admin`
- **Password**: `Cure8-Penpal4-Sapling0-Deputy1-Glory0`

## Useful Commands

### View logs
```bash
flyctl logs
```

### Check app status
```bash
flyctl status
```

### SSH into the container
```bash
flyctl ssh console
```

### Open Rails console
```bash
flyctl ssh console -C "rails console"
```

### Scale the app
```bash
# Scale to 2 instances
flyctl scale count 2

# Scale memory
flyctl scale memory 1024
```

### Update secrets
```bash
flyctl secrets set KEY=value
```

### View current secrets
```bash
flyctl secrets list
```

## Troubleshooting

### If deployment fails:

1. Check logs:
   ```bash
   flyctl logs
   ```

2. Verify secrets are set:
   ```bash
   flyctl secrets list
   ```

3. Verify database connection:
   ```bash
   flyctl ssh console -C "rails runner 'puts ActiveRecord::Base.connection.active?'"
   ```

### Reset the database:

```bash
flyctl ssh console -C "rails db:reset"
```

### Restart the app:

```bash
flyctl apps restart nh-tourism
```

## Custom Domain (Optional)

To use a custom domain like `visitnh.com`:

1. Add the certificate:
   ```bash
   flyctl certs add visitnh.com
   ```

2. Follow the DNS instructions provided

3. Update the PUBLIC_HOST secret:
   ```bash
   flyctl secrets set PUBLIC_HOST=visitnh.com
   ```

## Cost Estimate

With the default configuration:
- **Free tier includes**: 3 shared-cpu-1x VMs with 256MB RAM
- **PostgreSQL**: ~$2-5/month for single node
- **Bandwidth**: First 100GB free

The app is configured with auto-stop/auto-start, so it will scale to zero when not in use, minimizing costs.

## Support

- Fly.io Docs: https://fly.io/docs
- Community Forum: https://community.fly.io
- Status: https://status.fly.io

---

## Configuration Files

All configuration is ready in the repository:

- **fly.toml**: Fly.io app configuration
- **Dockerfile**: Container build instructions
- **config/database.yml**: Database configuration
- **db/seeds.rb**: Initial tourism data

The deployment is fully automated - just follow the steps above!
