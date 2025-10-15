# **************************************************************************** #
#                                   SETTINGS                                   #
# **************************************************************************** #

COMPOSE_FILE := ./srcs/docker-compose.yml

# **************************************************************************** #
#                                   COMMANDS                                   #
# **************************************************************************** #

.PHONY: all build up down stop restart logs clean fclean re status check

## Main target: build + start containers safely
all: build up check

## Build containers (images)
build:
	@echo "\033[1;34m[+] Building Docker images...\033[0m"
	@docker compose -f $(COMPOSE_FILE) build --no-cache

## Start containers in detached mode
up:
	@echo "\033[1;34m[+] Starting Docker containers...\033[0m"
	@docker compose -f $(COMPOSE_FILE) up -d

## Stop containers but keep data
stop:
	@echo "\033[1;33m[-] Stopping containers...\033[0m"
	@docker compose -f $(COMPOSE_FILE) stop

## Bring everything down (including networks)
down:
	@echo "\033[1;31m[-] Removing containers and networks...\033[0m"
	@docker compose -f $(COMPOSE_FILE) down

## Remove all containers, volumes, networks and images
fclean:
	@echo "\033[1;31m[✗] Removing all Docker data...\033[0m"
	@docker compose -f $(COMPOSE_FILE) down -v --rmi all --remove-orphans
	@docker system prune -af --volumes

## Rebuild and restart everything
re: fclean all

## Show container logs
logs:
	@docker compose -f $(COMPOSE_FILE) logs -f

## Show container status
status:
	@docker compose -f $(COMPOSE_FILE) ps

# **************************************************************************** #
#                                HEALTH CHECK                                  #
# **************************************************************************** #

## Check if all containers are up and healthy
check:
	@echo "\033[1;34m[✓] Checking container health...\033[0m"
	@containers=$$(docker compose -f $(COMPOSE_FILE) ps -aq); \
	if [ -z "$$containers" ]; then \
		echo "\033[1;31m[✗] No containers found. Did you run 'make up'?\033[0m"; \
		exit 1; \
	fi; \
	for c in $$containers; do \
		status=$$(docker inspect -f '{{.State.Status}}' $$c); \
		name=$$(docker inspect -f '{{.Name}}' $$c | sed 's|/||'); \
		if [ "$$status" != "running" ]; then \
			echo "\033[1;31m[✗] Container $$name is not running (status: $$status)\033[0m"; \
			exit 1; \
		else \
			echo "\033[1;32m[✔] Container $$name is running.\033[0m"; \
		fi; \
	done; \
	echo "\033[1;32m[✔] All containers are running successfully!\033[0m"
