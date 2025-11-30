---
title: "The Lab: Hardware & Specs"
date: 2023-11-30T10:00:00-05:00
draft: false
tags: ["homelab", "hardware", "infrastructure"]
summary: "A detailed breakdown of the silicon powering TheHomeLab.lol, from 2.5GbE networking to N5105-powered storage."
---

Every homelab is a work in progress. Here is the current state of the infrastructure powering my self-hosted services, containers, and development workflows.

## Storage & Virtualization (The Core)

My "Always On" infrastructure relies on QNAP hardware modified for Docker performance. The N5105 CPU is critical here because it supports Intel QuickSync for hardware transcoding (Plex/Jellyfin).

### QNAP TS-464

This is the primary workhorse. It handles mass storage, backups, and runs the bulk of my Docker containers via Portainer.

| Component | Specification | Role |
| :--- | :--- | :--- |
| **CPU** | Intel Celeron N5105 (4c/4t @ 2.9GHz) | Transcoding & Container Orchestration |
| **RAM** | 16 GB (15 GB Usable) | Memory for Docker Stacks |
| **Network** | 2.5 GbE | High-speed link to Switch |
| **Storage (Capacity)** | 4x 8TB SATA HDDs (3.5") | Media Library & Archives |
| **Storage (Speed)** | 1x 1TB NVMe SSD (PCIe Gen3) | AppData, Databases, & Container Volumes |

> **Config Note:** The HDDs are strictly for "Cold Storage" (Capacity Tier). All Docker containers and databases live on the NVMe SSD to ensure the UI remains snappy.

---

## ⚡ Compute (The Drivers)

While the NAS runs the background tasks, these machines handle the heavy lifting, compilation, and administration.

### Mac Mini (M2)

* **Spec:** Apple M2 Chip / 16 GB RAM
* **Role:** The daily driver. This machine manages the SSH sessions into the lab and handles video editing for the channel.
* **Connectivity:** Hardwired via 2.5GbE.

### MacBook Air (M1, 2020)

* **Spec:** Apple M1 Chip / 8 GB RAM
* **Role:** The "Mobile Command Center." Used for writing code and monitoring Grafana dashboards while away from the desk.

---

## 🌐 Networking (The Backbone)

You cannot have a high-performance lab with a 1Gbps bottleneck. The network backbone has been upgraded to 2.5Gbps to match the QNAP's throughput.

### Unmanaged 2.5GbE Switch (5-Port)

* **Throughput:** 2.5 Gbps per port (Full Duplex)
* **Uplinks:**
  * Port 1: QNAP TS-464
  * Port 2: Mac Mini M2
  * Port 5: Uplink to Router/WAN

---

*This page is updated as hardware is rotated or upgraded.*
