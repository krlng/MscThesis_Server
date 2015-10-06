-- Create database
CREATE SCHEMA custom;

-- Enable PostGIS Extension
CREATE EXTENSION postgis;

-- Create Tables
CREATE TABLE custom.sensors (
                id NUMERIC NOT NULL,
                type VARCHAR NOT NULL,
                model VARCHAR NOT NULL,
                comments VARCHAR,
                CONSTRAINT sensors_pk PRIMARY KEY (id)
);


CREATE TABLE custom.vehicles (
                id NUMERIC NOT NULL,
                vehicle_type NUMERIC(1) NOT NULL,
                delta_above_ground NUMERIC(4,2) NOT NULL,
                vehicle_height NUMERIC(4,2) NOT NULL,
                vehicle_length NUMERIC(4,2) NOT NULL,
                vehicle_width NUMERIC(4,2) NOT NULL,
                brand VARCHAR NOT NULL,
                primary_fuel_tank_volume NUMERIC(6,2) NOT NULL,
                primary_fuel_type NUMERIC(1) NOT NULL,
                model VARCHAR NOT NULL,
                comments VARCHAR,
                CONSTRAINT vehicle_id PRIMARY KEY (id)
);


CREATE SEQUENCE custom.drives_drive_id_seq;

CREATE TABLE custom.drives (
                id NUMERIC NOT NULL DEFAULT nextval('custom.drives_drive_id_seq'),
                vehicle_id NUMERIC NOT NULL,
                speed_dectection_type NUMERIC(1) NOT NULL,
                acc1 NUMERIC NOT NULL,
                acc2 NUMERIC NOT NULL,
                gyr1 NUMERIC NOT NULL,
                gyr2 NUMERIC NOT NULL,
                comment VARCHAR,
                CONSTRAINT drives_pk PRIMARY KEY (id)
);


ALTER SEQUENCE custom.drives_drive_id_seq OWNED BY custom.drives.id;

CREATE SEQUENCE custom.data_points_id_seq;

CREATE TABLE custom.data_points (
                id INTEGER NOT NULL DEFAULT nextval('custom.data_points_id_seq'),
                drive_id NUMERIC NOT NULL,
                position_type NUMERIC(1) NOT NULL,
                interpolated_point BOOLEAN,
                lat NUMERIC(11,9) NOT NULL,
                lng NUMERIC(11,9) NOT NULL,
                altitude NUMERIC(5,1),
                geom geometry,
                timestamp TIMESTAMP,
                speed NUMERIC(4,1) NOT NULL,
                acc_x NUMERIC(9,6),
                acc_y NUMERIC(9,6),
                acc_z NUMERIC(9,6),
                gyr_x NUMERIC(9,6),
                gyr_y NUMERIC(9,6),
                gyr_z NUMERIC(9,6),
                acc2_x NUMERIC(9,6),
                acc2_y NUMERIC(9,6),
                acc2_z NUMERIC(9,6),
                gyr2_x NUMERIC(9,6),
                gyr2_y NUMERIC(9,6),
                gyr2_z NUMERIC(9,6),
                attr NUMERIC(9,6),
                CONSTRAINT drive_data_pkey PRIMARY KEY (id)
);

-- Table: csv_import

-- DROP TABLE csv_import;

CREATE TABLE custom.csv_import
(
  gid serial NOT NULL,
  date character varying(10),
  "time" character varying(15),
  latitude numeric(25,20),
  longitude numeric(25,20),
  geom geometry,
  "timestamp" timestamp with time zone,
  sensor_value_1 numeric(25,20),
  sensor_value_2 numeric(25,20),
  sensor_value_3 numeric(25,20),
  sensor_value_4 numeric(25,20),
  sensor_value_5 numeric(25,20),
  sensor_value_6 numeric(25,20),
  sensor_value_7 numeric(25,20),
  sensor_value_8 numeric(25,20),
  sensor_value_9 numeric(25,20),
  sensor_value_10 numeric(25,20),
  sensor_value_11 numeric(25,20),
  sensor_value_12 numeric(25,20),
  sensor_value_13 numeric(25,20),
  sensor_value_14 numeric(25,20),
  sensor_value_15 numeric(25,20),
  CONSTRAINT csv_import_pkey PRIMARY KEY (gid),
  CONSTRAINT enforce_dims_geom CHECK (st_ndims(geom) = 2),
  CONSTRAINT enforce_geotype_geom CHECK (geometrytype(geom) = 'POINT'::text OR geom IS NULL),
  CONSTRAINT enforce_srid_geom CHECK (st_srid(geom) = 4326)
)
WITH (
  OIDS=FALSE
);

-- Index: csv_import_geom_gist

-- DROP INDEX csv_import_geom_gist;

CREATE INDEX csv_import_geom_gist
  ON custom.csv_import
  USING gist
  (geom);




ALTER SEQUENCE custom.data_points_id_seq OWNED BY custom.data_points.id;

CREATE INDEX data_points_geom_gist
 ON custom.data_points USING GIST
 ( geom );


