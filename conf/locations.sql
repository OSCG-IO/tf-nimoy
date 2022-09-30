.output

DROP TABLE IF EXISTS locations;
DROP VIEW IF EXISTS v_regions;
DROP TABLE IF EXISTS regions;

DROP TABLE IF EXISTS countries;
DROP TABLE IF EXISTS geos;
DROP TABLE IF EXISTS providers;

CREATE TABLE providers (
  provider      TEXT     NOT NULL PRIMARY KEY,
  sort_order    SMALLINT NOT NULL,
  short_name    TEXT     NOT NULL,
  disp_name     TEXT     NOT NULL,
  image_file    TEXT     NOT NULL
);
INSERT INTO providers VALUES ('aws',   1, 'AWS',   'Amazon Web Services',   'aws.png');
INSERT INTO providers VALUES ('gcp',   2, 'GCP',   'Google Cloud Platform', 'gcp.png');
INSERT INTO providers VALUES ('azr',   3, 'Azure', 'Microsoft Azure',       'azure.png');

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
  country_nm   TEXT     NOT NULL
);
INSERT INTO countries VALUES ('us', 'na', 'United States');
INSERT INTO countries VALUES ('ca', 'na', 'Canada');
INSERT INTO countries VALUES ('br', 'sa', 'Brazil');
INSERT INTO countries VALUES ('ir', 'eu', 'Ireland');
INSERT INTO countries VALUES ('gb', 'eu', 'Great Britain');
INSERT INTO countries VALUES ('de', 'eu', 'Germany');
INSERT INTO countries VALUES ('fr', 'eu', 'France');
INSERT INTO countries VALUES ('it', 'eu', 'Italy');
INSERT INTO countries VALUES ('se', 'eu', 'Sweden');
INSERT INTO countries VALUES ('bh', 'me', 'Bahrain');
INSERT INTO countries VALUES ('ae', 'me', 'UAE');
INSERT INTO countries VALUES ('au', 'au', 'Australia');
INSERT INTO countries VALUES ('za', 'af', 'South Africa');
INSERT INTO countries VALUES ('jp', 'ap', 'Japan');
INSERT INTO countries VALUES ('hk', 'ap', 'Hong Kong');
INSERT INTO countries VALUES ('sg', 'ap', 'Singapore');
INSERT INTO countries VALUES ('kr', 'ap', 'South Korea');
INSERT INTO countries VALUES ('id', 'ap', 'Indonesia');
INSERT INTO countries VALUES ('in', 'ap', 'India');

