# Production Deployment Guide

This guide provides instructions for deploying the Next.js application to production.

## Deployment Options

### Option 1: Vercel (Recommended)

Vercel is the recommended platform for Next.js applications, created by the same team.

1. **Install Vercel CLI** (optional for local testing):
   ```bash
   npm install -g vercel
   ```

2. **Deploy to Vercel**:
   - Push your code to a GitHub/GitLab/Bitbucket repository
   - Go to [https://vercel.com/new](https://vercel.com/new)
   - Import your project
   - Vercel will automatically detect it's a Next.js project
   - Click "Deploy"

3. **Environment Variables**:
   - Add any required environment variables in the Vercel project settings

### Option 2: Standalone Node.js Server

The project is configured with `output: "standalone"` for self-hosting:

1. **Build for production**:
   ```bash
   npm run build
   ```

2. **Start the server**:
   ```bash
   npm start
   ```

3. **Use a process manager** (recommended for production):
   ```bash
   npm install -g pm2
   pm2 start npm --name "nextjs-app" -- start
   ```

### Option 3: Docker Deployment

Create a Dockerfile:

```dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:18-alpine AS runner
WORKDIR /app
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public
EXPOSE 3000
CMD ["node", "server.js"]
```

Then build and run:
```bash
docker build -t nextjs-app .
docker run -p 3000:3000 nextjs-app
```

## Production Configuration

The application includes the following production optimizations:

- **SWG Minification**: Enabled for smaller bundle sizes
- **React Strict Mode**: Enabled for better error handling
- **Compression**: Enabled for faster page loads
- **Standalone Output**: For self-hosting capabilities

## Environment Variables

Create a `.env.local` file for production environment variables:

```
# Example environment variables
NEXT_PUBLIC_API_URL=https://api.example.com
NODE_ENV=production
```

## Monitoring and Maintenance

For production deployments, consider:

1. **Logging**: Set up logging services
2. **Monitoring**: Use tools like Sentry for error tracking
3. **CI/CD**: Set up continuous integration and deployment
4. **Backups**: Regular database and file backups
5. **Security**: Keep dependencies updated and implement security best practices