-- Add Contraints
ALTER TABLE custom.drives ADD CONSTRAINT sensors_drives_fk
FOREIGN KEY (acc1)
REFERENCES custom.sensors (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE custom.drives ADD CONSTRAINT sensors_drives_fk1
FOREIGN KEY (acc2)
REFERENCES custom.sensors (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE custom.drives ADD CONSTRAINT sensors_drives_fk2
FOREIGN KEY (gyr1)
REFERENCES custom.sensors (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE custom.drives ADD CONSTRAINT sensors_drives_fk3
FOREIGN KEY (gyr2)
REFERENCES custom.sensors (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE custom.drives ADD CONSTRAINT vehicles_drives_fk
FOREIGN KEY (vehicle_id)
REFERENCES custom.vehicles (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE custom.data_points ADD CONSTRAINT drives_data_points_fk
FOREIGN KEY (drive_id)
REFERENCES custom.drives (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

COMMIT;

-- Add Dummy Data

INSERT INTO custom.sensors(id, type, model, comments)
    VALUES (1, 'Accelerometer', 'NA', null);
INSERT INTO custom.sensors(id, type, model, comments)
    VALUES (2, 'Accelerometer', 'NA', null);
INSERT INTO custom.sensors(id, type, model, comments)
    VALUES (3, 'Gyroscope', 'NA', null);
INSERT INTO custom.sensors(id, type, model, comments)
    VALUES (4, 'Gyroscope', 'NA', null);


INSERT INTO custom.vehicles(id, vehicle_type, delta_above_ground, vehicle_height, vehicle_length, vehicle_width, brand, primary_fuel_tank_volume, primary_fuel_type, model, comments)
    VALUES (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    
INSERT INTO custom.drives(id, vehicle_id, speed_dectection_type, acc1, acc2, gyr1, gyr2)
    VALUES (0, 0, 0, 1, 2, 3, 4);

CREATE OR REPLACE VIEW custom.drive_stat AS 
  SELECT d.id,
    d.comment,
    to_char(
    (SELECT min(data_points.timestamp)
    FROM custom.data_points),'YYYY-MM-DD HH24:MI:SS') AS "Beginning",
    max(p.lat) AS "Max Lat",
    min(p.lat) AS "Min Lat",
    max(p.lng) AS "Max Lng",
    min(p.lng) AS "Min Lng",
    max(p."timestamp") - min(p."timestamp") AS "Duration",
    min(p.altitude) AS "Min. Altitude",
    max(p.altitude) AS "Max. Altitude",
    max(p.speed) AS "Max. Speed"
   FROM custom.drives d,
    custom.data_points p
  WHERE p.drive_id = d.id
  GROUP BY p.drive_id, d.id;

-- Function: custom.import_data(character varying)

-- DROP FUNCTION custom.import_data(character varying);
-- German Equidistant CSRI: EPSG:5243

CREATE OR REPLACE FUNCTION custom.import_data(src_text character varying)
  RETURNS void AS
$BODY$
     
    DECLARE
        drive_id numeric;
    BEGIN
    EXECUTE 'copy custom.csv_import(date,time,latitude,longitude,sensor_value_1,sensor_value_2,sensor_value_3,sensor_value_4,sensor_value_5,sensor_value_6,sensor_value_7,sensor_value_8,sensor_value_9,sensor_value_10,sensor_value_11,sensor_value_12,sensor_value_13,sensor_value_14,sensor_value_15)  
        FROM' || quote_literal(src_text) || 'DELIMITERS '','' CSV';
    
        drive_id := nextval('custom.drives_drive_id_seq');

        INSERT INTO custom.drives(id, vehicle_id, speed_dectection_type, acc1, acc2, gyr1, gyr2)
            VALUES (drive_id, 0, 0, 1, 2, 3, 4);

        INSERT INTO custom.data_points(
            id, drive_id, position_type, interpolated_point, lat, lng, altitude, 
            geom, "timestamp", speed, acc_x, acc_y, acc_z, gyr_x, gyr_y, 
            gyr_z, acc2_x, acc2_y, acc2_z, gyr2_x, gyr2_y, gyr2_z, attr)
        SELECT nextval('custom.data_points_id_seq') as "id", 
        drive_id, 
        0 as "position_type", 
        FALSE as "interpolated_point"
        , latitude as "lat", longitude as "lng", 
               sensor_value_2 as "altitude",
               ST_GeomFromText('POINT(' || longitude || ' ' || latitude || ')',4326) as "geom",
                to_timestamp(date || time || ':UTC', 'YYYY-MM-DDHH24:MI:SS:US') as "timestamp",
                sensor_value_1 as "speed", 
                sensor_value_4, sensor_value_5, sensor_value_6, 
               sensor_value_7, sensor_value_8, sensor_value_9, 
               sensor_value_10, sensor_value_11, sensor_value_12, 
               sensor_value_13, sensor_value_14, sensor_value_15,    
               sensor_value_3 as "attr"
          FROM custom.csv_import 
          WHERE latitude != 0 or longitude != 0;

          TRUNCATE custom.csv_import;
    END;
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


  SELECT lat,lng,
min("timestamp") as "time",
max(acc_z) as "max_acc_z",
min(acc_z) as "min_acc_z",
avg(acc_z) as "avg_acc_z",
max(acc_z)-min(acc_z) as "spread_acc_z",
variance(acc_z) as "var_acc_z"
 from custom.data_points group by lat, lng