### Prerequisites

[Docker](https://www.docker.com/)

[Docker Compose](https://docs.docker.com/compose/overview/)

### Container Configuration

#### ports:

```
ports:
      - "3307:3307"   mariadb-port
      - "8000:8000"   webserver-port
      - "11000:11000" redis-cache
      - "12000:12000" redis-queue
      - "13000:13000" redis-socketio
      - "9000:9000"   socketio-port
      - "6787:6787"   file-watcher-port
```

#### volumes:

```
volumes:
     - frappe-frappe-bench-workdir:/home/frappe/frappe-bench:rw
     - frappe-mariadb-conf:/etc/mysql/conf.d
     - frappe-redis-cache-conf:/etc/conf.d/
     - frappe-redis-queue-conf:/etc/conf.d/
     - frappe-redis-socketio-conf:/etc/conf.d/
```
Exposes a directory inside the host to the container.

#### links:

```
links:
      - redis-cache
      - redis-queue
      - redis-socketio
      - mariadb
```

Links allow you to define extra aliases by which a service is reachable from another service.

#### depends_on:

```
depends_on:
      - mariadb
      - redis-cache
      - redis-queue
      - redis-socketio
```
Express dependency between services, which has two effects:

### Installation

#### 1. Installation Pre-requisites

- Install [Docker](https://docs.docker.com/engine/installation) Community Edition

- Install [Docker Compose](https://docs.docker.com/compose/install/) (only for Linux users). Docker for Mac, Docker for Windows, and Docker Toolbox include Docker Compose

#### 2. Build the container and install bench

* Clone this repo and change your working directory to frappe_docker
	
            ./dbench init_volumes

* Build the container and install bench inside the container.

		docker-compose build
            docker-compose up -d


#### Basic Usage
##### Make sure your current directory is frappe_docker
1.	First time setup 
 
		./dbench init_frappe

3.	Command to be executed everytime after starting your containers

		Skip this step
                  ./dbench -s

4.	Command to enter your container  

		docker exec -it frappe bash 

5.	All bench commands can also be directly run from the host machine by using dbench. For instance ```bench start``` can be executed by running ```./dbench -c start```. Just preface the option with <b>./dbench -c</b>. For more information on dbench run the command ```./dbench -h```.

The default username is "Administrator" and password is what you set when you created the new site.

## Based on

* [frappe_docker](https://github.com/frappe/frappe_docker)
* https://github.com/ierturk/frappe_docker/tree/master/frappe-bench

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
