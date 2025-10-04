
> **Goal**: Build a **multi-service Docker infrastructure** on a **Virtual Machine** using **Docker Compose**, with **TLS-secured NGINX**, **WordPress + PHP-FPM**, **MariaDB**, and **persistent volumes**.    

> **Constraints**: No ready-made images, no `tail -f` hacks, no hard-coded secrets, no `latest` tags, and **everything must be reproducible via a single `make`** at the root.

---

## 🔧 Mandatory Stack (3 containers minimum)

| Service     | Base Image¹ | Exposed Port | Notes |
|-------------|-------------|--------------|-------|
| **NGINX**   | Alpine / Debian | 443 only | TLS 1.2 or 1.3, **sole entry point**, terminates SSL |
| **WordPress** | Alpine / Debian | none | php-fpm **only**, no nginx inside |
| **MariaDB** | Alpine / Debian | none | runs **only** mysqld |

¹ *Use the penultimate stable version.*




---

## 💾 Volumes & Persistence

* `wordpress_db` → mounted at `/home/<login>/data/db` (host)  
* `wordpress_files` → mounted at `/home/<login>/data/wordpress` (host)

---

## 🌐 Network & DNS

* Custom docker-network (no `--link`, no `network: host`)  
* Local domain: `<login>.42.fr` → VM IP (configure `/etc/hosts` or DNS)  
* NGINX vhost must serve this domain on 443.

---

## 🔐 Security Rules

1. **No** hard-coded passwords in Dockerfiles.  
2. **Must** use environment variables (`.env` or Docker secrets).  
3. **No** `latest` tag in any image.  
4. **No** infinite-loop hacks (`tail -f`, `sleep infinity`, etc.).  
5. WordPress **admin** username **must NOT** contain “admin”, “Admin”, “administrator”, “Administrator”.

---

## 🚀 Lifecycle

* `make` at project root builds & starts the full stack.  
* Containers **restart automatically** on crash.  
* Everything runs inside the **VM**—no host dependencies beyond Docker.

---

## 📁 Required Directory Layout
```
├── Makefile                 # must build everything via docker-compose
├── .env                     # all secrets via env vars (no hard-coded passwords)
├── secrets/                 # optional Docker-secrets files (git-ignored)
└── srcs/
    ├── docker-compose.yml   # declares services, volumes, network
    └── requirements/
        ├── nginx/Dockerfile
        ├── wordpress/Dockerfile
        └── mariadb/Dockerfile
```

