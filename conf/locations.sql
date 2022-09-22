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
INSERT INTO locations VALUES ('iad', 'Northern Virginia',  'us',  38.951944,  -77.448055);
INSERT INTO locations VALUES ('cmh', 'Ohio',               'us',  39.995000,  -82.889166);
INSERT INTO locations VALUES ('pdt', 'Oregon',             'us',  45.694765, -118.843008);
INSERT INTO locations VALUES ('sfo', 'Northern California','us',  37.621312, -122.378955);
INSERT INTO locations VALUES ('atl', 'Atlanta',            'us',  33.640411,  -84.419853);
INSERT INTO locations VALUES ('bos', 'Boston',             'us',  42.366978,  -71.022362);
INSERT INTO locations VALUES ('chi', 'Chicago',            'us',  41.978611,  -87.904724);
INSERT INTO locations VALUES ('dfw', 'Dallas',             'us',  32.848152,  -96.851349);
INSERT INTO locations VALUES ('den', 'Denver',             'us',  39.856094, -104.673737);
INSERT INTO locations VALUES ('iah', 'Houston',            'us',  36.942810, -109.707108);
INSERT INTO locations VALUES ('mci', 'Kansas City',        'us',  39.297010,  -94.690370);
INSERT INTO locations VALUES ('lax', 'Los Angeles',        'us',  33.942791, -118.410042);
INSERT INTO locations VALUES ('las', 'Las Vegas',          'us',  36.086010, -115.153969);
INSERT INTO locations VALUES ('mia', 'Miami',              'us',  25.795865,  -80.287045);
INSERT INTO locations VALUES ('msp', 'Minneapolis',        'us',  44.884358,  -93.214075);
INSERT INTO locations VALUES ('jfk', 'New York City',      'us',  40.641766,  -73.780968);
INSERT INTO locations VALUES ('phl', 'Philadelphia',       'us',  39.874193,  -75.247245);
INSERT INTO locations VALUES ('phx', 'Phoenix',            'us',  33.437269, -112.007788);
INSERT INTO locations VALUES ('pdx', 'Portland',           'us',  45.587555, -122.593333);
INSERT INTO locations VALUES ('sea', 'Seattle',            'us',  47.443546, -122.301659);
INSERT INTO locations VALUES ('mtl', 'Montreal',           'ca',  45.508888,  -73.561668);
INSERT INTO locations VALUES ('gru', 'Sao Paulo',          'br', -23.533773,  -46.625290);
INSERT INTO locations VALUES ('dub', 'Dublin',             'ir',  53.426448,   -6.249910);
INSERT INTO locations VALUES ('lhr', 'London',             'gb',  51.458881,   -0.470008);
INSERT INTO locations VALUES ('fra', 'Frankfurt',          'de',  50.037933,    8.562152);
INSERT INTO locations VALUES ('arn', 'Stockholm',          'se',  59.649762,   17.923781);
INSERT INTO locations VALUES ('cdg', 'Paris',              'fr',  49.009724,    2.547778);
INSERT INTO locations VALUES ('mxp', 'Milan',              'it',  45.628611,    8.723611);
INSERT INTO locations VALUES ('bah', 'Bahrain',            'bh',  26.269712,   50.625987);
INSERT INTO locations VALUES ('auh', 'Abu Dhabi',          'ae',  24.432928,   54.644539);
INSERT INTO locations VALUES ('syd', 'Sydney',             'au', -33.939922,  151.175276);
INSERT INTO locations VALUES ('cpt', 'Cape Town',          'za', -33.972555,   18.601944);
INSERT INTO locations VALUES ('nrt', 'Tokyo',              'jp',  35.771987,  140.392855); 
INSERT INTO locations VALUES ('itm', 'Osaka',              'jp',  34.433855,  135.226333);
INSERT INTO locations VALUES ('cgk', 'Jakarta',            'id',  -6.125567,  106.655897);
INSERT INTO locations VALUES ('hkg', 'Hong Kong',          'hk',  22.308046,  113.918480);
INSERT INTO locations VALUES ('icn', 'Seoul',              'kr',  37.460191,  126.440696);
INSERT INTO locations VALUES ('sin', 'Singapore',          'sg',   1.420181,  103.864555);
INSERT INTO locations VALUES ('bom', 'Mumbai',             'in',  19.090176,   72.868739);


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


CREATE VIEW v_regions AS
SELECT g.geo, c.country, l.location, l.country, r.provider, r.region, l.location_nm, l.latitude, l.longitude,
       r.parent_region, r.avail_zones, i.image_id
  FROM geos g, countries c, regions r, locations l, images i
 WHERE g.geo = c.geo 
   AND c.country = l.country 
   AND l.location = r.location
   AND i.image_type = 'ubu22'
   AND i.platform = 'arm'
   AND r.provider = i.provider
   AND r.region = i.region;
