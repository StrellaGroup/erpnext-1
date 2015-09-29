# Dockerized ERPNext

ERPNext 

# Dependecies

The image sets up following dependecies in container using the ERPNext setup script

- `MariaDB` as db 
- `Redis`
- `Cron`
- `Nginx` as http proxy
- `Supervisord` 

`Supervisord` is used to start up the dependecies in the container

# How to make the images

It is best to use the `Makefile` in the project with the following syntax

`make release`

One can override environment variables in the Makefile like

`make release USER=urbanandco`
