---
title: "Setting up Pi-hole"
date: 2023-11-30
draft: false
summary: "A guide on setting up Pi-hole for network-wide ad blocking."
cover:
    image: "cover.png"
    alt: "Pi-hole Logo"
    caption: "Network-wide Ad Blocking"
    relative: true
---


## Prerequisites

Before we begin, ensure you have the following:

- **QNAP NAS**: This guide is tailored for a QNAP NAS (e.g., TS-464) running QTS.
- **Container Station**: Installed and running on your NAS.
- **SSH Access**: Enabled on your NAS for easier management (optional but recommended).
- **Static IP**: Your NAS should have a static IP address (e.g., `192.168.1.249`) to ensure DNS settings on your router remain valid.

## Installation

We will use **Docker Compose** for a reproducible and easy-to-manage installation. This method allows you to define your configuration in a file, making updates and backups simple.

### 1. Create the Project Directory

First, create a directory for your Pi-hole configuration. You can do this via File Station or SSH.

```bash
mkdir -p /share/Container/pihole
cd /share/Container/pihole
```

### 2. Create `docker-compose.yml`

Create a file named `docker-compose.yml` in your project directory with the following content:

```yaml
version: "3"

services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    # For standard setup, use host networking or map ports.
    # Host networking is often easier for DNS on NAS but can conflict with system ports.
    # We will use port mapping with a custom web port to avoid conflicts.
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      # - "67:67/udp" # Uncomment if using Pi-hole as DHCP server
      - "8080:80/tcp" # Web interface mapped to 8080 to avoid conflict with QTS
    environment:
      TZ: 'America/Denver' # Set your timezone
      WEBPASSWORD: 'yoursecurepassword' # Set a secure password
      # QNAP Specific: Fix for DNS resolution issues in containers
      DNS1: 1.1.1.1
      DNS2: 1.0.0.1
    volumes:
      - './etc-pihole:/etc/pihole'
      - './etc-dnsmasq.d:/etc/dnsmasq.d'
    # Recommended: specific DNS for the container itself if you have QNAP DNS issues
    dns:
      - 127.0.0.1
      - 1.1.1.1
    restart: unless-stopped
```

> [!NOTE]
> **QNAP Port Conflicts**: QTS often uses port 80. We mapped the Pi-hole web interface to port **8080** (`8080:80/tcp`). You will access the admin panel at `http://<NAS_IP>:8080/admin`

### 3. Deploy the Container

Run the following command in your project directory (via SSH) or use the "Create Application" feature in Container Station by pasting the YAML content.

```bash
docker compose up -d
```

## Configuration

### Accessing the Admin Panel

Navigate to `http://192.168.1.249:8080/admin` in your browser. Log in with the password you set in the `docker-compose.yml` file.

### Recommended Settings

1. **Adlists**: Go to **Group Management > Adlists**. The default list is good, but you can add more from reputable sources like [Firebog](https://firebog.net/).
2. **DNS Settings**: Go to **Settings > DNS**.
    - **Upstream DNS Servers**: Choose your preferred providers (e.g., Cloudflare, Google, OpenDNS).
    - **Conditional Forwarding**: If you want to see local hostnames instead of IP addresses, enable this and point it to your router's IP and local domain name.

> [!IMPORTANT]
> **QNAP DNS Issue**: If you experience issues where the Pi-hole container (or others) cannot resolve external domains, ensure you have explicitly set the `dns` key in your `docker-compose.yml` as shown above. QNAP's network stack can sometimes interfere with Docker's default DNS resolution.

## Router Setup

To make Pi-hole effective for your entire network, you need to tell your router to use your NAS's IP address (`192.168.1.249`) as the DNS server.

1. Log in to your router's admin page.
2. Find the **DHCP** or **LAN** settings (not WAN/Internet).
3. Set the **Primary DNS** to `192.168.1.249`.
4. (Optional) Set a Secondary DNS to a public provider (like `1.1.1.1`) if you want a fallback in case the NAS goes down, though this means some ads might slip through.

Once saved, your devices will start using Pi-hole after their DHCP lease renews (or you can manually reconnect them).
