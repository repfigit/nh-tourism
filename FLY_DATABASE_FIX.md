# Fix Fly.io Database Connection Issue

## Problem
The database `nh-tourism-db` is stuck in "pending" state and `DATABASE_URL` is not being set when attaching the database to the app.

## Solution: Recreate Database with Managed Postgres

Follow these steps **in order** on your local machine:

### Step 1: Destroy the Stuck Database
```bash
flyctl apps destroy nh-tourism-db --yes
```

### Step 2: Create New Managed Postgres Database
```bash
flyctl postgres create --name nh-tourism-db --region ewr --initial-cluster-size 1
```

**Important Notes:**
- When prompted, accept the defaults
- Wait for the database to fully provision (should take 2-3 minutes)
- Look for "Postgres cluster nh-tourism-db created" message

### Step 3: Verify Database is Running
```bash
flyctl postgres list
```

**Expected output:** Database should show STATUS as "running" (not "pending")

### Step 4: Attach Database to App
```bash
flyctl postgres attach nh-tourism-db --app nh-tourism
```

**Expected output:** Should see message like:
```
Postgres cluster nh-tourism-db is now attached to nh-tourism
The following secret was added to nh-tourism:
  DATABASE_URL=postgres://...
```

### Step 5: Verify DATABASE_URL is Set
```bash
flyctl secrets list --app nh-tourism
```

**Expected output:** You should see `DATABASE_URL` in the list

### Step 6: Deploy the Application
```bash
flyctl deploy
```

This will:
- Build the Docker container
- Run the release command (`rails db:prepare db:seed`)
- Start the application

### Step 7: Verify Deployment
```bash
# Check app status
flyctl status --app nh-tourism

# View logs
flyctl logs --app nh-tourism

# Test the site
curl https://nh-tourism.fly.dev
```

## Troubleshooting

### If Database Still Shows "pending" After Step 2
Wait 3-5 minutes and check again:
```bash
flyctl postgres list
```

If still pending after 10 minutes, try:
```bash
flyctl apps restart nh-tourism-db
```

### If DATABASE_URL is Not Set After Step 4
Manually set it:
```bash
# Get the connection string
flyctl postgres db list --app nh-tourism-db

# Set it manually (replace with actual connection string from above)
flyctl secrets set DATABASE_URL="postgres://postgres:password@hostname:5432/nh_tourism" --app nh-tourism
```

### If Release Command Fails During Deploy
Check logs:
```bash
flyctl logs --app nh-tourism
```

Common issues:
- **"PG::ConnectionBad"**: DATABASE_URL is incorrect or database is not running
- **"relation does not exist"**: Migrations need to run (should auto-run via db:prepare)

## Alternative: Use Fly.io Managed Postgres (MPG)

If the above doesn't work, try the newer Managed Postgres:

```bash
# Destroy old database
flyctl apps destroy nh-tourism-db --yes

# Create with mpg (Managed Postgres - newer, more stable)
flyctl mpg create --name nh-tourism-db --region ewr --initial-cluster-size 1

# Attach (same as before)
flyctl postgres attach nh-tourism-db --app nh-tourism

# Verify
flyctl secrets list --app nh-tourism

# Deploy
flyctl deploy
```

## Expected Final State

After successful deployment:
- Database: `nh-tourism-db` (STATUS: running)
- App: `nh-tourism` (STATUS: running)
- Secrets: DATABASE_URL, SECRET_KEY_BASE, AWS credentials, etc.
- URL: https://nh-tourism.fly.dev
- Admin login: admin / Cure8-Penpal4-Sapling0-Deputy1-Glory0

## Need Help?

If you encounter errors, provide:
1. Output from `flyctl postgres list`
2. Output from `flyctl secrets list --app nh-tourism`
3. Output from `flyctl logs --app nh-tourism`
