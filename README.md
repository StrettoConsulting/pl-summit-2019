# PrinterLogic 2019 Summit Workshop App

Simple Laravel-based (PHP) application for use in the PrinterLogic 2019 Developer Summit workshop.
## Installation and Development

### 1. Clone repo
Use your favorite git tool to clone the pl-summit-2019 repository

### 2. Spin up docker
Run the following command from the project root to spin up your environment:
```
docker-compose up -d
```
***NOTE** Running things for the first time takes several minutes as composer packages are installed and built.  Any time you rebuild
(e.g. adding `--build` to the `docker-compose up -d` command or running `docker-compose build`) please expect to wait
a bit.*

##### How to tell when things are running
After running `docker-compose up -d` you can monitor the progress of startup by running `docker-compose ps`.  Under the
"state" column you will see the state of services.  If any say "Exit" that means it failed to start.  If you see
"starting" it is still spinning up so be patient.  If you see "healthy" you should be good to go.  If you see
"unhealthy" then the container is running, but doesn't seem to be responding correctly.
Example output for `app`:
```bash
λ docker-compose ps
The system cannot find the path specified.
         Name                       Command                  State                                  Ports
-------------------------------------------------------------------------------------------------------------------------------------
pl-summit-2019_app_1     /var/www/app/.docker-confi ...   Up (healthy)   0.0.0.0:443->443/tcp, 0.0.0.0:80->80/tcp, 9000/tcp, 9001/tcp
pl-summit-2019_mysql_1   docker-entrypoint.sh mysqld      Up (healthy)   0.0.0.0:13306->3306/tcp
```
##### Monitoring progress or logs
Especially when starting up for the first time, reprovisioning, or using the `--build` option with `docker-compose`,
it will take a good while for things to fully finish.  Until you see `docker-compose ps` show `healthy` for the "State"
it is probably still provisioning things.  You can follow progress of this (or just monitor the logs for fun) by
running
```bash
docker-compose logs -f app
```
Where `-f` means "follow" (real-time scrolling as logs come in) and `app` is the service to monitor logs for.

### 3. Browser Access
Once you see a state of `healthy` showing for all services, you should be able to access the site by
going to <https://summit.pl-local.com/>
