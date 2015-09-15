# Installation
_Install pre-requireties_
```shell
sudo apt-get update
sudo apt-get install git
curl -sSL https://get.docker.com/ | sh
```

_Setup project_
```shell
git clone https://github.com/nik-ffm/MscThesis_Server.git
docker-compose up
```

Get the IP of your machine using `bocker-machine ip default` and open it in the browser. You will the an overview page telling you about all available services

# Development Comments
## Manual builds
docker build -t nico/postgis .

## Create Container
docker run --rm -P --name pg_test nico/postgis  
SET IP boot2docker ip
docker port pg_test
psql -h 192.168.59.103 -p 49160 -d docker -U docker --password

## Change security settings of GeoServer
```
docker inspect geoserverdeploy_db_1 | grep IPAddress
docker exec -it "id of running container" bash
echo "host    all             all             0.0.0.0/0               trust"  >> /etc/postgresql/9.3/main/pg_hba.conf
```
then restart container

```psql
psql -h 192.168.59.103 -U docker -p 25432 -l  # list all available databases
psql -h 192.168.59.103 -U docker -p 25432  postgres # Connect to database postgres
```