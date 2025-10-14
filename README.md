
## Project Description
A **multi-service Docker infrastructure** using **Docker Compose**, with **TLS-secured NGINX**, **WordPress + PHP-FPM**, **MariaDB**, and **persistent volumes**.    

---

## Containers

| Service     | Base Image¹ | Exposed Port | Notes |
|-------------|-------------|--------------|-------|
| **NGINX**   | Alpine / Debian | 443 only | TLS 1.2 or 1.3, **sole entry point**, terminates SSL |
| **WordPress** | Alpine / Debian | none | php-fpm **only**, no nginx inside |
| **MariaDB** | Alpine / Debian | none | runs **only** mysqld |

---

## 💾 Volumes & Persistence

* Wordpress Database → mounted at `${HOME}/data/mariadb` (host)  
* Wordpress Files (.php) → mounted at `${HOME}/data/wordpress` (host)


## 🚀 Lifecycle

* `make` at project root builds & starts the full stack.  
* Containers **restart automatically** on crash.  

---

## 📁 Directory Layout
```
├── Makefile                 # build everything via docker-compose
├── .env                    
└── srcs/
    ├── docker-compose.yml   # declares services, volumes, network
    └── requirements/
        ├── nginx/Dockerfile
        ├── wordpress/Dockerfile
        └── mariadb/Dockerfile
```

