/*
These queries create tables from 2009, 2011, and 2019 linear and multipolygon data as a base for a larger metrics query.
*/

/*
Subset data and create a table for 2009 data.
*/
CREATE TABLE testing_sweeney.mn_2009_data AS
SELECT 
    ogc_fid,
    wkb_geometry,
    osm_version,
    osm_timestamp,
    osm_uid,
    osm_user,
    osm_changeset,
    "name",
    waterway,
    "source",
    "natural",
    landuse,
    wetland,
    all_tags,
    '2009'::int as year,
    ST_GeometryType(wkb_geometry) as geom_type,
    CASE WHEN ST_GeometryType(wkb_geometry) IN ('ST_LineString') 
         THEN ST_Length(wkb_geometry::geography) ELSE NULL END as length,
    CASE WHEN ST_GeometryType(wkb_geometry) IN ('ST_MultiPolygon')
         THEN ST_Area(wkb_geometry::geography) ELSE NULL END as area
FROM mn_2009_upload.lines
UNION ALL
SELECT
    ogc_fid,
    wkb_geometry,
    osm_version,
    osm_timestamp,
    osm_uid,
    osm_user,
    osm_changeset,
    "name",
    waterway,
    "source",
    "natural",
    landuse,
    wetland,
    all_tags,
    '2009'::int as year,
    ST_GeometryType(wkb_geometry) as geom_type,
    CASE WHEN ST_GeometryType(wkb_geometry) IN ('ST_LineString') 
         THEN ST_Length(wkb_geometry::geography) ELSE NULL END as length,
    CASE WHEN ST_GeometryType(wkb_geometry) IN ('ST_MultiPolygon')
         THEN ST_Area(wkb_geometry::geography) ELSE NULL END as area
FROM mn_2009_upload.multipolygons
;

/*
Subset data and create a table for 2011 data.
*/
CREATE TABLE testing_sweeney.mn_2011_data AS
SELECT 
    ogc_fid,
    wkb_geometry,
    osm_version,
    osm_timestamp,
    osm_uid,
    osm_user,
    osm_changeset,
    "name",
    waterway,
    "source",
    "natural",
    landuse,
    wetland,
    all_tags,
    '2011'::int as year,
    ST_GeometryType(wkb_geometry) as geom_type,
    CASE WHEN ST_GeometryType(wkb_geometry) IN ('ST_LineString') 
         THEN ST_Length(wkb_geometry::geography) ELSE NULL END as length,
    CASE WHEN ST_GeometryType(wkb_geometry) IN ('ST_MultiPolygon')
         THEN ST_Area(wkb_geometry::geography) ELSE NULL END as area
FROM mn_2011_upload.lines
UNION ALL
SELECT
    ogc_fid,
    wkb_geometry,
    osm_version,
    osm_timestamp,
    osm_uid,
    osm_user,
    osm_changeset,
    "name",
    waterway,
    "source",
    "natural",
    landuse,
    wetland,
    all_tags,
    '2011'::int as year,
    ST_GeometryType(wkb_geometry) as geom_type,
    CASE WHEN ST_GeometryType(wkb_geometry) IN ('ST_LineString') 
         THEN ST_Length(wkb_geometry::geography) ELSE NULL END as length,
    CASE WHEN ST_GeometryType(wkb_geometry) IN ('ST_MultiPolygon')
         THEN ST_Area(wkb_geometry::geography) ELSE NULL END as area
FROM mn_2011_upload.multipolygons
;


/*
Subset data and create a table for 2019 data.
*/

CREATE TABLE testing_sweeney.mn_2019_data AS
SELECT 
  	ogc_fid,
    wkb_geometry,
    osm_version,
    osm_timestamp,
    osm_uid,
    osm_user,
    osm_changeset,
    "name",
    waterway,
    "source",
    "natural",
    landuse,
    wetland,
    all_tags,
    '2019'::int as year,
    ST_GeometryType(wkb_geometry) as geom_type,
    CASE WHEN ST_GeometryType(wkb_geometry) IN ('ST_LineString') 
         THEN ST_Length(wkb_geometry::geography) ELSE NULL END as length,
    CASE WHEN ST_GeometryType(wkb_geometry) IN ('ST_MultiPolygon')
        THEN ST_Area(wkb_geometry::geography) ELSE NULL END as area
FROM mn_2019_upload.lines
UNION ALL
SELECT
    ogc_fid,
    wkb_geometry,
    osm_version,
    osm_timestamp,
    osm_uid,
    osm_user,
    osm_changeset,
    "name",
	waterway,
    "source",
    "natural",
    landuse,
    wetland,
    all_tags,
    '2019'::int as year,
    ST_GeometryType(wkb_geometry) as geom_type,
    CASE WHEN ST_GeometryType(wkb_geometry) IN ('ST_LineString') 
         THEN ST_Length(wkb_geometry::geography) ELSE NULL END as length,
    CASE WHEN ST_GeometryType(wkb_geometry) IN ('ST_MultiPolygon')
         THEN ST_Area(wkb_geometry::geography) ELSE NULL END as area
FROM mn_2019_upload.multipolygons
;