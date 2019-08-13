/*
This query identifies OSM polygonal features that have not changed between two time slices.
- The OSM ID should be identical
- The geometry should be identical
*/

CREATE TABLE results_diff_geo.polygonal_no_change_all AS
SELECT
    t_1.osm_id as osm_id_t1,
    t_2.osm_id as osm_id_t2,
    t_1.osm_way_id as osm_way_id_t1,
    t_2.osm_way_id as osm_way_id_t2,
    t_1.all_tags as all_tags_t1,
    t_2.all_tags as all_tags_t2,
	t_1.source as source_t1,
	t_2.source as source_t2,
    t_1.wkb_geometry geom_t1,
    t_2.wkb_geometry geom_t2
FROM
    mn_2011_upload.multipolygons t_1,
    mn_2019_upload.multipolygons t_2
WHERE
    t_1.osm_id = t_2.osm_id AND
    ST_Equals(t_1.wkb_geometry, t_2.wkb_geometry)
UNION ALL
SELECT
    t_1.osm_id as osm_id_t1,
    t_2.osm_id as osm_id_t2,
    t_1.osm_way_id as osm_way_id_t1,
    t_2.osm_way_id as osm_way_id_t2,
    t_1.all_tags as all_tags_t1,
    t_2.all_tags as all_tags_t2,
	t_1.source as source_t1,
	t_2.source as source_t2,
    t_1.wkb_geometry geom_t1,
    t_2.wkb_geometry geom_t2
FROM
    mn_2011_upload.multipolygons t_1,
    mn_2019_upload.multipolygons t_2
WHERE
    t_1.osm_way_id = t_2.osm_way_id AND
    ST_Equals(t_1.wkb_geometry, t_2.wkb_geometry)
;

CREATE TABLE results_diff_geo.polygonal_no_change_nhd AS
SELECT
	*
FROM results_diff_geo.polygonal_no_change_all
WHERE
	LOWER(source_t1) LIKE '%nhd%'
;
