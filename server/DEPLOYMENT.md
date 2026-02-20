# FAN ZONE — Server Deployment Guide (Ubuntu + Nginx)

Production deployment of the Express + Socket.io backend on an Ubuntu server behind Nginx reverse proxy.

---

## 1. Server Preparation

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git nginx ufw
```

### Install Node.js (v20 LTS)

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
node -v && npm -v
```

### Install PM2 (process manager)

```bash
sudo npm install -g pm2
```

---

## 2. Firewall

```bash
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw enable
sudo ufw status
```

---

## 3. Deploy Application

### Clone and install

```bash
cd /home
sudo mkdir -p /home/fan-zone
sudo chown $USER:$USER /home/fan-zone
git clone <repo-url> /home/fan-zone
cd /home/fan-zone/server
npm install --production
```

### Environment variables

```bash
nano /home/fan-zone/server/.env
```

```
PORT=4000
IP=127.0.0.1
MONGODB_URI=mongodb+srv://<user>:<password>@<cluster>.mongodb.net/fan_zone
JWT_SECRET=<generate-a-strong-secret>
NODE_ENV=production
```

Generate a strong JWT secret:

```bash
openssl rand -base64 48
```

### Seed demo data (optional)

```bash
cd /home/fan-zone/server
npm run seed
```

---

## 4. Run with PM2

```bash
cd /home/fan-zone/server
pm2 start server.js --name fan-zone-api
pm2 save
pm2 startup
```

The last command outputs a `sudo` command — copy and run it to enable auto-start on reboot.

### Useful PM2 commands

```bash
pm2 status              # list processes
pm2 logs fan-zone-api   # stream logs
pm2 restart fan-zone-api
pm2 stop fan-zone-api
pm2 monit               # live dashboard
```

---

## 5. Nginx Configuration

### Create site config

```bash
sudo nano /etc/nginx/sites-available/fan-zone
```

Paste the following (replace `your-domain.com` with your domain or server IP):

```nginx
upstream fan_zone_api {
    server 127.0.0.1:4000;
    keepalive 64;
}

server {
    listen 80;
    server_name your-domain.com;

    client_max_body_size 10M;

    # REST API
    location /api/ {
        proxy_pass http://fan_zone_api;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 90s;
    }

    # Socket.io (WebSocket + polling)
    location /socket.io/ {
        proxy_pass http://fan_zone_api;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 120s;
        proxy_send_timeout 120s;
    }

    # Health check
    location /health {
        proxy_pass http://fan_zone_api;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
    }
}
```

### Enable and test

```bash
sudo ln -s /etc/nginx/sites-available/fan-zone /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx
```

### Verify

```bash
curl http://your-domain.com/api/pitches
```

---

## 6. SSL with Certbot (Let's Encrypt)

Skip this section if using an IP address without a domain.

```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com
```

Certbot will auto-update the Nginx config to redirect HTTP → HTTPS. Auto-renewal is set up by default:

```bash
sudo certbot renew --dry-run
```

After enabling SSL, update the Flutter app's `api_constants.dart`:

```dart
static const String baseUrl = 'https://your-domain.com/api';
```

---

## 7. Flutter App Configuration

Point the mobile app to your production server. In `lib/core/constants/api_constants.dart`:

```dart
static const String baseUrl = 'http://your-domain.com/api';  // or https://
```

For Socket.io, the client will connect to the same host automatically.

---

## 8. MongoDB Atlas Network Access

Make sure your Ubuntu server's public IP is whitelisted in MongoDB Atlas:

1. Go to **Atlas → Network Access → Add IP Address**
2. Add your server IP (find it with `curl ifconfig.me`)

---

## 9. Monitoring & Logs

### PM2 logs

```bash
pm2 logs fan-zone-api --lines 100
```

### Nginx logs

```bash
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

### Disk & memory

```bash
df -h
free -m
pm2 monit
```

---

## 10. Updating the Server

```bash
cd /home/fan-zone
git pull origin main
cd server
npm install --production
pm2 restart fan-zone-api
```

---

## Quick Reference

| What | Command |
|---|---|
| Start API | `pm2 start fan-zone-api` |
| Stop API | `pm2 stop fan-zone-api` |
| Restart API | `pm2 restart fan-zone-api` |
| View logs | `pm2 logs fan-zone-api` |
| Restart Nginx | `sudo systemctl restart nginx` |
| Test Nginx config | `sudo nginx -t` |
| Renew SSL | `sudo certbot renew` |
| Check server IP | `curl ifconfig.me` |
