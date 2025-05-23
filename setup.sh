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
echo "Creating turnstile_kv namespace..."
TURNSTILE_KV=$(wrangler kv:namespace create "turnstile_kv" --preview false | grep -o 'id = "[^"]*"' | cut -d'"' -f2)
TURNSTILE_KV_PREVIEW=$(wrangler kv:namespace create "turnstile_kv" --preview | grep -o 'id = "[^"]*"' | cut -d'"' -f2)

echo "Creating Discord_Urls namespace..."
DISCORD_KV=$(wrangler kv:namespace create "Discord_Urls" --preview false | grep -o 'id = "[^"]*"' | cut -d'"' -f2)
DISCORD_KV_PREVIEW=$(wrangler kv:namespace create "Discord_Urls" --preview | grep -o 'id = "[^"]*"' | cut -d'"' -f2)

echo ""
echo "📝 Updating wrangler.toml with KV namespace IDs..."

# Update wrangler.toml with the actual KV IDs
sed -i.bak "s/YOUR_TURNSTILE_KV_ID/$TURNSTILE_KV/g" wrangler.toml
sed -i.bak "s/YOUR_TURNSTILE_KV_PREVIEW_ID/$TURNSTILE_KV_PREVIEW/g" wrangler.toml
sed -i.bak "s/YOUR_DISCORD_KV_ID/$DISCORD_KV/g" wrangler.toml
sed -i.bak "s/YOUR_DISCORD_KV_PREVIEW_ID/$DISCORD_KV_PREVIEW/g" wrangler.toml

# Remove backup file
rm wrangler.toml.bak

echo "✅ wrangler.toml updated successfully"

echo ""
echo "🔑 Setting up Turnstile keys..."
echo "Please enter your Turnstile site key:"
read -r TURNSTILE_SITE_KEY
echo "Please enter your Turnstile secret key:"
read -r TURNSTILE_SECRET_KEY

wrangler kv:key put --binding=turnstile_kv "site-key-contactform" "$TURNSTILE_SITE_KEY"
wrangler kv:key put --binding=turnstile_kv "secret-key-contactform" "$TURNSTILE_SECRET_KEY"

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
    wrangler kv:key put --binding=Discord_Urls "cloudflare-contactform" "$DISCORD_WEBHOOK"
    echo "✅ Discord webhook stored"
else
    echo "⏭️ Skipping Discord setup"
fi

echo ""
echo "🎉 Setup Complete!"
echo "==================="
echo ""
echo "Next steps:"
echo "1. Review your wrangler.toml configuration"
echo "2. Test locally: wrangler dev"
echo "3. Deploy: wrangler deploy"
echo ""
echo "KV Namespace IDs created:"
echo "  turnstile_kv: $TURNSTILE_KV"
echo "  Discord_Urls: $DISCORD_KV"
echo ""
echo "🔗 Your worker will be available at:"
echo "https://cfcontactform1.your-subdomain.workers.dev"