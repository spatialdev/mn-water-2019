/*
These queries identify polygonal features that have changed from 2011 to 2019. Types of changes include:
- The OSM ID is identical but the geometry should NOT be identical
- The OSM ID only exists in 2011 and does not have a feature that replaced it in 2019 - DELETED
- The OSM ID only exists in 2019 and does not have a feature that it replaces in 2011 - ADDED
- The OSM ID only exists in 2019 but it replaces a feature in 2011 - ENHANCEMENT
*/

-- Find polygons from 2011 that are different in 2019
CREATE TABLE results_diff_geo.polygonal_2011_change AS
SELECT
	*
FROM mn_2011_upload.multipolygons
WHERE  NOT EXISTS (
   SELECT
   FROM results_diff_geo.polygonal_no_change_all r
   WHERE  osm_id = r.osm_id_t1 OR osm_way_id = r.osm_way_id_t1
   )
;

-- Find polygons from 2019 that are different from 2011
CREATE TABLE results_diff_geo.polygonal_2019_change AS
SELECT
	*
FROM mn_2019_upload.multipolygons
WHERE  NOT EXISTS (
   SELECT
   FROM results_diff_geo.polygonal_no_change_all r
   WHERE  osm_id = r.osm_id_t1 OR osm_way_id = r.osm_way_id_t1
   )
;

-- Subset the change results from 2011 for only NHD features
CREATE TABLE results_diff_geo.polygonal_2011_change_nhd AS
SELECT
	*
FROM results_diff_geo.polygonal_2011_change
WHERE
	LOWER(source) LIKE '%nhd%'
;

-- Subset the change results for 2019 for only NHD features
CREATE TABLE results_diff_geo.polygonal_2019_change_nhd AS
SELECT
	*
FROM results_diff_geo.polygonal_2019_change
WHERE
	LOWER(source) LIKE '%nhd%'
;

-- Subset the change results from 2011 for features where only the geometry changed
CREATE TABLE results_diff_geo.linear_2011_change_nhd_geom AS
SELECT
	t1.*
FROM
	results_diff_geo.linear_2011_change_nhd t1,
	results_diff_geo.linear_2019_change_nhd t2
WHERE
	(t1.osm_id = t2.osm_id) AND
	NOT ST_Equals(t1.wkb_geometry, t2.wkb_geometry)
;

-- Subset the change results from 2019 for features where only the geometry changed
CREATE TABLE results_diff_geo.polygonal_2019_change_nhd_geom AS
SELECT
	t2.*
FROM
	results_diff_geo.polygonal_2011_change_nhd t1,
	results_diff_geo.polygonal_2019_change_nhd t2
WHERE
	((t1.osm_id = t2.osm_id) OR (t1.osm_way_id = t2.osm_way_id)) AND
	NOT ST_Equals(t1.wkb_geometry, t2.wkb_geometry)
;

-- Subset the change results from 2011 for features that exist only in 2011
CREATE TABLE results_diff_geo.polygonal_2011_change_nhd_id AS
SELECT
	t1.*
FROM
	results_diff_geo.polygonal_2011_change_nhd t1
WHERE NOT EXISTS (
	SELECT
	FROM results_diff_geo.polygonal_2019_change_nhd r
  	WHERE  t1.osm_id = r.osm_id OR t1.osm_way_id = r.osm_way_id
	)
;

-- Subset the change results from 2019 for features that exist only in 2019
CREATE TABLE results_diff_geo.polygonal_2019_change_nhd_id AS
SELECT
	t2.*
FROM
	results_diff_geo.polygonal_2019_change_nhd t2
WHERE NOT EXISTS (
	SELECT
	FROM results_diff_geo.polygonal_2011_change_nhd r
  	WHERE  t2.osm_id = r.osm_id OR t2.osm_way_id = r.osm_way_id
	)
;

-- Find features that exist only in 2019 and do not intersect with, but can touch features in 2011
CREATE TABLE results_diff_geo.polygonal_2019_change_nhd_additions AS
SELECT
	t2.*
FROM
	results_diff_geo.polygonal_2019_change_nhd_id as t2
LEFT JOIN
	results_diff_geo.polygonal_2011_change_nhd_id as t1
	ON (ST_Intersects(t2.wkb_geometry, t1.wkb_geometry) AND NOT ST_Touches(t2.wkb_geometry, t1.wkb_geometry))
WHERE t1.ogc_fid IS NULL
;

-- Find features that exist only in 2019 and intersect but do not only touch features that only exist in 2011
CREATE TABLE results_diff_geo.polygonal_2019_change_nhd_enhancements AS
SELECT
	t1.osm_id as osm_id_t1,
    t2.osm_id as osm_id_t2,
    t1.osm_way_id as osm_way_id_t1,
    t2.osm_way_id as osm_way_id_t2,
    t1.all_tags as all_tags_t1,
    t2.all_tags as all_tags_t2,
	t1.source as source_t1,
	t2.source as source_t2,
    t1.wkb_geometry geom_t1,
    t2.wkb_geometry geom_t2
FROM
	results_diff_geo.polygonal_2019_change_nhd_id as t2
LEFT JOIN
	results_diff_geo.polygonal_2011_change_nhd_id as t1
	ON (ST_Intersects(t2.wkb_geometry, t1.wkb_geometry) AND NOT ST_Touches(t2.wkb_geometry, t1.wkb_geometry))
WHERE t1.ogc_fid IS NOT NULL
;

-- Find features that exist only in 2011 and do not intersect with, but can touch features in 2019
CREATE TABLE results_diff_geo.polygonal_2011_change_nhd_deletions AS
SELECT
	t1.*
FROM
	results_diff_geo.polygonal_2011_change_nhd_id as t1
LEFT JOIN
	results_diff_geo.polygonal_2019_change_nhd_id as t2
	ON (ST_Intersects(t1.wkb_geometry, t2.wkb_geometry) AND NOT ST_Touches(t1.wkb_geometry, t2.wkb_geometry))
WHERE t2.ogc_fid IS NULL
;
