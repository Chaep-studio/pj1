# Internet Deployment Guide

This guide provides step-by-step instructions to make your Next.js application accessible on the internet.

## Quick Deployment Options

### Option 1: Deploy to Vercel (Easiest - Recommended)

Vercel offers free hosting for Next.js applications and is the fastest way to get your site online.

**Steps:**

1. **Install Vercel CLI (optional):**
   ```bash
   npm install -g vercel
   ```

2. **Deploy your project:**
   ```bash
   vercel
   ```
   - Follow the prompts to link your account
   - Choose your project name (this will be your URL: `https://[project-name].vercel.app`)
   - Confirm deployment

3. **Your site will be live!**
   - Vercel will provide you with a live URL
   - Example: `https://your-project-name.vercel.app`

### Option 2: Deploy to Netlify

Netlify also offers free hosting with excellent Next.js support.

**Steps:**

1. **Install Netlify CLI:**
   ```bash
   npm install -g netlify-cli
   ```

2. **Deploy your project:**
   ```bash
   netlify deploy --prod
   ```

3. **Follow the prompts to complete deployment**

### Option 3: Deploy to AWS/Google Cloud/Azure

For more control, deploy to major cloud providers:

#### AWS (Elastic Beanstalk)

1. **Install AWS CLI and configure:**
   ```bash
   npm install -g aws-cli
   aws configure
   ```

2. **Create deployment package:**
   ```bash
   zip -r deploy.zip .next/standalone package.json public/
   ```

3. **Deploy to Elastic Beanstalk:**
   ```bash
   aws elasticbeanstalk create-application-version --application-name nextjs-app --version-label v1 --source-bundle S3Bucket=your-bucket,S3Key=deploy.zip
   ```

#### Google Cloud (Cloud Run)

1. **Build Docker image:**
   ```bash
   docker build -t gcr.io/your-project-id/nextjs-app .
   ```

2. **Push to Google Container Registry:**
   ```bash
   docker push gcr.io/your-project-id/nextjs-app
   ```

3. **Deploy to Cloud Run:**
   ```bash
   gcloud run deploy --image gcr.io/your-project-id/nextjs-app --platform managed
   ```

## Self-Hosting Options

### Option 1: Use a VPS (DigitalOcean, Linode, etc.)

1. **Set up a VPS:**
   - Create an account on DigitalOcean, Linode, or similar
   - Create a new droplet/server (Ubuntu 22.04 recommended)
   - SSH into your server: `ssh root@your-server-ip`

2. **Install dependencies:**
   ```bash
   apt update && apt upgrade -y
   apt install -y nodejs npm git
   apt install -y nginx
   ```

3. **Clone your project:**
   ```bash
   git clone https://github.com/your-repo/nextjs-app.git
   cd nextjs-app
   ```

4. **Install and build:**
   ```bash
   npm install
   npm run build
   ```

5. **Set up PM2 (process manager):**
   ```bash
   npm install -g pm2
   pm2 start node --name "nextjs-app" -- .next/standalone/server.js
   pm2 save
   pm2 startup
   ```

6. **Configure Nginx as reverse proxy:**
   ```bash
   nano /etc/nginx/sites-available/nextjs-app
   ```
   
   Add this configuration:
   ```nginx
   server {
       listen 80;
       server_name your-domain.com;
       
       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

7. **Enable the site and restart Nginx:**
   ```bash
   ln -s /etc/nginx/sites-available/nextjs-app /etc/nginx/sites-enabled/
   nginx -t
   systemctl restart nginx
   ```

8. **Set up a domain (optional):**
   - Point your domain's A record to your server's IP
   - Or use the server's IP directly: `http://your-server-ip`

### Option 2: Use Docker on a VPS

1. **Install Docker on your VPS:**
   ```bash
   apt update
   apt install -y docker.io docker-compose
   systemctl enable docker
   systemctl start docker
   ```

2. **Deploy using Docker Compose:**
   ```bash
   git clone https://github.com/your-repo/nextjs-app.git
   cd nextjs-app
   docker-compose up -d --build
   ```

3. **Set up Nginx reverse proxy (same as above)**

## Domain and SSL Setup

### Get a Free Domain

- **Freenom**: Free domains (`.tk`, `.ml`, `.ga`, etc.)
- **Dot.tk**: Free `.tk` domains
- **GitHub Student Pack**: Free `.me` domain if you're a student

### Set Up Free SSL with Let's Encrypt

1. **Install Certbot:**
   ```bash
   apt install -y certbot python3-certbot-nginx
   ```

2. **Obtain SSL certificate:**
   ```bash
   certbot --nginx -d your-domain.com
   ```

3. **Auto-renewal:**
   ```bash
   certbot renew --dry-run
   ```

## Deployment Checklist

- [ ] Choose a deployment method
- [ ] Set up hosting account (Vercel, Netlify, VPS, etc.)
- [ ] Configure environment variables
- [ ] Set up domain name (optional)
- [ ] Configure SSL certificates
- [ ] Set up monitoring and backups
- [ ] Test the live website

## Troubleshooting

**Common Issues and Solutions:**

1. **Port 3000 already in use:**
   ```bash
   lsof -i :3000
   kill -9 PID
   ```

2. **Nginx configuration errors:**
   ```bash
   nginx -t
   journalctl -u nginx -f
   ```

3. **Docker build failures:**
   ```bash
   docker-compose down
   docker system prune
   docker-compose up --build
   ```

4. **Memory issues on VPS:**
   ```bash
   pm2 scale nextjs-app 1
   pm2 restart nextjs-app
   ```

## Cost Estimation

| Service | Free Tier | Paid Tier |
|---------|-----------|-----------|
| Vercel | Free (3 projects) | $20/month (Pro) |
| Netlify | Free | $19/month (Pro) |
| DigitalOcean | $4/month | $8+/month |
| AWS Lightsail | $3.5/month | $5+/month |
| Google Cloud Run | Free tier | Pay-as-you-go |

## Next Steps

1. **Choose your deployment method** based on your needs and budget
2. **Follow the step-by-step instructions** for your chosen method
3. **Test your live website** thoroughly
4. **Set up monitoring** to track performance and errors
5. **Implement CI/CD** for automatic deployments on code changes

Your Next.js application is now ready to be deployed to the internet! 🚀