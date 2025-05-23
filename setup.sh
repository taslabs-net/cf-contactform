#!/bin/bash

# Cloudflare Worker Contact Form Setup Script
# This script helps automate the initial setup process

set -e

echo "🚀 Cloudflare Worker Contact Form Setup"
echo "========================================"

# Check if wrangler is installed
if ! command -v wrangler &> /dev/null; then
    echo "❌ Wrangler CLI not found. Please install it first:"
    echo "npm install -g wrangler"
    exit 1
fi

echo "✅ Wrangler CLI found"

# Check if user is logged in
if ! wrangler whoami &> /dev/null; then
    echo "🔐 Please log in to Cloudflare first:"
    echo "wrangler login"
    exit 1
fi

echo "✅ Cloudflare authentication verified"

echo ""
echo "📦 Creating KV Namespaces..."

# Create KV namespaces and capture IDs
echo "Creating cf-contactform-turnstile namespace..."
TURNSTILE_KV=$(wrangler kv:namespace create "cf-contactform-turnstile" --preview false | grep -o 'id = "[^"]*"' | cut -d'"' -f2)
TURNSTILE_KV_PREVIEW=$(wrangler kv:namespace create "cf-contactform-turnstile" --preview | grep -o 'id = "[^"]*"' | cut -d'"' -f2)

echo "Creating cf-contactform-discord namespace..."
DISCORD_KV=$(wrangler kv:namespace create "cf-contactform-discord" --preview false | grep -o 'id = "[^"]*"' | cut -d'"' -f2)
DISCORD_KV_PREVIEW=$(wrangler kv:namespace create "cf-contactform-discord" --preview | grep -o 'id = "[^"]*"' | cut -d'"' -f2)

echo ""
echo "📝 Updating wrangler.toml with KV namespace IDs..."

# Update wrangler.toml with the actual KV IDs
sed -i.bak "s/contactform_turnstile_kv_id/$TURNSTILE_KV/g" wrangler.toml
sed -i.bak "s/contactform_turnstile_kv_preview_id/$TURNSTILE_KV_PREVIEW/g" wrangler.toml
sed -i.bak "s/contactform_discord_urls_id/$DISCORD_KV/g" wrangler.toml
sed -i.bak "s/contactform_discord_urls_preview_id/$DISCORD_KV_PREVIEW/g" wrangler.toml

# Remove backup file
rm wrangler.toml.bak

echo "✅ wrangler.toml updated successfully"

echo ""
echo "🔑 Setting up Turnstile keys..."
echo "Please enter your Turnstile site key:"
read -r TURNSTILE_SITE_KEY
echo "Please enter your Turnstile secret key:"
read -r TURNSTILE_SECRET_KEY

wrangler kv:key put --binding=contactform_turnstile_kv "site-key-contactform" "$TURNSTILE_SITE_KEY"
wrangler kv:key put --binding=contactform_turnstile_kv "secret-key-contactform" "$TURNSTILE_SECRET_KEY"

echo "✅ Turnstile keys stored in KV"

echo ""
echo "📧 Setting up Mailgun secrets..."
echo "Setting mailgunApiKey secret..."
wrangler secret put mailgunApiKey

echo "Setting mailgunDomain secret..."
wrangler secret put mailgunDomain

echo "Setting cloudflareEmail secret..."
wrangler secret put cloudflareEmail

echo "Setting senderEmail secret..."
wrangler secret put senderEmail

echo ""
echo "💬 Discord setup (optional)..."
read -p "Do you want to set up Discord notifications? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Please enter your Discord webhook URL:"
    read -r DISCORD_WEBHOOK
    wrangler kv:key put --binding=contactform_discord_urls "cloudflare-contactform" "$DISCORD_WEBHOOK"
    echo "✅ Discord webhook stored"
else
    echo "⏭️ Skipping Discord setup"
fi

# Update wrangler.toml to use the full worker
sed -i.bak "s/main = \"worker-basic.js\"/main = \"worker.js\"/g" wrangler.toml
rm wrangler.toml.bak

echo ""
echo "🎉 Setup Complete!"
echo "==================="
echo ""
echo "✅ KV namespaces created and configured"
echo "✅ Secrets stored securely"
echo "✅ Worker switched to full contact form"
echo ""
echo "Next steps:"
echo "1. Deploy the full contact form: wrangler deploy"
echo "2. Test at your worker URL"
echo "3. Optional: Set up custom domain"
echo ""
echo "KV Namespace IDs created:"
echo "  contactform_turnstile_kv: $TURNSTILE_KV"
echo "  contactform_discord_urls: $DISCORD_KV"
echo ""
echo "🔗 Your worker will be available at:"
echo "https://cf-contactform.your-subdomain.workers.dev"