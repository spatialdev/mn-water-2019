/*
This query identifies OSM linear features that have not changed between two time slices.
- The OSM ID should be identical
- The geometry should be identical
*/

CREATE TABLE results_final.linear_no_change AS
SELECT
	t_1.osm_id as osm_id_t1,
	t_2.osm_id as osm_id_t2,
	t_1.all_tags as all_tags_t1,
    t_2.all_tags as all_tags_t2,
	t_1.source as source_t1,
	t_2.source as source_t2,
	t_1.wkb_geometry geom_t1,
	t_2.wkb_geometry geom_t2
FROM
	mn_2011_upload.lines t_1,
	mn_2019_upload.lines t_2
WHERE
	t_1.osm_id = t_2.osm_id AND
	ST_Equals(t_1.wkb_geometry, t_2.wkb_geometry)
;

CREATE TABLE results_final.linear_no_change_nhd AS
SELECT
	*
FROM results_final.linear_no_change
WHERE
	LOWER(source_t1) LIKE '%nhd%'
;

