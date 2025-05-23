include ./srcs/.env
export

# Rainbow colors
RED		= \033[31m
ORANGE	= \033[38;5;214m
YELLOW	= \033[33m
GREEN	= \033[32m
BLUE	= \033[34m
INDIGO	= \033[38;5;57m
VIOLET	= \033[38;5;93m
BOLD	= \033[1m
RESET	= \033[0m

# Rules
all: inception init_hosts zimmer build_containers logs

clean:
	@echo "${BOLD}${RED}Taking down containers...${RESET}\n"
	@cd srcs && docker-compose down
	@echo "${BOLD}${RED}Removing logs...${RESET}\n"
	@if [ -d "./logs" ]; then rm -rf ./logs; fi

fclean: clean
	@echo "${BOLD}${RED}Removing volumes and containers...${RESET}\n"
	@docker system prune -a --volumes -f
	@docker network prune -f
	@docker network rm $(docker network ls -q) 2> /dev/null || true
	@docker volume rm $(docker volume ls -qf dangling=true) 2> /dev/null || true
	@sudo rm -rf ${MDB_VOLUME} ${WP_VOLUME}
	@make stopmusic > /dev/null 2>&1 || true

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

# Debug
exec_mariadb:
	@echo "${BOLD}${GREEN}Connecting to mariadb...${RESET}\n"
	@docker exec -it inception_mariadb_container sh

exec_wordpress:
	@echo "${BOLD}${GREEN}Connecting to wordpress...${RESET}\n"
	@docker exec -it inception_wordpress_container sh

exec_nginx:
	@echo "${BOLD}${GREEN}Connecting to nginx...${RESET}\n"
	@docker exec -it inception_nginx_container sh

# Logs
logs:
	@echo "${BOLD}${BLUE}Getting logs...${RESET}"
	@if [ ! -d "./logs" ]; then mkdir -p ./logs; fi
	@if [ ! -d "./logs/mariadb" ]; then mkdir -p ./logs/mariadb; fi
	@if [ ! -d "./logs/wordpress" ]; then mkdir -p ./logs/wordpress; fi
	@if [ ! -d "./logs/nginx" ]; then mkdir -p ./logs/nginx; fi
	@docker logs inception_mariadb_container > ./logs/mariadb/mariadb.log 2>&1
	@docker logs inception_wordpress_container > ./logs/wordpress/wordpress.log 2>&1
	@docker logs inception_nginx_container > ./logs/nginx/nginx.log 2>&1
	@echo "${BOLD}${GREEN}Logs saved to ./logs/[servicename]/[servicename].log${RESET}"

cleanlogs:
	@echo "${BOLD}${RED}Cleaning logs...${RESET}"
	@if [ -d "./logs" ]; then rm -rf ./logs; fi
	@echo "${BOLD}${GREEN}Logs cleaned.${RESET}"

relogs: cleanlogs logs

# ASCII Art
inception:
	@echo "${BOLD}${RED}▀██▀ ${ORANGE}         ${YELLOW}        ${GREEN}        ${BLUE}         ${INDIGO}  ▄   ${VIOLET} ██  ${RED}        ${ORANGE}         ${YELLOW}▄█▄ ${RESET}"
	@echo "${BOLD}${RED} ██  ${ORANGE}▄▄ ▄▄▄   ${YELLOW}  ▄▄▄▄  ${GREEN}  ▄▄▄▄  ${BLUE}▄▄▄ ▄▄▄  ${INDIGO}▄██▄  ${VIOLET}▄▄▄  ${RED}  ▄▄▄   ${ORANGE}▄▄ ▄▄▄   ${YELLOW}███ ${RESET}"
	@echo "${BOLD}${RED} ██  ${ORANGE} ██  ██  ${YELLOW}▄█   ▀▀ ${GREEN}▄█▄▄▄██ ${BLUE} ██▀  ██ ${INDIGO} ██   ${VIOLET} ██  ${RED}▄█  ▀█▄ ${ORANGE} ██  ██  ${YELLOW}▀█▀ ${RESET}"
	@echo "${BOLD}${RED} ██  ${ORANGE} ██  ██  ${YELLOW}██      ${GREEN}██      ${BLUE} ██    █ ${INDIGO} ██   ${VIOLET} ██  ${RED}██   ██ ${ORANGE} ██  ██  ${YELLOW} █  ${RESET}"
	@echo "${BOLD}${RED}▄██▄ ${ORANGE}▄██▄ ██▄ ${YELLOW} ▀█▄▄▄▀ ${GREEN} ▀█▄▄▄▀ ${BLUE} ██▄▄▄▀  ${INDIGO} ▀█▄▀ ${VIOLET}▄██▄ ${RED} ▀█▄▄█▀ ${ORANGE}▄██▄ ██▄ ${YELLOW} ▄  ${RESET}"
	@echo "${BOLD}${RED}     ${ORANGE}         ${YELLOW}        ${GREEN}        ${BLUE} ██      ${INDIGO}      ${VIOLET}     ${RED}        ${ORANGE}         ${YELLOW}▀█▀ ${RESET}"
	@echo "${BOLD}${RED}     ${ORANGE}         ${YELLOW}        ${GREEN}        ${BLUE}▀▀▀▀     ${INDIGO}      ${VIOLET}     ${RED}        ${ORANGE}         ${YELLOW}    ${RESET}"

# Music

zimmer:
	@echo "${BOLD}${RED}Playing Hans Zimmer - Time...${RESET}\n"
	@mpg123 Hans_Zimmer_Time.mp3 & > /dev/null 2>&1 || true

stopmusic:
	@pkill -f mpg123 > /dev/null 2>&1 || true
	@echo "${BOLD}${RED}Stopping music...${RESET}\n"

# Phony targets
.PHONY: all clean fclean re build_containers init_hosts exec_mariadb exec_wordpress exec_nginx logs cleanlogs relogs inception zimmer stopmusic
