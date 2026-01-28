# Static Site Server

Setup web server menggunakan Nginx untuk serve static website, dengan deployment menggunakan rsync.

Project reference: [roadmap.sh/projects/static-site-server](https://roadmap.sh/projects/static-site-server)

---

## Demo

**Google KW** - Clone tampilan Google Search yang redirect ke Google.

![Google KW Preview](https://via.placeholder.com/800x400?text=Google+KW+Preview)

---

## Tech Stack

| Component | Technology |
|-----------|------------|
| Web Server | Nginx |
| Deployment | rsync over SSH |
| Frontend | HTML, CSS, JavaScript |
| Server OS | Ubuntu 24.04 |

---

## Project Structure

```
google-kw/
├── index.html          # Main HTML file
├── style.css           # Styling
├── script.js           # JavaScript interactions
├── deploy.sh           # Deployment script
├── nginx-google-kw.conf # Nginx configuration
├── images/
│   └── favicon.ico     # Favicon
└── README.md           # Documentation
```

---

## Setup Guide

### Step 1: Install Nginx di Server

```bash
# SSH ke server
ssh your-user@192.168.246.30

# Update packages
sudo apt update

# Install Nginx
sudo apt install nginx -y

# Start dan enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Verifikasi
sudo systemctl status nginx
```

Buka browser: `http://192.168.246.30` → Harusnya muncul "Welcome to nginx!"

---

### Step 2: Configure Nginx untuk Site Baru

```bash
# Di server, buat directory untuk website
sudo mkdir -p /var/www/google-kw
sudo chown -R $USER:$USER /var/www/google-kw

# Copy konfigurasi Nginx
sudo nano /etc/nginx/sites-available/google-kw
```

Paste isi `nginx-google-kw.conf`:

```nginx
server {
    listen 80;
    listen [::]:80;

    server_name 192.168.246.30;

    root /var/www/google-kw;
    index index.html;

    access_log /var/log/nginx/google-kw.access.log;
    error_log /var/log/nginx/google-kw.error.log;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg)$ {
        expires 7d;
        add_header Cache-Control "public, immutable";
    }
}
```

Enable site dan restart Nginx:

```bash
# Enable site (buat symlink)
sudo ln -s /etc/nginx/sites-available/google-kw /etc/nginx/sites-enabled/

# Disable default site (optional)
sudo rm /etc/nginx/sites-enabled/default

# Test konfigurasi
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx
```

---

### Step 3: Install rsync (jika belum ada)

Di laptop/local:
```bash
# Ubuntu/Debian
sudo apt install rsync -y

# macOS (biasanya sudah ada)
rsync --version
```

Di server:
```bash
sudo apt install rsync -y
```

---

### Step 4: Deploy Website

#### Manual Deploy dengan rsync

```bash
# Dari folder project di laptop
rsync -avz --progress \
    -e "ssh -i ~/.ssh/id_work" \
    ./ your-user@192.168.246.30:/var/www/google-kw/
```

Penjelasan flags:
| Flag | Fungsi |
|------|--------|
| `-a` | Archive mode (preserve permissions, timestamps, etc) |
| `-v` | Verbose output |
| `-z` | Compress during transfer |
| `--progress` | Show progress |
| `-e` | Specify SSH command with key |

#### Automated Deploy dengan Script

```bash
# Beri execute permission
chmod +x deploy.sh

# Jalankan deploy
./deploy.sh
```

Output:
```
═══════════════════════════════════════════════════════
           DEPLOYING GOOGLE KW TO SERVER               
═══════════════════════════════════════════════════════

→ Target: your-user@192.168.246.30:/var/www/google-kw
→ Source: .

[1/3] Creating remote directory...
✓ Remote directory ready

[2/3] Syncing files with rsync...
sending incremental file list
index.html
style.css
script.js
✓ Files synced successfully

[3/3] Setting permissions...
✓ Permissions set

═══════════════════════════════════════════════════════
           DEPLOYMENT SUCCESSFUL! 🚀                   
═══════════════════════════════════════════════════════

Website URL: http://192.168.246.30
```

---

### Step 5: Test Website

Buka browser: `http://192.168.246.30`

Google KW siap digunakan! 🎉

---

## Development Workflow

```
┌─────────────────────────────────────────────┐
│              LOCAL DEVELOPMENT              │
├─────────────────────────────────────────────┤
│                                             │
│  1. Edit files (HTML, CSS, JS)              │
│  2. Test locally (buka index.html)          │
│  3. Run ./deploy.sh                         │
│                                             │
└─────────────────────────────────────────────┘
                     │
                     │ rsync
                     ▼
┌─────────────────────────────────────────────┐
│              PRODUCTION SERVER              │
├─────────────────────────────────────────────┤
│                                             │
│  Nginx serves updated files automatically   │
│  No restart needed for static files         │
│                                             │
└─────────────────────────────────────────────┘
```

---

## Useful Commands

### Nginx Commands

```bash
# Start/Stop/Restart
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx
sudo systemctl reload nginx  # Reload tanpa downtime

# Check status
sudo systemctl status nginx

# Test configuration
sudo nginx -t

# View logs
sudo tail -f /var/log/nginx/google-kw.access.log
sudo tail -f /var/log/nginx/google-kw.error.log
```

### rsync Commands

```bash
# Dry run (preview tanpa eksekusi)
rsync -avzn --progress ./ user@server:/path/

# Delete files di server yang tidak ada di local
rsync -avz --delete ./ user@server:/path/

# Exclude specific files
rsync -avz --exclude '*.log' --exclude '.git' ./ user@server:/path/
```

---

## Troubleshooting

### 403 Forbidden

```bash
# Fix permissions
sudo chown -R www-data:www-data /var/www/google-kw
sudo chmod -R 755 /var/www/google-kw
```

### 502 Bad Gateway

```bash
# Check Nginx error log
sudo tail -f /var/log/nginx/error.log

# Restart Nginx
sudo systemctl restart nginx
```

### Site Not Loading

```bash
# Check if site is enabled
ls -la /etc/nginx/sites-enabled/

# Check Nginx config
sudo nginx -t

# Check firewall
sudo ufw status
sudo ufw allow 'Nginx HTTP'
```

---

## Features

- ✅ Google-like search interface
- ✅ Responsive design (mobile-friendly)
- ✅ Search redirect to Google
- ✅ Keyboard shortcut (press `/` to focus search)
- ✅ Clean and minimal UI
- ✅ Automated deployment script

---

## What I Learned

1. **Nginx Configuration** - Setup virtual hosts, server blocks, dan static file serving
2. **rsync** - Efficient file synchronization dengan incremental updates
3. **SSH Key-based Deployment** - Secure automated deployment
4. **Linux File Permissions** - www-data ownership untuk web files
5. **Web Server Basics** - How requests are handled and served

---

## References

- [Nginx Documentation](https://nginx.org/en/docs/)
- [rsync Manual](https://linux.die.net/man/1/rsync)
- [DigitalOcean - Nginx Tutorials](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-22-04)

---

*Project completed as part of DevOps learning journey*