CREATE TABLE locations (
  location      TEXT     NOT NULL NOT NULL PRIMARY KEY,
  location_nm   TEXT     NOT NULL,
  country       TEXT     NOT NULL REFERENCES countries(country),
  latitude      FLOAT    NOT NULL,
  longitude     FLOAT    NOT NULL
);
INSERT INTO locations VALUES ('iad', 'Northern Virginia',  'us',  38.9519,  -77.4480);
INSERT INTO locations VALUES ('cmh', 'Ohio',               'us',  39.9950,  -82.8891);
INSERT INTO locations VALUES ('pdt', 'Oregon',             'us',  45.6947, -118.8430);
INSERT INTO locations VALUES ('sfo', 'Northern California','us',  37.6213, -122.3789);
INSERT INTO locations VALUES ('atl', 'Atlanta',            'us',  33.6404,  -84.4198);
INSERT INTO locations VALUES ('bos', 'Boston',             'us',  42.3669,  -71.0223);
INSERT INTO locations VALUES ('chi', 'Chicago',            'us',  41.9786,  -87.9047);
INSERT INTO locations VALUES ('dfw', 'Dallas',             'us',  32.8481,  -96.8513);
INSERT INTO locations VALUES ('den', 'Denver',             'us',  39.8560, -104.6737);
INSERT INTO locations VALUES ('iah', 'Houston',            'us',  36.9428, -109.7071);
INSERT INTO locations VALUES ('mci', 'Kansas City',        'us',  39.2970,  -94.6903);
INSERT INTO locations VALUES ('lax', 'Los Angeles',        'us',  33.9427, -118.4100);
INSERT INTO locations VALUES ('las', 'Las Vegas',          'us',  36.0860, -115.1539);
INSERT INTO locations VALUES ('mia', 'Miami',              'us',  25.7958,  -80.2870);
INSERT INTO locations VALUES ('msp', 'Minneapolis',        'us',  44.8843,  -93.2140);
INSERT INTO locations VALUES ('jfk', 'New York City',      'us',  40.6417,  -73.7809);
INSERT INTO locations VALUES ('phl', 'Philadelphia',       'us',  39.8741,  -75.2472);
INSERT INTO locations VALUES ('phx', 'Phoenix',            'us',  33.4372, -112.0077);
INSERT INTO locations VALUES ('pdx', 'Portland',           'us',  45.5875, -122.5933);
INSERT INTO locations VALUES ('sea', 'Seattle',            'us',  47.4435, -122.3016);
INSERT INTO locations VALUES ('mtl', 'Montreal',           'ca',  45.5088,  -73.5616);
INSERT INTO locations VALUES ('gru', 'Sao Paulo',          'br', -23.5337,  -46.6252);
INSERT INTO locations VALUES ('dub', 'Dublin',             'ir',  53.4264,   -6.2499);
INSERT INTO locations VALUES ('lhr', 'London',             'gb',  51.4588,   -0.4700);
INSERT INTO locations VALUES ('fra', 'Frankfurt',          'de',  50.0379,    8.5621);
INSERT INTO locations VALUES ('arn', 'Stockholm',          'se',  59.6497,   17.9237);
INSERT INTO locations VALUES ('cdg', 'Paris',              'fr',  49.0097,    2.5477);
INSERT INTO locations VALUES ('mxp', 'Milan',              'it',  45.6286,    8.7236);
INSERT INTO locations VALUES ('bah', 'Bahrain',            'bh',  26.2697,   50.6259);
INSERT INTO locations VALUES ('auh', 'Abu Dhabi',          'ae',  24.4329,   54.6445);
INSERT INTO locations VALUES ('syd', 'Sydney',             'au', -33.9399,  151.1752);
INSERT INTO locations VALUES ('cpt', 'Cape Town',          'za', -33.9725,   18.6019);
INSERT INTO locations VALUES ('nrt', 'Tokyo',              'jp',  35.7719,  140.3928); 
INSERT INTO locations VALUES ('itm', 'Osaka',              'jp',  34.4338,  135.2263);
INSERT INTO locations VALUES ('cgk', 'Jakarta',            'id',  -6.1255,  106.6558);
INSERT INTO locations VALUES ('hkg', 'Hong Kong',          'hk',  22.3080,  113.9184);
INSERT INTO locations VALUES ('icn', 'Seoul',              'kr',  37.4601,  126.4406);
INSERT INTO locations VALUES ('sin', 'Singapore',          'sg',   1.4201,  103.8645);
INSERT INTO locations VALUES ('bom', 'Mumbai',             'in',  19.0901,   72.8687);


CREATE TABLE regions (
  provider      TEXT       NOT NULL REFERENCES providers(provider),
  location      TEXT       NOT NULL REFERENCES locations(location),
  parent_region TEXT       NOT NULL,
  region        TEXT       NOT NULL,
  avail_zones   TEXT       NOT NULL,
  PRIMARY KEY (provider, location)
);
INSERT INTO regions VALUES ('aws', 'iad', 'us-east-1',      'us-east-1',      'a, b, c, d, e, f');
INSERT INTO regions VALUES ('aws', 'cmh', 'us-east-2',      'us-east-2',      'a, b, c');
INSERT INTO regions VALUES ('aws', 'sfo', 'us-west-1',      'us-west-1',      'a, b, c');
INSERT INTO regions VALUES ('aws', 'pdt', 'us-west-2',      'us-west-2',      'a, b, c, d');
INSERT INTO regions VALUES ('aws', 'mtl', 'ca-central-1',   'ca-central-1',   'a, b, c');
INSERT INTO regions VALUES ('aws', 'sin', 'ap-southeast-1', 'ap-southeast-1', 'a, b, c');
INSERT INTO regions VALUES ('aws', 'icn', 'ap-northeast-2', 'ap-northeast-2', 'a, b, c');
INSERT INTO regions VALUES ('aws', 'hkg', 'ap-east-1',      'ap-east-1',      'a, b, c');
INSERT INTO regions VALUES ('aws', 'itm', 'ap-northeast-3', 'ap-northeast-3', 'a, b, c');
INSERT INTO regions VALUES ('aws', 'nrt', 'ap-northeast-1', 'ap-northeast-1', 'a, b, c');
INSERT INTO regions VALUES ('aws', 'bom', 'ap-south-1',     'ap-south-1',     'a, b, c');
INSERT INTO regions VALUES ('aws', 'dfw', 'us-east-1',      'us-east-1-dfw-1','a');


CREATE VIEW v_regions AS
SELECT g.geo, c.country, l.location, l.country, r.provider, r.region, l.location_nm, 
       l.latitude, l.longitude, r.parent_region, r.avail_zones, i.image_id
  FROM geos g, countries c, regions r, locations l, images i
 WHERE g.geo = c.geo 
   AND c.country = l.country 
   AND l.location = r.location
   AND i.image_type = 'ubu22'
   AND i.platform = 'arm'
   AND r.provider = i.provider
   AND r.parent_region = i.region;
