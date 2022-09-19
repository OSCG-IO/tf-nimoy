DROP TABLE IF EXISTS flavors;

DROP VIEW  IF EXISTS v_images;
DROP TABLE IF EXISTS images;
DROP TABLE IF EXISTS image_types;

DROP VIEW  IF EXISTS v_locations;
DROP TABLE IF EXISTS locations;
DROP VIEW  IF EXISTS v_regions;
DROP TABLE IF EXISTS regions;
DROP TABLE IF EXISTS providers;

CREATE TABLE providers (
  provider      TEXT     NOT NULL PRIMARY KEY,
  sort_order    SMALLINT NOT NULL,
  status        TEXT     NOT NULL,
  short_name    TEXT     NOT NULL,
  disp_name     TEXT     NOT NULL,
  image_file    TEXT     NOT NULL
);
INSERT INTO providers VALUES ('aws',     1, 'prod', 'AWS',         'Amazon Web Services',   'aws.png');
INSERT INTO providers VALUES ('gcp',     2, 'test', 'GCP',         'Google Cloud Platform', 'gcp.png');
INSERT INTO providers VALUES ('azure',   3, 'test', 'Azure',       'Microsoft Azure',       'azure.png');

geos (
  geo    TEXT     NOT NULL,
  geo_nm TEXT     NOT NULL
);
INSERT INTO geos VALUES ('na', 'North America');
INSERT INTO geos VALUES ('sa', 'South America');
INSERT INTO geos VALUES ('eu', 'Europe');
INSERT INTO geos VALUES ('ap', 'Asia Pacific');
INSERT INTO geos VALUES ('me', 'Middle East');
INSERT INTO geos VALUES ('au', 'Australia');
INSERT INTO geos VALUES ('af', 'Africa');

