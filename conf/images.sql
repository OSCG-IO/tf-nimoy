
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
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'af-south-1',     'ami-01b703fbb001d2dae');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'ap-east-1',      'ami-0932c85be19891d3e');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'ap-northeast-1', 'ami-0be7fb7ee5cff3b58');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'ap-northeast-2', 'ami-02a8e74d508493718');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'ap-northeast-3', 'ami-02079f0285e75a8be');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'ap-south-1',     'ami-0c66c4f14d217d16f');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'ap-southeast-1', 'ami-0d43b5bf95246b21e');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'ap-southeast-2', 'ami-08bd9ec03d33ea2d0');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'ap-southeast-3', 'ami-0f56e7c4be5859a54');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'ca-central-1',   'ami-04098e83837a4d344');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'eu-central-1',   'ami-05d8c3dc27d413c4b');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'eu-north-1',     'ami-0a59b7c4604a5398f');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'eu-south-1',     'ami-02d63f90e4e82e824');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'eu-west-1',      'ami-0aeaee482a16c861d');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'eu-west-2',      'ami-018542fa4c710a021');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'eu-west-3',      'ami-03fd6adde045f50ea');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'me-central-1',   'ami-0dd81b9d6625dddef');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'me-south-1',     'ami-086b910f354e11b9d');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'sa-east-1',      'ami-0b9adf9ed18361f50');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'us-east-1',      'ami-0f69dd1d0d03ad669');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'us-east-2',      'ami-0a9790c5a531163ee');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'us-west-1',      'ami-0ccc14818d8c254d6');
INSERT INTO images VALUES ('ubu22', 'arm', 'aws', 'us-west-2',      'ami-0db84aebfa8d17e23');


CREATE TABLE flavors (
  provider      TEXT     NOT NULL REFERENCES providers(provider),
  flavor        TEXT     NOT NULL,
  size          TEXT     NOT NULL,
  v_cpu         INTEGER  NOT NULL,
  mem_gb        INTEGER  NOT NULL,
  das_gb        INTEGER  NOT NULL,
  network_gbps  TEXT     NOT NULL,
  PRIMARY KEY (provider, flavor)
);
INSERT INTO flavors VALUES ('aws', 'm',    'c6gd.medium',    1,   2,   59, 'Up to 10');
INSERT INTO flavors VALUES ('aws', 'l',    'c6gd.large',     2,   4,  118, 'Up to 10');
INSERT INTO flavors VALUES ('aws', 'xl',   'c6gd.xlarge',    4,   8,  237, 'Up to 10');
INSERT INTO flavors VALUES ('aws', '2xl',  'c6gd.2xlarge',   8,  16,  474, 'Up to 10');
INSERT INTO flavors VALUES ('aws', '4xl',  'c6gd.4xlarge',  16,  32,  950, 'Up to 10');
INSERT INTO flavors VALUES ('aws', '8xl',  'c6gd.8xlarge',  32,  64, 1900, '12');
INSERT INTO flavors VALUES ('aws', '12xl', 'c6gd.12xlarge', 48,  96, 2850, '20');
INSERT INTO flavors VALUES ('aws', '16xl', 'c6gd.16xlarge', 64, 128, 3800, '25');
