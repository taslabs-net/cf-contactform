// Basic contact form worker for initial deployment
// Run setup.sh after deployment to configure KV stores and secrets

export default {
  async fetch(request, env, ctx) {
    if (request.method === "GET") {
      return new Response(`
        <html>
          <head><title>Contact Form - Setup Required</title></head>
          <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 50px auto; padding: 20px;">
            <h1>🚀 Contact Form Deployed Successfully!</h1>
            <p>Your Cloudflare Worker is running, but setup is required.</p>
            
            <h2>Next Steps:</h2>
            <ol>
              <li>Clone your forked repository locally</li>
              <li>Run <code>./setup.sh</code> to configure KV stores and secrets</li>
              <li>Deploy again with <code>npm run deploy</code></li>
            </ol>
            
            <h2>Required Configuration:</h2>
            <ul>
              <li>Turnstile keys (free from Cloudflare)</li>
              <li>Mailgun credentials (free tier available)</li>
              <li>Discord webhook (optional)</li>
            </ul>
            
            <p><a href="https://github.com/taslabs-net/cfcontactform1#readme">📖 View Setup Instructions</a></p>
          </body>
        </html>
      `, {
        headers: { "Content-Type": "text/html" }
      });
    }
    
    return new Response("Setup required. See deployment instructions.", { status: 404 });
  }
};