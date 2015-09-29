FROM urbanandco/ubuntu:14.04
MAINTAINER Istvan Orban <istvan.orban@gmail.com>

ENV ERPNEXT_USER="frappe" \
    ERPNEXT_HOME="/home/frappe" \
	ERPNEXT_SETUP_DIR="/var/cache/erpnext" \
	ERPNEXT_DB_DIR="/var/lib/mysql"
	
ENV	ERPNEXT_INSTALL_DIR="${ERPNEXT_HOME}/frappe-bench" \
	ERPNEXT_DATA_DIR="${ERPNEXT_HOME}/sites/site1.local"

RUN apt-get update \
	&& apt-get install -y sudo cron supervisor logrotate \
	&& rm -rf /var/lib/apt/lists/*	
	
COPY assets/setup/ ${ERPNEXT_SETUP_DIR}/
COPY assets/config/ ${ERPNEXT_SETUP_DIR}/config/

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]

RUN bash ${ERPNEXT_SETUP_DIR}/setup_frappe.sh --frappe-user=${ERPNEXT_USER} \
	&& service mysql stop \
	&& service nginx stop \
	&& service redis-server stop \
	&& service supervisor stop \
	&& update-rc.d -f mysql remove \
	&& update-rc.d -f nginx remove \
	&& update-rc.d -f redis-server remove \
	&& update-rc.d -f supervisor remove	

RUN rm /etc/nginx/sites-enabled/default	

WORKDIR ${ERPNEXT_INSTALL_DIR}
	
RUN bench setup supervisor \
	&& bench setup nginx \
	&& ln -s ${ERPNEXT_INSTALL_DIR}/config/supervisor.conf /etc/supervisor/conf.d/frappe.conf \
	&& ln -s ${ERPNEXT_INSTALL_DIR}/config/nginx.conf /etc/nginx/conf.d/frappe.conf \
	&& cp ${ERPNEXT_SETUP_DIR}/config/all.conf /etc/supervisor/conf.d


EXPOSE 80/tcp

VOLUME ["${ERPNEXT_DATA_DIR}", "${ERPNEXT_DB_DIR}"]

CMD ["app:start"]