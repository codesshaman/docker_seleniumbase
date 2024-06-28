name = SeleniumBase

CONTAINER_NAME := $(shell awk -F '=' '/CONTAINER_NAME/ {print $$2}' .env)
APPNAME:=$(word 2, $(MAKECMDGOALS))
NO_COLOR=\033[0m		# Color Reset
COLOR_OFF='\e[0m'       # Color Off
OK_COLOR=\033[32;01m	# Green Ok
ERROR_COLOR=\033[31;01m	# Error red
WARN_COLOR=\033[33;01m	# Warning yellow
GREEN='\e[1;32m'        # Green
YELLOW='\e[1;33m'       # Yellow

all:
	@printf "Launch configuration ${name}...\n"
	@docker-compose -f ./docker-compose.yml up -d

help:
	@echo -e "$(OK_COLOR)==== All commands of ${name} configuration ====$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)- make				: Launch configuration"
	@echo -e "$(WARN_COLOR)- make build			: Building configuration"
	@echo -e "$(WARN_COLOR)- make connect			: Connect to the container"
	@echo -e "$(WARN_COLOR)- make down			: Stopping configuration"
	@echo -e "$(WARN_COLOR)- make env			: Create .env file"
	@echo -e "$(WARN_COLOR)- make ps			: View configuration"
	@echo -e "$(WARN_COLOR)- make re			: Rebuild configuration"
	@echo -e "$(WARN_COLOR)- make run <script>		: Launch script"
	@echo -e "$(WARN_COLOR)- make push			: Push configuration to git"
	@echo -e "$(WARN_COLOR)- make clean			: Cleaning configuration$(NO_COLOR)"

build:
	@printf "$(YELLOW)==== Building configuration ${name}	... ====$(NO_COLOR)\n"
	# @docker-compose -f ./docker-compose.yml up -d --build
	@bash ./bash/build.sh


connect:
	@printf "$(YELLOW)==== Connect to the ${name} container... ====$(NO_COLOR)\n"
	@docker exec -it ${CONTAINER_NAME} bash

down:
	@printf "$(ERROR_COLOR)==== Stopping configuration ${name}... ====$(NO_COLOR)\n"
	@docker-compose -f ./docker-compose.yml down

env:
	@printf "Create .env...\n"
	@bash ./bash/environment.sh

ps:
	@printf "$(BLUE)==== View configuration ${name}... ====$(NO_COLOR)\n"
	@docker-compose -f ./docker-compose.yml ps

push:
	@bash ./bash/push.sh

re:
	@printf "$(OK_COLOR)==== Rebuild configuration ${name}... ====$(NO_COLOR)\n"
	@docker-compose -f ./docker-compose.yml up -d --no-deps --build

run:
	@printf "$(OK_COLOR)==== Starting the script ${name} ====$(NO_COLOR)\n"
	@$(eval args := $(words $(filter-out --,$(MAKECMDGOALS))))
	@if [ "${args}" -eq 2 ]; then \
		echo "$(OK_COLOR) Launch script ${APPNAME}$(NO_COLOR)\n"; \
		bash ./bash/run.sh ${APPNAME}; \
	elif [ "${args}" -gt 2 ]; then \
		echo "$(ERROR_COLOR)The script name must not contain spaces!$(NO_COLOR)\n"; \
	else \
		echo "$(ERROR_COLOR)Enter the script name!$(NO_COLOR)\n"; \
	fi

clean: down
	@printf "$(ERROR_COLOR)==== Cleaning configuration ${name}... ====$(NO_COLOR)\n"
	@yes | docker system prune -a

fclean:
	@printf "$(ERROR_COLOR)==== Total clean of all configurations docker ====$(NO_COLOR)\n"
	# Uncommit if necessary:
	# @docker stop $$(docker ps -qa)
	# @docker system prune --all --force --volumes
	# @docker network prune --force
	# @docker volume prune --force

.PHONY	: all help build connect down re ps push clean fclean
