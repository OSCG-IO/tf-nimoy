
DROP TABLE IF EXISTS flavors;
DROP VIEW  IF EXISTS v_images;
DROP TABLE IF EXISTS images;
DROP TABLE IF EXISTS image_types;

CREATE TABLE image_types (
  image_type    TEXT NOT NULL PRIMARY KEY,
  disp_name     TEXT NOT NULL,
  os            TEXT NOT NULL
);
INSERT INTO image_types VALUES ('el8',   'Rocky 8',      'linux');
INSERT INTO image_types VALUES ('ubu22', 'Ubuntu 22.04', 'linux');


CREATE TABLE images (
  image_type         TEXT  NOT NULL,
  provider           TEXT  NOT NULL,
  region             TEXT  NOT NULL,
  platform           TEXT  NOT NULL,
  is_default         SMALLINT NOT NULL,
  image_id           TEXT  NOT NULL,
  PRIMARY KEY (image_type, provider, region, platform)
);
INSERT INTO images VALUES ('ubu20', 'aws',   'us-east-2', 'amd', 1, 'ami-0996d3051b72b5b2c' );
INSERT INTO images VALUES ('cos8',  'openstack', 'nnj2', 'amd', 0, 'dbc325a0-cab8-4674-b8c2-d23711c26337');
INSERT INTO images VALUES ('ubu20', 'openstack', 'nnj2', 'amd', 1, 'caa7edd2-5f07-4382-a235-fde652e9894e');
INSERT INTO images VALUES ('ubu20', 'openstack', 'nnj3', 'amd', 1, '26994284-ed65-46c7-a147-3938f6a55434');
INSERT INTO images VALUES ('ubu18', 'gcp', 'us-central1-a', 'amd', 1, 'ubuntu-1804-bionic-v20210415');
INSERT INTO images VALUES ('ubu20', 'azure', 'eastus', 'amd', 1, 'Canonical:0001-com-ubuntu-server-focal:20_04-lts:20.04.202104150');


CREATE VIEW v_images AS
  SELECT t.os, t.image_type, t.disp_name, i.provider, i.region, 
         i.platform, i.is_default, i.image_id  
    FROM image_types t, images i
   WHERE i.image_type = t.image_type
  ORDER BY 1, 2, 3, 4, 5, 6;


CREATE TABLE flavors (
  provider      TEXT     NOT NULL REFERENCES providers(provider),
  family        TEXT     NOT NULL,
  flavor        TEXT     NOT NULL,
  size          TEXT     NOT NULL,
  v_cpu         INTEGER  NOT NULL,
  mem_gb        INTEGER  NOT NULL,
  das_gb        INTEGER  NOT NULL,
  price_hr      DECIMAL(9,3) NOT NULL,
  PRIMARY KEY (provider, flavor)
);
INSERT INTO flavors VALUES ('openstack', 'm1',  's',    'm1.small',      1,   2,    0, 0.020);
INSERT INTO flavors VALUES ('openstack', 'm1',  'm',    'm1.medium',     2,   4,    0, 0.040);
INSERT INTO flavors VALUES ('openstack', 'm1',  'l',    'm1.large',      4,   8,    0, 0.080);
INSERT INTO flavors VALUES ('openstack', 'm1', 'xl',    'm1.xlarge',     8,  16,    0, 0.160);
--INSERT INTO flavors VALUES ('openstack', 'm5d', 'm',    'm5d.medium',    1,   4, 37.5, 0.032);
--INSERT INTO flavors VALUES ('openstack', 'm5d', 'l',    'm5d.large',     2,   8,   75, 0.064);
--INSERT INTO flavors VALUES ('openstack', 'm5d', 'xl',   'm5d.xlarge',    4,  16,  150, 0.128);
--INSERT INTO flavors VALUES ('openstack', 'm5d', '2xl',  'm5d.2xlarge',   8,  32,  300, 0.256);
--INSERT INTO flavors VALUES ('openstack', 'm5d', '4xl',  'm5d.4xlarge',  16,  64,  600, 0.512);
--INSERT INTO flavors VALUES ('openstack', 'm5d', '8xl',  'm5d.8xlarge',  32, 128, 1200, 1.025);
--INSERT INTO flavors VALUES ('openstack', 'm5d', '16xl', 'm5d.16xlarge', 64, 256, 2400, 2.049);
INSERT INTO flavors VALUES ('aws',   't3',  's',    't3.small',      1,   2,    0, 0.025);
INSERT INTO flavors VALUES ('aws',   't3',  'm',    't3.medium',     2,   2,    0, 0.050);
--INSERT INTO flavors VALUES ('aws',   't3',  'l',    't3.large',      4,   2,    0, 0.100);
--INSERT INTO flavors VALUES ('aws',   't3', 'xl',    't3.xlarge',     8,   2,    0, 0.200);
--INSERT INTO flavors VALUES ('aws',   'm5d', 'l',    'm5d.large',     2,   8,   75, 0.096);
--INSERT INTO flavors VALUES ('aws',   'm5d', 'xl',   'm5d.xlarge',    4,  16,  150, 0.192);
--INSERT INTO flavors VALUES ('aws',   'm5d', '2xl',  'm5d.2xlarge',   8,  32,  300, 0.384);
--INSERT INTO flavors VALUES ('aws',   'm5d', '4xl',  'm5d.4xlarge',  16,  64,  600, 0.768);
--INSERT INTO flavors VALUES ('aws',   'm5d', '8xl',  'm5d.8xlarge',  32, 128, 1200, 1.536);
--INSERT INTO flavors VALUES ('aws',   'm5d', '16xl', 'm5d.16xlarge', 64, 256, 2400, 3.072);
INSERT INTO flavors VALUES ('gcp',   'f1', 's', 'f1-micro', 1, 1, 0, 0.0018662);
INSERT INTO flavors VALUES ('azure', 'f1', 's', 'Standard_B1s', 1, 1, 4, 0.0104);
INSERT INTO flavors VALUES ('kubernetes', 's', 's', 'custom resources', 1, 2, 0, 0.020);
INSERT INTO flavors VALUES ('kubernetes', 'm', 'm', 'custom resources', 2, 4, 0, 0.040);
INSERT INTO flavors VALUES ('kubernetes', 'l', 'l', 'custom resources', 4, 8, 0, 0.080);
INSERT INTO flavors VALUES ('kubernetes', 'xl', 'xl', 'custom resources', 8, 16, 0, 0.160);

