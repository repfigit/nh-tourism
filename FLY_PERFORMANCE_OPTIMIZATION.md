# 🚀 Fly.io Performance Optimization Guide

## Current Issue: Slow Cold Starts

Your app is configured with `auto_stop_machines = 'stop'` and `min_machines_running = 0`, which means:
- ✅ **Cost savings**: Machines stop when idle (no charges)
- ❌ **Slow cold starts**: 5-15 seconds to boot Rails + connect to database

---

## ⚡ Quick Fixes (Choose Your Strategy)

### Option 1: Keep At Least One Machine Running (Recommended)
**Best for:** Apps with regular traffic, better user experience
**Cost impact:** ~$5-10/month for 1 shared-cpu machine

```bash
# Update fly.toml to keep 1 machine always running
flyctl config save -a nh-tourism
```

Update `fly.toml`:
```toml
[http_service]
  auto_stop_machines = 'stop'
  auto_start_machines = true
  min_machines_running = 1  # Changed from 0
```

Then deploy:
```bash
flyctl deploy
```

**Result:** First visitor gets instant response, subsequent requests <100ms

---

### Option 2: Use 'suspend' Instead of 'stop' (Fast Wake)
**Best for:** Occasional traffic, faster cold starts
**Cost impact:** Minimal (~$0.50-2/month for suspended machine)

Update `fly.toml`:
```toml
[http_service]
  auto_stop_machines = 'suspend'  # Changed from 'stop'
  auto_start_machines = true
  min_machines_running = 0
```

**Result:** Cold start reduced from 10s → 2-3s (no Rails boot needed)

---

### Option 3: Increase Memory (Faster Boot)
**Best for:** Heavy apps, faster Rails boot times
**Cost impact:** $5-10/month additional

Update `fly.toml`:
```toml
[[vm]]
  memory = '1024mb'  # Changed from 512mb (2x memory)
  cpu_kind = 'shared'
  cpus = 1
```

**Result:** Rails boots faster with more memory for caching

---

## 🔥 Advanced Optimizations

### 1. Enable Persistent Database Connections
Add to `config/database.yml`:
```yaml
production:
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  checkout_timeout: 5
  reaping_frequency: 10
  variables:
    statement_timeout: 5000
```

### 2. Preload Application Code
Update `config/puma.rb`:
```ruby
# Uncomment this line to preload app
preload_app!

# Add this for faster worker boot
before_fork do
  ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
end

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
```

### 3. Add Health Check Endpoint
Create `config/routes.rb` addition:
```ruby
get '/health', to: proc { [200, {}, ['OK']] }
```

Update `fly.toml`:
```toml
[http_service]
  # Add health check to prevent premature stops
  [[http_service.checks]]
    grace_period = "10s"
    interval = "30s"
    method = "GET"
    timeout = "5s"
    path = "/health"
```

### 4. Use Multi-Region Deployment
Deploy to multiple regions for global performance:
```bash
# Scale to 2 regions (primary + backup)
flyctl scale count 2 --region iad,ewr
```

---

## 📊 Performance Comparison

| Strategy | Cold Start | Cost/Month | User Experience |
|----------|-----------|------------|-----------------|
| **Current (min=0, stop)** | 10-15s | $0 | ❌ Slow first load |
| **min=1, stop** | <100ms | $5-10 | ✅ Always fast |
| **min=0, suspend** | 2-3s | $0.50-2 | 🟡 Better |
| **min=1, 1GB RAM** | <50ms | $15-20 | ✅✅ Very fast |

---

## 🎯 Recommended Setup for NH Tourism Site

Based on your use case (tourism website with regular visitors):

```toml
# fly.toml - Optimized Configuration

app = 'nh-tourism'
primary_region = 'ewr'

[build]

[deploy]
  release_command = './bin/rails db:prepare db:seed'

[env]
  RAILS_ENV = 'production'
  RAILS_SERVE_STATIC_FILES = 'true'
  RAILS_LOG_TO_STDOUT = 'true'

[http_service]
  internal_port = 3000
  force_https = true
  auto_stop_machines = 'suspend'  # Fast wake instead of full stop
  auto_start_machines = true
  min_machines_running = 1  # Keep 1 machine always running
  processes = ['app']

  [http_service.concurrency]
    type = 'connections'
    hard_limit = 1000
    soft_limit = 1000

  # Add health check
  [[http_service.checks]]
    grace_period = "10s"
    interval = "30s"
    method = "GET"
    timeout = "5s"
    path = "/"

[[vm]]
  memory = '1024mb'  # Increased for better performance
  cpu_kind = 'shared'
  cpus = 1

[[statics]]
  guest_path = '/rails/public'
  url_prefix = '/'
```

**This gives you:**
- ✅ Always-on for first visitor: <100ms
- ✅ Fast scaling for traffic spikes
- ✅ Health checks prevent premature stops
- ✅ ~$10-15/month total cost (machine + database)

---

## 🚀 Apply Recommended Config

```bash
# 1. Update fly.toml with recommended config above
# 2. Deploy changes
flyctl deploy

# 3. Verify it's working
flyctl status
flyctl logs
```

---

## 📈 Monitor Performance

```bash
# Check response times
flyctl logs --app nh-tourism | grep "Completed"

# Monitor machine status
flyctl status

# View metrics
flyctl dashboard
```

---

## 💰 Cost Breakdown (Recommended Setup)

- **Compute**: $10/month (1 machine @ 1GB RAM, always running)
- **Database**: $38/month (Managed Postgres Basic plan)
- **Storage**: $2.80/month (10GB database storage)
- **Total**: ~$51/month for production-ready, always-fast site

---

## 🎓 Next Steps

1. **Immediate**: Change `min_machines_running = 1` → Instant fix for $5/month
2. **Short-term**: Switch to `suspend` mode for faster wake
3. **Long-term**: Increase to 1GB RAM for best performance
4. **Advanced**: Add multiple regions for global users

Choose the option that balances your budget and performance needs!
