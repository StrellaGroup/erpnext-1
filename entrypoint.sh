#!/bin/bash
set -e

appSetup () {
	cd  ${ERPNEXT_SETUP_DIR}
	./setup_frappe.sh --verbose --frappe-user=${ERPNEXT_USER}
	service mysql stop
	service nginx stop
	service redis-server stop
	service supervisor stop
	update-rc.d -f mysql remove
	update-rc.d -f nginx remove
	update-rc.d -f redis-server remove
	update-rc.d -f supervisor remove	
	rm /etc/nginx/sites-enabled/default
	
	if [ ! -d "${ERPNEXT_INSTALL_DIR}" ]; then
	  echo "Unable to set up Erp Next"
	  exit 1
	fi	
	
	# executed by --setup-production
	cd ${ERPNEXT_INSTALL_DIR}
	bench setup supervisor && bench setup nginx
	ln -s ${ERPNEXT_INSTALL_DIR}/config/supervisor.conf /etc/supervisor/conf.d/frappe.conf
	ln -s ${ERPNEXT_INSTALL_DIR}/config/nginx.conf /etc/nginx/conf.d/frappe.conf
	cp ${ERPNEXT_SETUP_DIR}/config/all.conf /etc/supervisor/conf.d
	
	rm -rf ${ERPNEXT_INSTALL_DIR}/sites/site1.local/private/backups && ln -s ${ERPNEXT_BACKUP_DIR} ${ERPNEXT_INSTALL_DIR}/sites/site1.local/private/backups 
}

if [ ! -f "/etc/supervisor/conf.d/frappe.conf" ]; then
  echo "Setting up ERP Next the first time"
  appSetup
fi
	
appStart () {
  # start supervisord
  exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
}

appBench () {
  if [[ -z ${1} ]]; then
    echo "Please specify the bench task to execute. See https://github.com/frappe/bench"
    return 1
  fi
  echo "Running frappe bench task..."
  sudo -HEu ${REDMINE_USER} bench $@
}

appHelp () {
  echo "Available options:"
  echo " app:start          - Starts the server (default)"
  echo " app:bench <task>    - Execute a rake task."
  echo " app:help           - Displays the help"
  echo " [command]          - Execute the specified linux command eg. bash."
}

case ${1} in
  app:start)
    appStart
    ;;
  app:bench)
    shift 1
    appBench $@
    ;;
  app:help)
    appHelp
    ;;
  *)
    if [[ -x ${1} ]]; then
      ${1}
    else
      prog=$(which ${1})
      if [[ -n ${prog} ]] ; then
        shift 1
        $prog $@
      else
        appHelp
      fi
    fi
    ;;
esac

exit 0