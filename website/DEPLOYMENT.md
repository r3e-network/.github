# R3E Network Website Deployment Guide

This guide provides step-by-step instructions for deploying the r3e.network website to various hosting platforms.

## 🎯 Deployment Overview

The R3E Network website is a static site that can be deployed to any web hosting platform that supports HTML, CSS, and JavaScript. No server-side processing is required.

## 🚀 Quick Deployment Options

### Option 1: Netlify (Recommended)

**Why Netlify:**
- Free tier with custom domain support
- Automatic SSL certificates
- Git integration for automatic deployments
- Excellent performance and CDN
- Easy domain configuration

**Steps:**

1. **Prepare Files**
   ```bash
   # Create a new directory for deployment
   mkdir r3e-website-deploy
   cd r3e-website-deploy
   
   # Copy website files
   cp -r ../website/* .
   ```

2. **Deploy via Drag & Drop**
   - Go to [netlify.com](https://netlify.com)
   - Create account or sign in
   - Drag the website folder to the deploy area
   - Your site is live with a random URL

3. **Configure Custom Domain**
   - Go to Site Settings > Domain Management
   - Add custom domain: `r3e.network`
   - Follow DNS configuration instructions
   - SSL certificate is automatically provisioned

4. **Set up Git Integration (Optional)**
   ```bash
   # Initialize git repository
   git init
   git add .
   git commit -m "Initial website deployment"
   
   # Push to GitHub
   git remote add origin https://github.com/r3e-network/website.git
   git push -u origin main
   ```
   - Connect repository in Netlify dashboard
   - Enable automatic deployments

### Option 2: Vercel

**Steps:**

1. **Install Vercel CLI**
   ```bash
   npm i -g vercel
   ```

2. **Deploy**
   ```bash
   cd website
   vercel
   
   # Follow prompts:
   # - Link to existing project? No
   # - Project name: r3e-network
   # - Directory: ./
   # - Override settings? No
   ```

3. **Configure Domain**
   ```bash
   vercel domains add r3e.network
   vercel alias [deployment-url] r3e.network
   ```

### Option 3: GitHub Pages

**Steps:**

1. **Create Repository**
   ```bash
   # Create new repository on GitHub: r3e-network/website
   git init
   git add .
   git commit -m "Initial website commit"
   git remote add origin https://github.com/r3e-network/website.git
   git push -u origin main
   ```

2. **Enable GitHub Pages**
   - Go to repository Settings
   - Scroll to Pages section
   - Source: Deploy from a branch
   - Branch: main / (root)
   - Save

3. **Configure Custom Domain**
   - Add CNAME file to repository root:
   ```bash
   echo "r3e.network" > CNAME
   git add CNAME
   git commit -m "Add custom domain"
   git push
   ```

## 🌐 DNS Configuration

### For r3e.network Domain

**Required DNS Records:**

```
# For Netlify
Type    Name    Value                           TTL
A       @       75.2.60.5                      300
CNAME   www     r3e-network.netlify.app        300

# For Vercel  
Type    Name    Value                           TTL
A       @       76.76.19.61                    300
CNAME   www     cname.vercel-dns.com           300

# For GitHub Pages
Type    Name    Value                           TTL
A       @       185.199.108.153                300
A       @       185.199.109.153                300
A       @       185.199.110.153                300
A       @       185.199.111.153                300
CNAME   www     r3e-network.github.io          300
```

**Domain Provider Settings:**
1. Log into your domain registrar (GoDaddy, Namecheap, etc.)
2. Go to DNS management
3. Add the records above based on your chosen hosting platform
4. Wait for propagation (up to 24 hours)

## 📁 File Preparation

### Pre-deployment Checklist

```bash
# Navigate to website directory
cd website

# Verify all files are present
ls -la
# Should show: index.html, styles.css, script.js, README.md, etc.

# Test website locally
python -m http.server 8000
# Open http://localhost:8000 and test all functionality
```

### Optimization Steps

1. **Minify CSS and JavaScript** (Optional)
   ```bash
   # Install minification tools
   npm install -g clean-css-cli terser
   
   # Minify CSS
   cleancss -o styles.min.css styles.css
   
   # Minify JavaScript
   terser script.js -o script.min.js
   
   # Update HTML to reference minified files
   ```

2. **Optimize Images** (If any added)
   ```bash
   # Convert to WebP format for better performance
   # Use online tools or imagemin CLI
   ```

## 🔧 Advanced Deployment with CI/CD

### GitHub Actions for Automatic Deployment

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy Website

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
    
    - name: Install dependencies
      run: npm install
    
    - name: Build and optimize
      run: npm run build
    
    - name: Deploy to Netlify
      uses: nwtgck/actions-netlify@v2.0
      with:
        publish-dir: './dist'
        production-branch: main
        github-token: ${{ secrets.GITHUB_TOKEN }}
        deploy-message: "Deploy from GitHub Actions"
      env:
        NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
        NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
```

### Build Script Setup

Create `package.json`:

```json
{
  "name": "r3e-network-website",
  "version": "1.0.0",
  "description": "R3E Labs organization website",
  "scripts": {
    "dev": "python -m http.server 8000",
    "build": "npm run optimize",
    "optimize": "npm run minify-css && npm run minify-js",
    "minify-css": "cleancss -o dist/styles.min.css styles.css",
    "minify-js": "terser script.js -o dist/script.min.js",
    "deploy": "netlify deploy --prod --dir=dist"
  },
  "devDependencies": {
    "clean-css-cli": "^5.6.2",
    "terser": "^5.19.2",
    "netlify-cli": "^15.8.0"
  }
}
```

## 🔒 Security Configuration

### Content Security Policy

Add to HTML `<head>`:

```html
<meta http-equiv="Content-Security-Policy" content="
  default-src 'self';
  script-src 'self' https://unpkg.com https://www.googletagmanager.com;
  style-src 'self' 'unsafe-inline' https://fonts.googleapis.com;
  font-src https://fonts.gstatic.com;
  img-src 'self' data: https:;
  connect-src 'self';
">
```

### Netlify Configuration

Create `netlify.toml`:

```toml
[build]
  publish = "."

[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-XSS-Protection = "1; mode=block"
    X-Content-Type-Options = "nosniff"
    Referrer-Policy = "strict-origin-when-cross-origin"
    Permissions-Policy = "camera=(), microphone=(), geolocation=()"

[[redirects]]
  from = "https://www.r3e.network/*"
  to = "https://r3e.network/:splat"
  status = 301
  force = true
```

## 📊 Post-Deployment Setup

### 1. Analytics Setup

Add Google Analytics to `index.html`:

```html
<!-- Add before closing </head> tag -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_MEASUREMENT_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_MEASUREMENT_ID');
</script>
```

### 2. Search Console Setup

1. Go to [Google Search Console](https://search.google.com/search-console)
2. Add property for r3e.network
3. Verify ownership via DNS or HTML file
4. Submit sitemap.xml (create if needed)

### 3. Performance Monitoring

**Create sitemap.xml:**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://r3e.network/</loc>
    <lastmod>2025-01-02</lastmod>
    <changefreq>weekly</changefreq>
    <priority>1.0</priority>
  </url>
</urlset>
```

## 🧪 Testing Deployment

### Pre-launch Checklist

- [ ] Website loads correctly on desktop and mobile
- [ ] All navigation links work
- [ ] Contact form submits without errors
- [ ] All external links open correctly
- [ ] SSL certificate is active (https://)
- [ ] Domain redirects work (www to non-www)
- [ ] Page load speed is acceptable
- [ ] SEO meta tags are present
- [ ] Favicon displays correctly

### Testing Tools

```bash
# Test website performance
curl -o /dev/null -s -w "%{time_total}\n" https://r3e.network

# Check SSL certificate
curl -I https://r3e.network

# Validate HTML
# Use https://validator.w3.org/

# Test mobile responsiveness
# Use Chrome DevTools device emulation
```

## 🚨 Troubleshooting

### Common Issues

**1. Domain not resolving**
- Check DNS propagation: https://whatsmydns.net/
- Verify DNS records are correct
- Wait up to 24 hours for full propagation

**2. SSL certificate issues**
- Ensure HTTPS redirect is configured
- Check certificate validity
- Clear browser cache

**3. 404 errors**
- Verify file paths are correct
- Check case sensitivity
- Ensure index.html is in root directory

**4. Slow loading**
- Optimize images
- Enable gzip compression
- Use CDN
- Minify CSS/JS

### Support Contacts

- **Netlify Support**: https://docs.netlify.com/
- **Vercel Support**: https://vercel.com/help
- **GitHub Pages**: https://docs.github.com/en/pages
- **Domain Issues**: Contact your domain registrar

## 📞 Post-Deployment Maintenance

### Regular Tasks

1. **Monthly**: Check website functionality and load times
2. **Quarterly**: Update content and project information
3. **Annually**: Review and update dependencies
4. **As needed**: Monitor analytics and fix any issues

### Content Updates

```bash
# For Git-based deployments
git add .
git commit -m "Update content"
git push origin main
# Automatic deployment will trigger

# For manual deployments
# Re-upload changed files to hosting platform
```

---

**🎉 Congratulations! Your R3E Network website is now live at r3e.network** 