countries (
  country      TEXT     NOT NULL PRIMARY KEY,
  geo          TEXT     NOT NULL RFERENCES geos(geo),
  contry_nm    TEXT     NOT NULL
);
INSERT INTO countries VALUES ('us', 'na', 'Unites States');
INSERT INTO countries VALUES ('ca', 'na', 'Canada');
INSERT INTO countries VALUES ('br', 'sa', 'Brazil');
INSERT INTO countries VALUES ('ir', 'eu', 'Ireland');
INSERT INTO countries VALUES ('gb', 'eu', 'Great Britain');
INSERT INTO countries VALUES ('de', 'eu', 'Germany');
INSERT INTO countries VALUES ('fr', 'eu', 'France');
INSERT INTO countries VALUES ('it', 'eu', 'Italy');
INSERT INTO countries VALUES ('se', 'eu', 'Sweden');
INSERT INTO countries VALUES ('bh', 'me', 'Bahrain');
INSERT INTO countries VALUES ('ae', 'me', 'UAE);
INSERT INTO countries VALUES ('au', 'au', 'Australia');
INSERT INTO countries VALUES ('za', 'af', 'South Africa');
INSERT INTO countries VALUES ('jp', 'ap', 'Japan');
INSERT INTO countries VALUES ('hk', 'ap', 'Hong Kong');
INSERT INTO countries VALUES ('sg', 'ap', 'Singapore');
INSERT INTO countries VALUES ('kr', 'ap', 'South Korea');
INSERT INTO countries VALUES ('id', 'ap', 'Indonesia');
INSERT INTO countries VALUES ('', '');
INSERT INTO countries VALUES ('', '');

CREATE TABLE locations (
  location      TEXT     NOT NULL PRIMARY KEY,
  location_nm   TEXT     NOT NULL,
  country       TEXT     NOT NULL REFRENCES countries(country),
  lattitude     FLOAT    NOT NULL,
  longitude     FLOAT    NOT NULL
);
INSERT INTO cities VALUES ('iad', 'Northen Virginia',   'us',  38.951944,  -77.448055);
INSERT INTO cities VALUES ('cmh', 'Ohio',               'us',  39.995000,  -82.889166);
INSERT INTO cities VALUES ('pdt', 'Oregon',             'us',  45.694765, -118.843008);
INSERT INTO cities VALUES ('sfo', 'Northen California', 'us',  37.621312, -122.378955);
INSERT INTO cities VALUES ('atl', 'Atlanta',            'us',  33.640411,  -84.419853);
INSERT INTO cities VALUES ('bos', 'Boston',             'us',  42.366978,  -71.022362);
INSERT INTO cities VALUES ('chi', 'Chicago',            'us',  41.978611,  -87.904724);
INSERT INTO cities VALUES ('dfw', 'Dallas',             'us',  32.848152,  -96.851349);
INSERT INTO cities VALUES ('den', 'Denver',             'us',  39.856094, -104.673737);
INSERT INTO cities VALUES ('iah', 'Houston',            'us',  36.942810, -109.707108);
INSERT INTO cities VALUES ('mci', 'Kansas City',        'us',  39.297010,  -94.690370);
INSERT INTO cities VALUES ('den', 'Denver'              'us',  39.849312, -104.673828);
INSERT INTO cities VALUES ('lax', 'Los Angeles',        'us',  33.942791, -118.410042);
INSERT INTO cities VALUES ('las', 'Las Vegas',          'us',  36.086010, -115.153969);
INSERT INTO cities VALUES ('mia', 'Miami',              'us',  25.795865,  -80.287045);
INSERT INTO cities VALUES ('msp', 'Minneapolis',        'us',  44.884358,  -93.214075);
INSERT INTO cities VALUES ('jfk', 'New York City',      'us',  40.641766,  -73.780968);
INSERT INTO cities VALUES ('phl', 'Philadelphia',       'us',  39.874193,  -75.247245);
INSERT INTO cities VALUES ('phx', 'Phoenix',            'us',  33.437269, -112.007788);
INSERT INTO cities VALUES ('pdx', 'Portland',           'us',  45.587555, -122.593333);
INSERT INTO cities VALUES ('sea', 'Seattle',            'us',  47.443546, -122.301659);
INSERT INTO cities VALUES ('mtl', 'Montreal',           'ca',  45.508888,  -73.561668);
INSERT INTO cities VALUES ('gru', 'Sao Paulo',          'br', -23.533773,  -46.625290);
INSERT INTO cities VALUES ('dub', 'Ireland',            'ir',  53.426448,   -6.249910);
INSERT INTO cities VALUES ('lhr', 'London',             'gb',  51.458881,   -0.470008);
INSERT INTO cities VALUES ('fra', 'Frankfurt',          'de',  50.037933,    8.562152);
INSERT INTO cities VALUES ('arn', 'Stockholm',          'se',  59.649762,   17.923781);
INSERT INTO cities VALUES ('cdg', 'Paris',              'fr',  49.009724,    2.547778);
INSERT INTO cities VALUES ('mxp', 'Milan',              'it',  45.628611,    8.723611);
INSERT INTO cities VALUES ('bah', 'Bahrain',            'bh',  26.269712,   50.625987);
INSERT INTO cities VALUES ('auh', 'UAE',                'ae',  24.432928,   54.644539);
INSERT INTO cities VALUES ('syd', 'Sydney',             'au', -33.939922,  151.175276);
INSERT INTO cities VALUES ('cpt', 'Cape Town',          'za', -33.972555,   18.601944);
INSERT INTO cities VALUES ('nrt', 'Tokyo',              'jp',  35.771987,  140.392855); 
INSERT INTO cities VALUES ('itm', 'Osaka',              'jp',  34.433855,  135.226333);
INSERT INTO cities VALUES ('cgk', 'Indonesia',          'id',  -6.125567,  106.655897);
INSERT INTO cities VALUES ('hkg', 'Hong Kong',          'hk',  22.308046,  113.918480);
INSERT INTO cities VALUES ('icn', 'Seoul',              'kr',  37.460191,  126.440696);
INSERT INTO cities VALUES ('sin', 'Singapore',          'sg',   1.420181,  103.864555);
INSERT INTO cities VALUES ('   ', '                     '  ', );


CREATE TABLE regions (
  provider      TEXT       NOT NULL REFERENCES providers(provider),
  location      TEXT       NOT NULL REFERENCES locations(location),
  region        TEXT       NOT NULL,
  avail_zones   INTEGER    NOT NULL,
  local_zones   INTEGER    NOT NULL,
  PRIMARY KEY (provider, region)
);
INSERT INTO regions VALUES ('aws', 'iad', 'us-east-1',    6, 9);
INSERT INTO regions VALUES ('aws', 'cmh', 'us-east-2',    3, 0);
INSERT INTO regions VALUES ('aws', 'sfo', 'us-west-1',    3, 0);
INSERT INTO regions VALUES ('aws', 'pdt', 'us-west-2',    4, 5);
INSERT INTO regions VALUES ('aws', 'mtl', 'ca-central-1', 3, 0);
INSERT INTO regions VALUES ('aws', '', '');
INSERT INTO regions VALUES ('aws', '', '');
INSERT INTO regions VALUES ('aws', '', '');
INSERT INTO regions VALUES ('aws', '', '');
INSERT INTO regions VALUES ('aws', '', '');
INSERT INTO regions VALUES ('aws', '', '');
INSERT INTO regions VALUES ('aws', '', '');
INSERT INTO regions VALUES ('aws', '', '');
INSERT INTO regions VALUES ('aws', '', '');
INSERT INTO regions VALUES ('aws', '', '');


CREATE VIEW v_regions AS
  SELECT m.country, m.area, m.disp_name as metro_name, m.metro, 
         r.provider, r.region,
	 r.lattitude as rgn_latt, r.longitude as rgn_long
    FROM regions r, metros m
   WHERE r.metro = m.metro
 ORDER BY 1, 2, 4, 5, 6;


CREATE TABLE locations (
  provider      TEXT       NOT NULL REFERENCES providers(provider),
  region        TEXT       NOT NULL,
  location      TEXT       NOT NULL,
  is_preferred  SMALLINT   NOT NULL,
  PRIMARY KEY (provider, region, location)
);
INSERT INTO locations VALUES ('aws',   'us-east-1', 'us-east-1a', 0);
INSERT INTO locations VALUES ('aws',   'us-east-1', 'us-east-1b', 0);
INSERT INTO locations VALUES ('aws',   'us-east-1', 'us-east-1c', 0);
INSERT INTO locations VALUES ('aws',   'us-east-1', 'us-east-1d', 1);
INSERT INTO locations VALUES ('aws',   'us-east-1', 'us-east-1e', 1);
INSERT INTO locations VALUES ('aws',   'us-east-1', 'us-east-1f', 1);
INSERT INTO locations VALUES ('aws',   'us-east-2', 'us-east-2a', 0);
INSERT INTO locations VALUES ('aws',   'us-east-2', 'us-east-2b', 0);
INSERT INTO locations VALUES ('aws',   'us-east-2', 'us-east-2c', 1);
INSERT INTO locations VALUES ('aws',   'us-east-2', 'us-east-2d', 1);


CREATE VIEW v_locations AS
  SELECT m.country, m.area, m.disp_name as metro_name, m.metro, 
         r.provider, r.region, l.location, l.is_preferred,
	 r.lattitude as rgn_latt, r.longitude as rgn_long,
	 l.lattitude as loc_latt, l.longitude as loc_long, l.town
    FROM locations l, regions r, metros m
   WHERE l.provider = r.provider
     AND l.region   = r.region
     AND r.metro    = m.metro
 ORDER BY 4, 5, 6, 7;


CREATE TABLE image_types (
  image_type    TEXT NOT NULL PRIMARY KEY,
  disp_name     TEXT NOT NULL,
  os            TEXT NOT NULL
);
INSERT INTO image_types VALUES ('cos7',  'CentOS 7',     'linux');
INSERT INTO image_types VALUES ('cos8',  'CentOS 8',     'linux');
INSERT INTO image_types VALUES ('ubu18', 'Ubuntu 18.04 LTS', 'linux');
INSERT INTO image_types VALUES ('ubu20', 'Ubuntu 20.04 LTS', 'linux');


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


INSERT INTO projects VALUES ('hub',0, 0, 'hub', 0, 'https://github.com/pgsql-io/pgsql-io','',0,'','','');

INSERT INTO projects VALUES ('pg', 1, 5432, 'hub', 1, 'https://postgresql.org/download',
 'PostgreSQL', 0, 'postgresql.png', 'Advanced RDBMS', 'https://postgresql.org');

INSERT INTO projects VALUES ('mongodb', 10, 27017, 'hub', 1, 'https://github.com/mongodb/mongo/releases', 
  'MongoDB', 0, 'mongodb.png', 'Document Database', 'https://mongodb.org');

INSERT INTO projects VALUES ('debezium', 10, 8080, 'kafka', 1, 'https://debezium.io/releases/1.2/', 
  'Debezium', 0, 'debezium.png', 'Stream DB Changes', 'https://debezium.io');

INSERT INTO projects VALUES ('kafka', 10, 9092, 'zookeeper', 1, 'https://kafka.apache.org/downloads', 
  'Kafka', 0, 'kafka.png', 'Streaming Platform', 'https://kafka.apache.org');

INSERT INTO projects VALUES ('mariadb', 10, 3306, 'hub', 0, 'https://mariadb.org/downloads', 
  'MariaDB', 0, 'mariadb.png', 'MySQL Succesor', 'https://mariadb.org');

INSERT INTO projects VALUES ('sqlsvr', 10, 1433, 'hub', 0, 'https://www.microsoft.com/en-us/sql-server/sql-server-2019',
  'SQL Server', 0, 'sqlsvr.png', 'Microsoft Proprietary', 'https://www.microsoft.com/en-us/sql-server/sql-server-2019');

INSERT INTO projects VALUES ('sybase', 10, 1234, 'hub', 0, 'https://sap.com/products/sybase-ase.html', 
  'Sybase', 0, 'sybase.png', 'Sybase ASE', 'https://sap.com/products/sybase-ase.html');

INSERT INTO projects VALUES ('hadoop', 10, 0, 'hub', 1, 'https://hadoop.apache.org/releases.html',
  'hadoop', 0, 'hadoop.png', 'Hadoop', 'https://hadoop.apache.org');

INSERT INTO projects VALUES ('zookeeper', 10, 2181, 'hub', 1, 'https://zookeeper.apache.org/releases.html#releasenotes',
  'zookeeper', 0, 'zookeeper.png', 'Distributed Key-Store for HA', 'https://zookeeper.apache.org');

INSERT INTO projects VALUES ('prestosql', 10, 1515, 'hub', 1, 'https://github.com/prestosql/presto/releases',
  'Presto', 0, 'presto.png', 'Data Lake Platform', 'https://github.com/prestosql/presto');

INSERT INTO projects VALUES ('es', 10, 9200, 'hub', 1, 'https://www.elastic.co/downloads/elasticsearch',
  'ElasticSearch', 0, 'elastic-search.png', 'Search Engine', 'https://github.com/elastic/elasticsearch#elasticsearch');

INSERT INTO projects VALUES ('kibana', 9, 5601, 'elasticsearch', 1, 'https://www.elastic.co/downloads/kibana',
  'kibana', 0, 'kibana.png', 'Window into the Elastic Stack', 'https://github.com/elastic/kibana#kibana');

INSERT INTO projects VALUES ('kubernetes', 10, 8000, 'hub', 1, 'https://github.com/kubernetes/kubernetes/releases',
  'Kubernetes',  0, 'kubernetes.png', 'Kubernetes', 'https://github.com/kubernetes/kubernetes');

INSERT INTO projects VALUES ('omnidb', 10, 8000, 'hub', 1, 'https://github.com/omnidb/omnidb/releases',
  'OmniDB',  0, 'omnidb.png', 'RDBMS Admin', 'https://github.com/omnidb/omnidb');

INSERT INTO projects VALUES ('pgadmin', 10, 80, 'hub', 1, 'https://github.com/postgres/pgadmin4/releases',
  'pgAdmin 4',  0, 'pgadmin4.png', 'Admin & Dev Platform', 'https://github.com/postgres/pgadmin4');

INSERT INTO projects VALUES ('pgproxy', 10, 5433, 'hub', 1, 'https://github.com/postgres/pg-pool/releases',
  'PG Proxy',  0, 'pgproxy.png', 'Intelligent Database Proxy', 'https://github.com/postgres/pgpool2');

INSERT INTO projects VALUES ('rabbitmq', 10, 5672, 'hub', 1, 'https://github.com/rabbitmq/rabbitmq-server/releases',
  'RabbitMQ', 0, 'rabbitmq.png', 'Message Broker', 'https://github.com/rabbitmq/rabbitmq-server');

INSERT INTO projects VALUES ('redis', 10, 6379, 'hub', 1, 'https://github.com/redis/redis/releases',
  'Redis', 0, 'redis.png', 'Hi-speed Cache', 'https://github.com/redis/redis');

INSERT INTO projects VALUES ('cassandra', 10, 9042, 'hub', 1, 'https://cassandra.apache.org/download', 
  'Cassandra', 0, 'cstar.png', 'Multi-Master across Regions', 
  'https://cassandra.apache.org');

INSERT INTO projects VALUES ('oracle', 10, 1521, 'hub', 0, 'https://www.oracle.com/database/technologies/oracle-database-software-downloads.html#19c', 
  'Oracle', 0, 'oracle.png', 'Most Expensive RDBMS', 'https://www.oracle.com/database/technologies');

INSERT INTO projects VALUES ('grafana', 9, 0, 'hub', 0, 'https://grafana.com/grafana/download',
  'grafana', 0, 'grafana.png', 'Monitoring Dashboard', 'https://grafana.com');

