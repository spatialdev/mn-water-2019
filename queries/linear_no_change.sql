/* 
This query identifies OSM linear features that have not changed between two time slices. 
- The OSM ID should be identical 
- The geometry should be identical 
*/ 
CREATE TABLE results_final.linear_no_change AS 
  SELECT t_1.osm_id       AS osm_id_t1, 
         t_2.osm_id       AS osm_id_t2, 
         t_1.all_tags     AS all_tags_t1, 
         t_2.all_tags     AS all_tags_t2, 
         t_1.source       AS source_t1, 
         t_2.source       AS source_t2, 
         t_1.wkb_geometry geom_t1, 
         t_2.wkb_geometry geom_t2 
  FROM   mn_2011_upload.LINES t_1, 
         mn_2019_upload.LINES t_2 
  WHERE  t_1.osm_id = t_2.osm_id 
         AND St_equals(t_1.wkb_geometry, t_2.wkb_geometry); 

CREATE TABLE results_final.linear_no_change_nhd AS 
  SELECT * 
  FROM   results_final.linear_no_change 
  WHERE  Lower(source_t1) LIKE '%nhd%';
  
