include ./srcs/.env
export

# Colors
RED		= \033[0;31m
GREEN	= \033[0;32m
YELLOW	= \033[0;33m
CYAN	= \033[0;36m
BOLD	= \033[1m
RESET	= \033[0m

# Rules
all: inception init_hosts build_containers

clean:
	@echo "${BOLD}${RED}Taking down containers...${RESET}\n"
	@cd srcs && docker-compose down

fclean: clean
	@echo "${BOLD}${RED}Removing volumes and containers...${RESET}\n"
	@docker system prune -a --volumes -f
	@docker network prune -f
	@docker network rm $(docker network ls -q) 2> /dev/null || true
	@docker volume rm $(docker volume ls -qf dangling=true) 2> /dev/null || true
	@rm -rf ${MDB_VOLUME} ${WP_VOLUME}

re: fclean all

build_containers:
	@echo "${BOLD}${GREEN}Building containers...${RESET}\n"
	@mkdir -p ${MDB_VOLUME} ${WP_VOLUME}
	@chmod 777 ${MDB_VOLUME} ${WP_VOLUME}
	@cd srcs && docker-compose up -d --build

init_hosts:
	@echo "${BOLD}${YELLOW}Adding ${DOMAIN_NAME} to /etc/hosts${RESET}\n"
	@sudo chmod 666 /etc/hosts
	@sudo echo "${IP} ${DOMAIN_NAME}" >> /etc/hosts
	@sudo echo "${IP} www.${DOMAIN_NAME}" >> /etc/hosts

# ASCII Art
inception:
			@echo "${BOLD}${CYAN}▀██▀                                     ▄    ██                   ▄█▄ ${RESET}\n"
			@echo "${BOLD}${CYAN} ██  ▄▄ ▄▄▄     ▄▄▄▄    ▄▄▄▄  ▄▄▄ ▄▄▄  ▄██▄  ▄▄▄    ▄▄▄   ▄▄ ▄▄▄   ███ ${RESET}\n"
			@echo "${BOLD}${CYAN} ██   ██  ██  ▄█   ▀▀ ▄█▄▄▄██  ██▀  ██  ██    ██  ▄█  ▀█▄  ██  ██  ▀█▀ ${RESET}\n"
			@echo "${BOLD}${CYAN} ██   ██  ██  ██      ██       ██    █  ██    ██  ██   ██  ██  ██   █  ${RESET}\n"
			@echo "${BOLD}${CYAN}▄██▄ ▄██▄ ██▄  ▀█▄▄▄▀  ▀█▄▄▄▀  ██▄▄▄▀   ▀█▄▀ ▄██▄  ▀█▄▄█▀ ▄██▄ ██▄  ▄  ${RESET}\n"
			@echo "${BOLD}${CYAN}                               ██                                  ▀█▀ ${RESET}\n"
			@echo "${BOLD}${CYAN}                              ▀▀▀▀                                     ${RESET}\n"
