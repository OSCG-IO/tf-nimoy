
DROP TABLE IF EXISTS locations;
DROP VIEW IF EXISTS v_regions;
DROP TABLE IF EXISTS regions;

CREATE TABLE locations (
  location      TEXT     NOT NULL NOT NULL PRIMARY KEY,
  location_nm   TEXT     NOT NULL,
  country       TEXT     NOT NULL REFERENCES countries(country),
  lattitude     FLOAT    NOT NULL,
  longitude     FLOAT    NOT NULL
);
INSERT INTO locations VALUES ('iad', 'Northen Virginia',   'us',  38.951944,  -77.448055);
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
INSERT INTO locations VALUES ('dub', 'Ireland',            'ir',  53.426448,   -6.249910);
INSERT INTO locations VALUES ('lhr', 'London',             'gb',  51.458881,   -0.470008);
INSERT INTO locations VALUES ('fra', 'Frankfurt',          'de',  50.037933,    8.562152);
INSERT INTO locations VALUES ('arn', 'Stockholm',          'se',  59.649762,   17.923781);
INSERT INTO locations VALUES ('cdg', 'Paris',              'fr',  49.009724,    2.547778);
INSERT INTO locations VALUES ('mxp', 'Milan',              'it',  45.628611,    8.723611);
INSERT INTO locations VALUES ('bah', 'Bahrain',            'bh',  26.269712,   50.625987);
INSERT INTO locations VALUES ('auh', 'UAE',                'ae',  24.432928,   54.644539);
INSERT INTO locations VALUES ('syd', 'Sydney',             'au', -33.939922,  151.175276);
INSERT INTO locations VALUES ('cpt', 'Cape Town',          'za', -33.972555,   18.601944);
INSERT INTO locations VALUES ('nrt', 'Tokyo',              'jp',  35.771987,  140.392855); 
INSERT INTO locations VALUES ('itm', 'Osaka',              'jp',  34.433855,  135.226333);
INSERT INTO locations VALUES ('cgk', 'Indonesia',          'id',  -6.125567,  106.655897);
INSERT INTO locations VALUES ('hkg', 'Hong Kong',          'hk',  22.308046,  113.918480);
INSERT INTO locations VALUES ('icn', 'Seoul',              'kr',  37.460191,  126.440696);
INSERT INTO locations VALUES ('sin', 'Singapore',          'sg',   1.420181,  103.864555);


CREATE TABLE regions (
  provider      TEXT       NOT NULL REFERENCES providers(provider),
  location      TEXT       NOT NULL REFERENCES locations(location),
  region        TEXT       NOT NULL,
  avail_zones   TEXT       NOT NULL,
  PRIMARY KEY (provider, location)
);
INSERT INTO regions VALUES ('aws', 'iad', 'us-east-1',      'a, b, c, d, e, f');
INSERT INTO regions VALUES ('aws', 'cmh', 'us-east-2',      'a, b, c');
INSERT INTO regions VALUES ('aws', 'sfo', 'us-west-1',      'a, b, c');
INSERT INTO regions VALUES ('aws', 'pdt', 'us-west-2',      'a, b, c, d');
INSERT INTO regions VALUES ('aws', 'mtl', 'ca-central-1',   'a, b, c');
INSERT INTO regions VALUES ('aws', 'sin', 'ap-southeast-1', 'a, b, c');
INSERT INTO regions VALUES ('aws', 'icn', 'ap-northeast-2', 'a, b, c');
INSERT INTO regions VALUES ('aws', 'hkg', 'ap-east-1',      'a, b, c');
INSERT INTO regions VALUES ('aws', 'itm', 'ap-northeast-3', 'a, b, c');
INSERT INTO regions VALUES ('aws', 'nrt', 'ap-northeast-1', 'a, b, c');
INSERT INTO regions VALUES ('aws', 'bom', 'ap-south-1',     'a, b, c');

CREATE VIEW v_regions AS
SELECT g.geo, l.country, l.location, r.provider, r.region, l.location_nm, r.avail_zones, l.lattitude, l.longitude
  FROM locations l, countries c, geos g, regions r 
 WHERE l.country = c.country 
   AND c.geo = g.geo 
   AND l.location = r.location;

