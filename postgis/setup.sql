-- Create database
DROP DATABASE Testfahrten;

CREATE DATABASE Testfahrten;

-- Enable PostGIS Extension
CREATE EXTENSION postgis;

-- Create Tables
CREATE TABLE public.sensors (
                id NUMERIC NOT NULL,
                type VARCHAR NOT NULL,
                model VARCHAR NOT NULL,
                comments VARCHAR,
                CONSTRAINT sensors_pk PRIMARY KEY (id)
);


CREATE TABLE public.vehicles (
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


CREATE SEQUENCE public.drives_drive_id_seq;

CREATE TABLE public.drives (
                id NUMERIC NOT NULL DEFAULT nextval('public.drives_drive_id_seq'),
                vehicle_id NUMERIC NOT NULL,
                speed_dectection_type NUMERIC(1) NOT NULL,
                acc1 NUMERIC NOT NULL,
                acc2 NUMERIC NOT NULL,
                gyr1 NUMERIC NOT NULL,
                gyr2 NUMERIC NOT NULL,
                comment VARCHAR,
                CONSTRAINT drives_pk PRIMARY KEY (id)
);


ALTER SEQUENCE public.drives_drive_id_seq OWNED BY public.drives.id;

CREATE SEQUENCE public.data_points_id_seq;

CREATE TABLE public.data_points (
                id INTEGER NOT NULL DEFAULT nextval('public.data_points_id_seq'),
                drive_id NUMERIC NOT NULL,
                position_type NUMERIC(1) NOT NULL,
                interpolated_point BOOLEAN,
                lat NUMERIC(7,5) NOT NULL,
                lng NUMERIC(7,5) NOT NULL,
                altitude NUMERIC(6,2),
                geom geometry,
                timestamp TIMESTAMP,
                speed NUMERIC(3) NOT NULL,
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


ALTER SEQUENCE public.data_points_id_seq OWNED BY public.data_points.id;

CREATE INDEX data_points_geom_gist
 ON public.data_points USING GIST
 ( geom );


-- Add Contraints
ALTER TABLE public.drives ADD CONSTRAINT sensors_drives_fk
FOREIGN KEY (acc1)
REFERENCES public.sensors (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.drives ADD CONSTRAINT sensors_drives_fk1
FOREIGN KEY (acc2)
REFERENCES public.sensors (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.drives ADD CONSTRAINT sensors_drives_fk2
FOREIGN KEY (gyr1)
REFERENCES public.sensors (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.drives ADD CONSTRAINT sensors_drives_fk3
FOREIGN KEY (gyr2)
REFERENCES public.sensors (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.drives ADD CONSTRAINT vehicles_drives_fk
FOREIGN KEY (vehicle_id)
REFERENCES public.vehicles (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.data_points ADD CONSTRAINT drives_data_points_fk
FOREIGN KEY (drive_id)
REFERENCES public.drives (id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

-- Add Dummy Data

INSERT INTO sensors(id, type, model, comments)
    VALUES (1, 'Accelerometer', 'NA', null);
INSERT INTO sensors(id, type, model, comments)
    VALUES (2, 'Accelerometer', 'NA', null);
INSERT INTO sensors(id, type, model, comments)
    VALUES (3, 'Gyroscope', 'NA', null);
INSERT INTO sensors(id, type, model, comments)
    VALUES (4, 'Gyroscope', 'NA', null);


INSERT INTO vehicles(id, vehicle_type, delta_above_ground, vehicle_height, vehicle_length, vehicle_width, brand, primary_fuel_tank_volume, primary_fuel_type, model, comments)
    VALUES (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    
INSERT INTO drives(id, vehicle_id, speed_dectection_type, acc1, acc2, gyr1, gyr2)
    VALUES (0, 0, 0, 1, 2, 3, 4);

CREATE OR REPLACE VIEW drive_stat AS 
  SELECT d.id,
    d.comment,
    to_char(
    (SELECT min(data_points.timestamp)
    FROM data_points),'YYYY-MM-DD HH24:MI:SS') AS "Beginning",
    max(p.lat) AS "Max Lat",
    min(p.lat) AS "Min Lat",
    max(p.lng) AS "Max Lng",
    min(p.lng) AS "Min Lng",
    max(p."timestamp") - min(p."timestamp") AS "Duration",
    min(p.altitude) AS "Min. Altitude",
    max(p.altitude) AS "Max. Altitude",
    max(p.speed) AS "Max. Speed"
   FROM drives d,
    data_points p
  WHERE p.drive_id = d.id
  GROUP BY p.drive_id, d.id;