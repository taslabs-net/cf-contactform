# Cloudflare Worker Contact Form

A secure contact form built with Cloudflare Workers, featuring Turnstile CAPTCHA protection, email delivery via Mailgun, and Discord notifications.

## Features

- 🛡️ **Cloudflare Turnstile** - Bot protection
- 📧 **Mailgun Integration** - Reliable email delivery
- 💬 **Discord Notifications** - Real-time form submissions
- 🔒 **Cloudflare Secrets** - Secure credential storage
- 🗃️ **Cloudflare KV** - Configuration storage

## 🚀 One-Click Deploy to Cloudflare

[![Deploy to Cloudflare Workers](https://deploy.workers.cloudflare.com/button)](https://deploy.workers.cloudflare.com/?url=https://github.com/taslabs-net/cf-contactform)

**That's it!** The deploy button will:
1. ✅ Fork this repository to your GitHub account
2. ✅ Create KV namespaces automatically based on wrangler.toml
3. ✅ Deploy your contact form to Cloudflare Workers
4. ✅ Provide a setup page to configure secrets and KV data

After deployment, you'll need to configure a few settings in your Cloudflare dashboard:

⚠️ **IMPORTANT**: During deployment, you'll be asked to create 2 KV namespaces. Make sure to give them **different names**:
- First KV namespace: `cf-contactform-turnstile` (for CAPTCHA keys)
- Second KV namespace: `cf-contactform-discord` (for Discord webhooks)

### Post-Deployment Configuration

1. **Set your domain variable**: Go to Workers & Pages > your-worker > Settings > Variables and update `DOMAIN_NAME` to your actual domain
2. **Configure Turnstile keys**: Add your Turnstile site and secret keys to the `contactform_turnstile_kv` namespace
3. **Set email secrets**: Configure Mailgun API key, domain, and email addresses in the Secrets section
4. **Optional Discord**: Add Discord webhook URL to the `contactform_discord_urls` namespace

## 📋 Required Information

You'll need these credentials after deployment:

### Turnstile (Free)
1. Go to [Cloudflare Dashboard > Turnstile](https://dash.cloudflare.com/?to=/:account/turnstile)
2. Create a new site with your domain
3. Copy the **Site Key** and **Secret Key**

### Mailgun (Free tier available)
1. Sign up at [mailgun.com](https://mailgun.com)
2. Verify your domain
3. Get your **API Key** and **Domain** (e.g., `mg.yourdomain.com`)
4. Set your **recipient email** and **verified sender email**

### Discord (Optional)
1. Go to Discord Server Settings > Integrations > Webhooks
2. Create webhook and copy the URL

## Alternative: Clone and Deploy Manually

```bash
# Clone the repository
git clone https://github.com/taslabs-net/cf-contactform.git
cd cf-contactform

# Install Wrangler CLI (if not already installed)
npm install -g wrangler
wrangler login

# Run the automated setup script
chmod +x setup.sh
./setup.sh

# Or deploy directly (KV namespaces and secrets need manual setup)
wrangler deploy
```

The setup script will guide you through creating KV namespaces, setting up secrets, and configuring all required credentials.

## Configuration Reference

### Required Secrets
- `mailgunApiKey`: Your Mailgun API key
- `mailgunDomain`: Your Mailgun domain (e.g., `mg.yourdomain.com`)
- `cloudflareEmail`: Email address to receive form submissions
- `senderEmail`: Verified sender email address in Mailgun

### KV Store Data
- **cf-contactform-turnstile**: `site-key-contactform` and `secret-key-contactform`
- **cf-contactform-discord**: `cloudflare-contactform` (Discord webhook URL)

### Variables
- `DOMAIN_NAME`: Your website domain

## Support

- [Cloudflare Workers Docs](https://developers.cloudflare.com/workers/)
- [Wrangler CLI Docs](https://developers.cloudflare.com/workers/wrangler/)
- [Turnstile Docs](https://developers.cloudflare.com/turnstile/)

## License

MIT License - see LICENSE file for details