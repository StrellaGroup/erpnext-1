all: build

help:
	@echo ""
	@echo "ErpNext Menu"
	@echo ""
	@echo "  1. make build       - build the ErpNext image"
	@echo "  2. make release     - build the ErpNext image"
	@echo "  3. make quickstart  - start ErpNext"
	@echo "  4. make stop        - stop ErpNext"
	@echo "  5. make logs        - view logs"
	@echo "  6. make bash        - execute bash"
	@echo "  7. make passwords   - get the generated passwords during install"
	@echo "  8. make remove      - stop and remove the container"	

base:
	@docker pull urbanandco/ubuntu:14.04

build:
	@docker build --tag=${USER}/erpnext:latest .

rebuild: base build

release: rebuild
	@docker build --tag=${USER}/erpnext:$(shell cat VERSION) .

start:
	@echo "Starting ErpNext..."
	@docker run --name=erpnext -d -p 80:80 \
		${USER}/erpnext:latest >/dev/null
	@echo "Please wait while application is being bootstarted. This could take a while..."
	@echo "The application will be available at http://localhost:8080"
	@echo "Use 'make logs' to view log files of the container"

stop:
	@echo "Stopping ErpNext..."
	@docker stop erpnext >/dev/null
	
purge: stop
	@echo "Removing container..."
	@docker rm erpnext >/dev/null

logs:
	@docker logs -f erpnext
	
bash: 
	@docker exec -ti erpnext bash	
	
passwords:
	@docker exec -ti erpnext cat /root/frappe_passwords.txt	

remove:
	@docker rm erpnext