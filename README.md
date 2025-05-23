# MariaDB + Adminer Setup for Weimuller u-OS (UC20-WL2000)

A lightweight MariaDB SQL database server with optional web-based administration, optimized for Weidmuller's UC20-WL2000 micro controller which runs u-OS(Fork of Yocto) with 4GB storage, 500MB RAM. 

## 🚀 Features

- **Ultra-lightweight**: Alpine Linux base (~5MB vs 120MB+ for other distributions)
- **Resource optimized**: Configured for minimal memory usage (400MB max)
- **Web interface**: Optional Adminer provides easy database management via browser
- **Persistent data**: Database survives container restarts
- **Network accessible**: Connect from anywhere on your local network

## 📁 Project Structure

```
mariadb-setup/
├── Dockerfile               # Custom MariaDB build
├── docker-compose-prod.yml  # Primary, runs/builds only the SQL database
├── docker-compose-dev.yml   # Runs/builds the SQL database and also the adminer webui
├── my-minimal.cnf           # Database configuration
├── init-db.sh               # Database initialization
├── docker-entrypoint.sh     # Container startup script
├── mini-mariadb.service     # systemctl service for starting/stopping the containers automatically
└── README.md                # This file
```

## ⚡ Quick Start

### 1. Clone and Build

```bash
git clone <your-repo>
cd u-os-mini-mariadb
```

### 2. Start
You can choose either the prod or dev `compose.yml` depenedent on your needs. The `prod.yml` does not build/run the adminer sql admin container. This is so that you dont take up extra space on the Weidmuller UC20-WL2000, since its not likely you will need a webui in your project

```bash
docker compose -f docker-compose-dev.yml up -d
```

That's it! The database and web interface will start automatically.

### 3. Access the Web Interface
If you decided to start adminer, in your browser connected to the UC20 network go to:
```
http://192.168.0.101:8080
(weidmuller defaults this to 192.168.0.101, but it may be dif.)
```

### 4. Login Credentials

- **System**: MySQL
- **Server**: `db`
- **Username**: `u-os-host`
- **Password**: `some_password` #please change this.
- **Database**: `myDatabase`

### Service Config
Included is the `mini-mariadb.service` file for starting the database container. 
The service requires the `docker-compose-prod.yml` to be in `/opt/mini-mariadb/`

Place this in the `/etc/systemd/system/` directory then

```bash
systemctl start mini-mariadb

#To start on boot
systemctl enable mini-mariadb
```

## 🔧 Configuration

### Database Settings
The database is configured for minimal resource usage:
- Maximum 10 concurrent connections
- 64MB buffer pool
- Optimized for low memory environments

### Security Notes
- Change default passwords in `init-db.sh`
- The web interface (port 8080) should not be exposed to the internet
- Consider stopping or not using Adminer when not needed

## 🛠️ Common Commands

```bash
# Start services
docker compose -f docker-compose-dev.yml up -d

# Stop services
docker compose down

# Access database directly
docker exec -it u-os-mini-mariadb mysql -u u-os-host -p

```

## 🐛 Troubleshooting

### "Host not allowed to connect" Error
If you see this error in Adminer, the database users need remote access permissions:

```bash
# Connect to the database container
docker exec -it u-os-mini-mariadb mysql

# Run these commands
CREATE USER 'appuser'@'%' IDENTIFIED BY 'your_secure_password';
GRANT ALL ON appdb.* TO 'appuser'@'%';
FLUSH PRIVILEGES;
```

### Out of Memory Issues
Monitor resource usage:
```bash
docker stats
```

If memory usage is too high, reduce `max_connections` in `my-minimal.cnf`.

## 📊 Resource Usage

- **MariaDB**: ~400MB RAM max
- **Adminer**: ~50MB RAM max
- **Total Disk**: ~50MB for containers + your data
- **Ideal for**: Weidmuller u-OS, Raspberry Pi, small VPS, development environments
