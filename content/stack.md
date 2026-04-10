---
title: "Stack"
description: "A breakdown of the 25+ Docker services running on the QNAP NAS, managed via Dockflare and Gluetun."
showDate: false
showReadingTime: false
showEdit: false
showComments: false
showTableOfContents: true
showHero: true
heroStyle: "background"
---

The core philosophy of the lab is **"Everything as Code."**

Every service listed below is defined in a `docker-compose.yml` file, version-controlled, and backed up. The lab runs on a **QNAP NAS** acting as the Docker Host, but the architecture is platform-agnostic.

> **GitHub Repository:** You can find the exact configuration files, folder structures, and `.env` templates for this entire stack in my [lab-stacks](https://github.com/thehomelab-lol/lab-stacks) repo.

---

## Architecture & Standards

To maintain sanity with over 25 containers, I follow strict deployment standards.

### 1. File Structure

Every application gets its own directory containing the compose file and environment variables.

```text
/homeLab
├── /karakeep
│   ├── docker-compose.yml
│   └── .env.example
├── /homepage
│   ├── docker-compose.yml
│   └── .env.example
├── .gitignore
└── README.md
```

### 2. Data Persistence

I do not use Docker Volumes. I use Bind Mounts. This makes backing up data as simple as copying a folder.

- Config Path: `/share/Public/Container_Settings/<app_name>/data`
- Secret Management: API keys are stored in .env files (which are git-ignored) and referenced in the compose files.

### 3. Networking Strategy

- **Internal:** Services are isolated.
- **VPN Routing:** Apps like qBittorrent and SearXNG route all traffic through a Gluetun container to ensure privacy.
- **External Access:** I use Dockflare. It manages Cloudflare Tunnels automatically via Docker Labels, meaning I expose services to `https://service.thehomelab.lol` without ever opening a firewall port.

## Local Access (Caddy)

While Dockflare handles external access (outside the house), I use Caddy to manage internal access.

Instead of typing IPs and ports (e.g., `192.168.1.249:8989`), I access every service via a "Pretty URL" ending in `.local`. Caddy runs as a container and handles the local DNS resolution and automatic internal SSL certificates.

**The Workflow:**

1. Device: Laptop/Phone connects to Wi-Fi.
2. Browser: I type `https://sonarr.local`.
3. Caddy: Intercepts the request and routes it to the correct Docker container port.

```caddy
# Global Options
{
    local_certs
}

# Service Definitions
sonarr.local {
    reverse_proxy 192.168.1.249:8989
}

radarr.local {
    reverse_proxy 192.168.1.249:7878
}

home.local {
    reverse_proxy 192.168.1.249:80
}
```

---

## The Project Catalog

### Management & Infrastructure

- **Dockflare** - Automated Cloudflare tunnel manager. Reads Docker labels to auto-create DNS records for containers.
- **Dozzle** - Real-time log viewer. Essential for debugging crashed containers.
- **Komodo** - Modern, agent-based Docker Management UI (replaced Portainer).
- **Semaphore UI** - Web interface for running Ansible playbooks to automate server maintenance.
- **Uptime Kuma** - Monitors services and sends alerts to Discord if something goes down.

### Media & Automation (The *Arr Stack)

- **Bazarr** - Automatically finds and downloads subtitles for Sonarr/Radarr content.
- **Discoflix** - Discord bot allowing users to request movies/shows, which automatically adds them to Sonarr/Radarr.
- **FlareSolverr** - Proxy server to bypass Cloudflare anti-bot checks, used by Prowlarr to access trackers.
- **Jellyfin** - Open-source backup media server.
- **Plex** - Primary media server (Hardware Transcoding via Intel QuickSync).
- **Sonarr (1080p & Anime)** - Two separate instances: one for standard TV, one tuned for Anime release groups.
- **Prowlarr** - Indexer manager. Syncs torrent trackers to all *Arr apps.
- **Radarr** - Automated movie collection manager.

### Downloads & Archival

- **Gluetun Stack** - Privacy core. qBittorrent, SearXNG, and Firefox route through this container via VPN.
- **jDownloader2** - For direct downloads (DDL) and file hosters.
- **KaraKeep** - Web archiver. Snapshots webpages for offline viewing (personal Wayback Machine).
- **pyLoad-ng** - Lightweight download manager with captcha solving and premium account support.
- **YTPTube** - Self-hosted YouTube downloader to archive channels in 4K.

### Productivity & Knowledge

- **Kavita** - Dedicated reading server for Comics, Manga, and eBooks.
- **Mealie** - Recipe manager and meal planner. Scrapes recipes from websites automatically.
- **Paperless-ngx** - Digital filing cabinet. OCRs physical documents and makes them searchable.
