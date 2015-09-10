sudo apt-get update
sudo apt-get install git
curl -sSL https://get.docker.com/ | sh


# Create Image
docker build -t nico/postgis .

# Create Container
docker run --rm -P --name pg_test nico/postgis  
SET IP boot2docker ip
docker port pg_test
psql -h 192.168.59.103 -p 49160 -d docker -U docker --password


docker inspect geoserverdeploy_db_1 | grep IPAddress
docker exec -it "id of running container" bash
echo "host    all             all             0.0.0.0/0               trust"  >> /etc/postgresql/9.3/main/pg_hba.conf
# then restart container

psql -h 192.168.59.103 -U docker -p 25432 -l  # list all available databases
psql -h 192.168.59.103 -U docker -p 25432  postgres # Connect to database postgres





 OUTPUT="$(boot2docker ip)"   
 docker port pg_test


 docker run --rm -P --name pg_test nico/postgis  
docker run --rm -p "25432:5432"  -v /Users/nicokreiling/thesis/05/pgis_kartoza_data:/var/lib/postgresql --name pgis nico/postgis    


docker run -d -p "8080:80" -v /Users/nicokreiling/thesis/05/geoserver_data:/opt/geoserver/data_dir --link pgis:pgis --name geos kartoza/geoserver
docker run -d -p "8080:8080" --name geos3 kartoza/geoserver

Working: 
docker run --rm -p "25432:5432"  --name pgis nico/postgis    
docker run -d -v /var/lib/geoserver:/opt/geoserver/data_dir busybox
docker run --rm -it -p "8080:8080" --name geos3 --volumes-from mad_noyce --link pgis kartoza/geoserver

dm ip default # GET ip adress
http://192.168.99.100:8080/geoserver/web/