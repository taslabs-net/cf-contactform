# Cloudflare Worker Contact Form

A secure contact form built with Cloudflare Workers, featuring Turnstile CAPTCHA protection, email delivery via Mailgun, and Discord notifications.

## Features

- 🛡️ **Cloudflare Turnstile** - Bot protection
- 📧 **Mailgun Integration** - Reliable email delivery
- 💬 **Discord Notifications** - Real-time form submissions
- 🔒 **Cloudflare Secrets** - Secure credential storage
- 🗃️ **Cloudflare KV** - Configuration storage

## Quick Deploy to Cloudflare

### Prerequisites

1. **Cloudflare Account** with Workers plan
2. **Mailgun Account** for email delivery
3. **Turnstile Site Keys** from Cloudflare dashboard
4. **Discord Webhook URL** (optional)

### Step 1: Install Wrangler CLI

```bash
npm install -g wrangler
wrangler login
```

### Step 2: Clone and Setup

```bash
git clone https://github.com/taslabs-net/cfcontactform1.git
cd cfcontactform1
```

### Step 3: Create KV Namespaces

```bash
# Create KV namespaces
wrangler kv:namespace create "turnstile_kv"
wrangler kv:namespace create "Discord_Urls"

# Create preview namespaces
wrangler kv:namespace create "turnstile_kv" --preview
wrangler kv:namespace create "Discord_Urls" --preview
```

**Important:** Copy the namespace IDs from the output and update `wrangler.toml`:

```toml
[[kv_namespaces]]
binding = "turnstile_kv"
id = "your-turnstile-kv-id-here"
preview_id = "your-turnstile-preview-id-here"

[[kv_namespaces]]
binding = "Discord_Urls"
id = "your-discord-kv-id-here"
preview_id = "your-discord-preview-id-here"
```

### Step 4: Setup Turnstile

1. Go to [Cloudflare Dashboard > Turnstile](https://dash.cloudflare.com/?to=/:account/turnstile)
2. Create a new site
3. Add your domain (or use localhost for testing)
4. Copy the Site Key and Secret Key

```bash
# Store Turnstile keys in KV
wrangler kv:key put --binding=turnstile_kv "site-key-contactform" "YOUR_TURNSTILE_SITE_KEY"
wrangler kv:key put --binding=turnstile_kv "secret-key-contactform" "YOUR_TURNSTILE_SECRET_KEY"
```

### Step 5: Setup Secrets

```bash
# Mailgun configuration
wrangler secret put mailgunApiKey
# Enter your Mailgun API key when prompted

wrangler secret put mailgunDomain
# Enter your Mailgun domain (e.g., mg.yourdomain.com)

wrangler secret put cloudflareEmail
# Enter the email address to receive form submissions

wrangler secret put senderEmail
# Enter the sender email address (must be verified in Mailgun)
```

### Step 6: Setup Discord (Optional)

```bash
# Store Discord webhook URL
wrangler kv:key put --binding=Discord_Urls "cloudflare-contactform" "YOUR_DISCORD_WEBHOOK_URL"
```

### Step 7: Deploy

```bash
wrangler deploy
```

## Configuration Details

### Required Secrets

| Secret | Description | Example |
|--------|-------------|---------|
| `mailgunApiKey` | Your Mailgun API key | `key-1234567890abcdef` |
| `mailgunDomain` | Your Mailgun domain | `mg.yourdomain.com` |
| `cloudflareEmail` | Recipient email address | `contact@yourdomain.com` |
| `senderEmail` | Verified sender email | `noreply@yourdomain.com` |

### KV Store Data

#### turnstile_kv namespace:
- `site-key-contactform`: Your Turnstile site key
- `secret-key-contactform`: Your Turnstile secret key

#### Discord_Urls namespace:
- `cloudflare-contactform`: Discord webhook URL (optional)

## Getting Required Credentials

### Mailgun Setup
1. Create account at [mailgun.com](https://mailgun.com)
2. Add and verify your domain
3. Get API key from API Keys section
4. Note your domain (e.g., `mg.yourdomain.com`)

### Turnstile Setup
1. Go to Cloudflare Dashboard > Turnstile
2. Create new site with your domain
3. Copy Site Key and Secret Key
4. For testing, you can use `localhost` as domain

### Discord Webhook (Optional)
1. Go to Discord Server Settings > Integrations > Webhooks
2. Create New Webhook
3. Copy Webhook URL

## Testing

Test your deployment:

```bash
# Test the worker locally
wrangler dev

# Test in production
curl https://your-worker.your-subdomain.workers.dev/quote
```

## Custom Domain (Optional)

1. Add custom domain in Cloudflare Workers dashboard
2. Update Turnstile site settings with new domain
3. Update any hardcoded references to worker domain

## Troubleshooting

### Common Issues

1. **KV namespace not found**: Ensure IDs in `wrangler.toml` match created namespaces
2. **Turnstile failing**: Check site key in KV matches Turnstile dashboard
3. **Email not sending**: Verify Mailgun domain and sender email
4. **Secrets not found**: Use `wrangler secret list` to verify secrets are set

### Debug Commands

```bash
# List KV namespaces
wrangler kv:namespace list

# List secrets
wrangler secret list

# View KV contents
wrangler kv:key list --binding=turnstile_kv

# View logs
wrangler tail
```

## Development

```bash
# Install dependencies (if using package.json)
npm install

# Run locally
wrangler dev

# Deploy to preview
wrangler deploy --env preview
```

## Support

- [Cloudflare Workers Docs](https://developers.cloudflare.com/workers/)
- [Wrangler CLI Docs](https://developers.cloudflare.com/workers/wrangler/)
- [Turnstile Docs](https://developers.cloudflare.com/turnstile/)

## License

MIT License - see LICENSE file for details