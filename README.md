# PrinterLogic 2019 Summit Workshop App

Simple Laravel-based (PHP) application for use in the PrinterLogic 2019 Developer Summit workshop.
## Installation and Development

### 1. Clone repo
Use your favorite git tool to clone the pl-summit-2019 repository

### 2. Spin up docker
Run the following command to spin up your environment and provision it for the first time:
```
docker-compose up -d
```
***NOTE** Running things for the first time takes several minutes.  Any time you rebuild
(e.g. adding `--build` to the `docker-compose up -d` command or running `docker-compose build`) please expect to wait
a bit.*

##### How to tell when things are running?
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

### Reset database and sync files
If you would also like to clobber your entire database and start from scratch, first delete the directory
`.docker-storage/db` and then complete the same steps in the "File sync only" section above.

## Unit Tests
Unit tests are run by using a docker-compose file specifically set up for unit tests.  When running locally, there is
an additional composer file that is also merged to add some additional convenience for local environments.  These
compose files are found in the `.docker-config` directory.  To run unit tests locally simply run the following command
from the project root
```bash
docker-compose -f .docker-config/tests.docker-compose.yaml -f .docker-config/local.tests.docker-compose.yaml run users
```
***NOTE:** You may be tempted to create a shortcut file for this command.  That is certainly encouraged, but please
do not commit that file here.  It is good practice for our engineers to become accustomed to how docker-compose
commands work.  Running all of these docker-compose commands is an important part of the learning process.*

## Other Notes

### Run Migrations on all Instances in Cloud
In the cloud deployment of this microservice, each customer instance has its own DB schema. Migrations need to be run
on each of these. To do so, there is an artisan script that should be executed from the user microservice project root. 
A specific siteId can be included as the first parameter, or no parameters will queue all instances:

```bash
php artisan printerlogic:queue-migrations
```

### API Information and Endpoints
Documentation on the API can be found in Postman under the collection "User Microservice".  
