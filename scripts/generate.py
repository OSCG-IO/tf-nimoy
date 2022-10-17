#!/usr/bin/python3

import sys, sqlite3, os

import fire

os.chdir(sys.path[0])

kount = 0
origin_lat = 0
origin_lon = 0
connection = sqlite3.connect("../conf/stelthy.db")


def print_map(geo=None, country=None, provider=None, location=None):
  g_whr = ""

  if geo:
    if isinstance(geo, str):
      g_whr = g_whr + " AND geo = '" + geo + "'"
    else:
      g_whr = g_whr + " AND geo IN " + str(geo)

  if country:
    if isinstance(country, str):
      g_whr = g_whr + " AND country = '" + country + "'"
    else:
      g_whr = g_whr + " AND country IN " + str(country)

  if provider:
    if isinstance(provider, str):
      g_whr = g_whr + " AND provider = '" + provider + "'"
    else:
      g_whr = g_whr + " AND provider IN " + str(provider)

  if location:
    if isinstance(location, str):
      g_whr = g_whr + " AND location = '" + location + "'"
    else:
      g_whr = g_whr + " AND location IN " + str(location)

  
  print_top()

  print_locations(g_whr)

  print_bottom()


################ print_locations() ##################################
def print_location(p_loct, p_loct_nm, p_lat, p_lon, p_az=""):
  global kount
  global origin_lat
  global origin_lon

  kount = kount + 1

  if kount == 1:
    origin_lat = p_lat
    origin_lon = p_lon
  else:
    print(",")

  lat = float(p_lat)
  lon = float(p_lon)
  az  = p_az.upper()
  id  = p_loct + p_az.lower()
  if az == "B":
    lon = lon - 0.01
  elif az == "C":
    lat = lat + 0.01

  loct_zn = p_loct_nm + " " + az

  print('{')
  print('  id: "' + id + '",\n  title: "' + p_loct_nm + '",')
  print('  geometry: { type: "Point", coordinates: [' + str(lon) + ', ' + str(lat) + '] },')
  print('}')


################ print_locations() ##################################
def print_locations(p_where):
  global origin_lat
  global origin_lon


  c = connection.cursor()

  sql = "SELECT location, location_nm, lattitude, longitude \
           FROM v_locations \
          WHERE 1=1 " + p_where

  c.execute(sql )

  rows = c.fetchall()

  if not rows:
    print("ERROR: no locations for : " + str(p_where), file=sys.stderr)
    sys.exit(1)


  print ('var cities = [')

  for row in rows:
    loct = str(row[0])
    loc_nm = str(row[1])
    lat = str(row[2])
    lon = str(row[3])

    print_location(loct, loc_nm, lat, lon)

  print(
"""
];

citySeries.data.setAll(cities);

// prepare line series data
var destinations = [
"""
  )

  k = 0
  for i in range(1, len(sys.argv)):
    k = k + 1
    if k > 1:
      print(' ,')

    dest = str(sys.argv[i])
    dest = dest.replace(":", "")

    print('"' + dest + '"')

  print(
"""
];

// Origin Coordinates
"""
  )


  print(" var originLongitude = " + str(origin_lon) + ";")
  print(" var originLatitude  = " + str(origin_lat) + ";")


