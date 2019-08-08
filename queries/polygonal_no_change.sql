/*
This query identifies OSM polygonal features that have not changed between two time slices.
- The OSM ID should be identical
- The geometry should be identical
*/

CREATE TABLE results_diff_geo.polygonal_no_change AS
SELECT
	t_1.osm_id as id_t1,
	t_2.osm_id as id_t2,
	t_1.wkb_geometry geom_t1,
	t_2.wkb_geometry geom_t2
FROM
	mn_2011_upload.multipolygons t_1,
	mn_2019_upload.multipolygons t_2
WHERE
	t_1.osm_id = t_2.osm_id AND
	ST_Equals(t_1.wkb_geometry, t_2.wkb_geometry)
;
