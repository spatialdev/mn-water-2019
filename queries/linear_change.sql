/*
This query identifies OSM linear features that have changed between two time slices in terms of geometry.
- The OSM ID should be identical
- The geometry should NOT be identical
*/

CREATE TABLE results_diff_geo.linear_change AS
SELECT
	t_1.osm_id as id_t1,
	t_2.osm_id as id_t2,
	t_1.wkb_geometry geom_t1,
	t_2.wkb_geometry geom_t2
FROM
	mn_2011_upload.lines t_1,
	mn_2019_upload.lines t_2
WHERE
	t_1.osm_id = t_2.osm_id AND
	NOT ST_Equals(t_1.wkb_geometry, t_2.wkb_geometry)
;