################## print_top() #####################################
def print_top():
  print(
"""
<style>
#chartdiv {
  width: 100%;
  height: 500px;
}
</style>

<!-- Resources -->
<script src="https://cdn.amcharts.com/lib/5/index.js"></script>
<script src="https://cdn.amcharts.com/lib/5/map.js"></script>
<script src="https://cdn.amcharts.com/lib/5/geodata/worldLow.js"></script>
<script src="https://cdn.amcharts.com/lib/5/themes/Animated.js"></script>

<!-- Chart code -->
<script>
am5.ready(function() {

// Create root element
// https://www.amcharts.com/docs/v5/getting-started/#Root_element
var root = am5.Root.new("chartdiv");


// Set themes
// https://www.amcharts.com/docs/v5/concepts/themes/
root.setThemes([
  am5themes_Animated.new(root)
]);


// Create the map chart
// https://www.amcharts.com/docs/v5/charts/map-chart/
var chart = root.container.children.push(am5map.MapChart.new(root, {
  panX: "translateX",
  panY: "translateY",
  projection: am5map.geoMercator()
}));

var cont = chart.children.push(am5.Container.new(root, {
  layout: root.horizontalLayout,
  x: 20,
  y: 40
}));


// Add labels and controls
cont.children.push(am5.Label.new(root, {
  centerY: am5.p50,
  text: "Map"
}));

var switchButton = cont.children.push(am5.Button.new(root, {
  themeTags: ["switch"],
  centerY: am5.p50,
  icon: am5.Circle.new(root, {
    themeTags: ["icon"]
  })
}));

switchButton.on("active", function() {
  if (!switchButton.get("active")) {
    chart.set("projection", am5map.geoMercator());
    chart.set("panX", "translateX");
    chart.set("panY", "translateY");
  }
  else {
    chart.set("projection", am5map.geoOrthographic());
    chart.set("panX", "rotateX");
    chart.set("panY", "rotateY");
  }
});

cont.children.push(am5.Label.new(root, {
  centerY: am5.p50,
  text: "Globe"
}));

// Create main polygon series for countries
// https://www.amcharts.com/docs/v5/charts/map-chart/map-polygon-series/
var polygonSeries = chart.series.push(am5map.MapPolygonSeries.new(root, {
  geoJSON: am5geodata_worldLow
}));

var graticuleSeries = chart.series.push(am5map.GraticuleSeries.new(root, {}));
graticuleSeries.mapLines.template.setAll({
  stroke: root.interfaceColors.get("alternativeBackground"),
  strokeOpacity: 0.08
});

// Create line series for trajectory lines
// https://www.amcharts.com/docs/v5/charts/map-chart/map-line-series/
var lineSeries = chart.series.push(am5map.MapLineSeries.new(root, {}));
lineSeries.mapLines.template.setAll({
  stroke: root.interfaceColors.get("alternativeBackground"),
  strokeOpacity: 0.6
});

// destination series
var citySeries = chart.series.push(
  am5map.MapPointSeries.new(root, {})
);

citySeries.bullets.push(function() {
  var circle = am5.Circle.new(root, {
    radius: 5,
    tooltipText: "{title}",
    tooltipY: 0,
    fill: am5.color(0xffba00),
    stroke: root.interfaceColors.get("background"),
    strokeWidth: 2
  });

  return am5.Bullet.new(root, {
    sprite: circle
  });
});

// arrow series
var arrowSeries = chart.series.push(
  am5map.MapPointSeries.new(root, {})
);

arrowSeries.bullets.push(function() {
  var arrow = am5.Graphics.new(root, {
    fill: am5.color(0x000000),
    stroke: am5.color(0x000000),
    draw: function (display) {
      display.moveTo(0, -3);
      display.lineTo(8, 0);
      display.lineTo(0, 3);
      display.lineTo(0, -3);
    }
  });

  return am5.Bullet.new(root, {
    sprite: arrow
  });
});

"""
  )


def print_bottom():
  print(
"""

am5.array.each(destinations, function (did) {
  var destinationDataItem = citySeries.getDataItemById(did);
  var lineDataItem = lineSeries.pushDataItem({ geometry: { type: "LineString", coordinates: [[originLongitude, originLatitude], [destinationDataItem.get("longitude"), destinationDataItem.get("latitude")]] } });

  arrowSeries.pushDataItem({
    lineDataItem: lineDataItem,
    positionOnLine: 0.5,
    autoRotate: true
  });
})

polygonSeries.events.on("datavalidated", function () {
  chart.zoomToGeoPoint({ longitude: 72.86, latitude: 19.09 }, 3);
})


// Make stuff animate on load
chart.appear(1000, 100);

}); // end am5.ready()
</script>

<!-- HTML -->
<div id="chartdiv"></div>
"""
  )

if __name__ == '__main__':
  fire.Fire({
      'map': print_map,
  })

