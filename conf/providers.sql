DROP TABLE IF EXISTS countries;
DROP TABLE IF EXISTS geos;
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

CREATE TABLE geos (
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

CREATE TABLE countries (
  country      TEXT     NOT NULL PRIMARY KEY,
  geo          TEXT     NOT NULL REFERENCES geos(geo),
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
INSERT INTO countries VALUES ('in', 'ap', 'India');

