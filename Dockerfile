FROM urbanandco/ubuntu:14.04
MAINTAINER Istvan Orban <istvan.orban@gmail.com>

ENV ERPNEXT_USER="frappe" \
    ERPNEXT_HOME="/home/frappe" \
	ERPNEXT_SETUP_DIR="/var/cache/erpnext" \
	ERPNEXT_DB_DIR="/var/lib/mysql"
	
ENV	ERPNEXT_INSTALL_DIR="${ERPNEXT_HOME}/frappe-bench" \
	ERPNEXT_BACKUP_DIR="${ERPNEXT_HOME}/data/sites/site1.local/backups"

RUN apt-get update \
	&& apt-get install -y sudo cron supervisor logrotate \
	&& rm -rf /var/lib/apt/lists/*	

RUN useradd -ms /bin/bash ${ERPNEXT_USER} \
	&& mkdir -p ${ERPNEXT_BACKUP_DIR} \
	&& chown -R ${ERPNEXT_USER}:${ERPNEXT_USER} ${ERPNEXT_HOME}
	
COPY assets/setup/ ${ERPNEXT_SETUP_DIR}/
COPY assets/config/ ${ERPNEXT_SETUP_DIR}/config/

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]

EXPOSE 80/tcp

VOLUME ["${ERPNEXT_BACKUP_DIR}", "${ERPNEXT_DB_DIR}"]

CMD ["app:start"]