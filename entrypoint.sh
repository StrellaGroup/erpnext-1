#!/bin/bash
set -e

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