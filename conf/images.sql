
DROP TABLE IF EXISTS flavors;
DROP VIEW  IF EXISTS v_images;
DROP TABLE IF EXISTS images;

CREATE TABLE images (
  image_type         TEXT  NOT NULL,
  platform           TEXT  NOT NULL,
  provider           TEXT  NOT NULL,
  region             TEXT  NOT NULL,
  image_id           TEXT  NOT NULL,
  PRIMARY KEY (image_type, platform, provider, region)
);
--INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'us-east-1',      'ami-');
--INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'us-east-2',      'ami-');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'us-west-2',      'ami-0dcca710aa1c4ec1f');
--INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'us-west-1',      'ami-');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'ca-central-1',   'ami-001d3fe2b6e361ca4');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'ap-southeast-2', 'ami-089af3b675897e7ef');
--INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'ap-southeast-1', 'ami-');
--INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'ap-south-1',     'ami-');
--INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'ap-east-1',      'ami-');
--INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'ap-northeast-3', 'ami-');
--INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'ap-northeast-1', 'ami-');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'eu-west-1',      'ami-05e1a1eacd63fd953');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'eu-central-1',   'ami-05bc49f954309391b');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'ap-northeast-3', 'ami-08cb3c6e2c4e52869');
--INSERT INTO images VALUES ('ubu22', 'arm', 'aws', '', 'ami-');


CREATE TABLE flavors (
  provider      TEXT     NOT NULL REFERENCES providers(provider),
  flavor        TEXT     NOT NULL,
  size          TEXT     NOT NULL,
  v_cpu         INTEGER  NOT NULL,
  mem_gb        INTEGER  NOT NULL,
  das_gb        INTEGER  NOT NULL,
  PRIMARY KEY (provider, flavor)
);
INSERT INTO flavors VALUES ('aws', 'l',    'm5d.large',     2,   8,   75);
INSERT INTO flavors VALUES ('aws', 'xl',   'm5d.xlarge',    4,  16,  150);
INSERT INTO flavors VALUES ('aws', '2xl',  'm5d.2xlarge',   8,  32,  300);
INSERT INTO flavors VALUES ('aws', '4xl',  'm5d.4xlarge',  16,  64,  600);
INSERT INTO flavors VALUES ('aws', '8xl',  'm5d.8xlarge',  32, 128, 1200);
INSERT INTO flavors VALUES ('aws', '16xl', 'm5d.16xlarge', 64, 256, 2400);
