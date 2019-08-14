/*
This query creates a table that calculates counts and sums for each pbf time slice (2009, 2011, 2019)
*/

CREATE TABLE IF NOT EXISTS testing_sweeney.metrics (
    year int,
    num_features bigint, --number of features
    num_line_fts bigint, --number of linear features
    num_poly_fts bigint,  --number of polygonal features
    count_waterway_tags bigint, --count of waterway tags
    count_landuse_tags bigint,  --count of landuse tags 
    count_natural_tags bigint,  --count of natural tags
    count_wetland_tags bigint,  --count of wetland tags
    count_source_nhd bigint,  --total feature count with NHD as source
    count_src_nhd_lines bigint,  --count of linear features with NHD as source
    count_src_nhd_poly bigint, --count of polyongal features with NHD as source
    total_length_km bigint,  --total length of all linear features in km
    total_area_km bigint  --total area of all polygonal features in km
)
;

INSERT INTO testing_sweeney.metrics
SELECT *
FROM(SELECT
        year,
        COUNT(ogc_fid) as num_features
    FROM testing_sweeney.mn_2009_data
    GROUP BY year
    UNION ALL
    SELECT
        year,
        COUNT(ogc_fid) as num_features
    FROM testing_sweeney.mn_2011_data
    GROUP BY year
    UNION ALL
    SELECT
        year,
        COUNT(ogc_fid) as num_features
    FROM testing_sweeney.mn_2019_data
    GROUP BY year) num_features
FULL OUTER JOIN
    (SELECT
        year,
        SUM(CASE 
                WHEN geom_type IN ('ST_LineString') 
                THEN 1 
                ELSE NULL 
                END) num_line_fts,
        SUM(CASE 
                WHEN geom_type IN ('ST_MultiPolygon')
                THEN 1 
                ELSE NULL 
                END) num_poly_fts
    FROM testing_sweeney.mn_2009_data
    GROUP BY year
    UNION ALL
    SELECT
        year,
        SUM(CASE 
                WHEN geom_type IN ('ST_LineString') 
                THEN 1 
                ELSE NULL 
                END) num_line_fts,
        SUM(CASE 
                WHEN geom_type IN ('ST_MultiPolygon')
                THEN 1 
                ELSE NULL 
                END) num_poly_fts
    FROM testing_sweeney.mn_2011_data
    GROUP BY year
    UNION ALL
    SELECT
        year,
        SUM(CASE 
                WHEN geom_type IN ('ST_LineString') 
                THEN 1 
                ELSE NULL 
                END) num_line_fts,
        SUM(CASE 
                WHEN geom_type IN ('ST_MultiPolygon')
                THEN 1 
                ELSE NULL END) num_poly_fts
    FROM testing_sweeney.mn_2019_data
    GROUP BY year) length_area
USING(year)
FULL OUTER JOIN
    (SELECT
        year,
        COUNT(waterway) as count_waterway_tags,
        COUNT(landuse) as count_landuse_tags,
        COUNT("natural") as count_natural_tags,
        COUNT(wetland) as count_wetland_tags
    FROM testing_sweeney.mn_2009_data
    GROUP BY year
    UNION ALL
    SELECT
        year,
        COUNT(waterway) as count_waterway_tags,
        COUNT(landuse) as count_landuse_tags,
        COUNT("natural") as count_natural_tags,
        COUNT(wetland) as count_wetland_tags
    FROM testing_sweeney.mn_2011_data
    GROUP BY year
    UNION ALL
    SELECT
        year,
        COUNT(waterway) as count_waterway_tags,
        COUNT(landuse) as count_landuse_tags,
        COUNT("natural") as count_natural_tags,
        COUNT(wetland) as count_wetland_tags
    FROM testing_sweeney.mn_2019_data
    GROUP BY year) tag_counts
USING(year)
FULL OUTER JOIN
    (SELECT 
        year,
        SUM(CASE 
                WHEN lower("source") LIKE '%nhd%' THEN 1 
                ELSE NULL 
                END) count_source_nhd,
        SUM(CASE 
                WHEN ((lower("source") LIKE '%nhd%') AND (geom_type IN ('ST_LineString')))  
                THEN 1 
                ELSE NULL 
                END) count_src_nhd_lines,
        SUM(CASE 
                WHEN ((lower("source") LIKE '%nhd%') AND (geom_type IN ('ST_MultiPolygon')))  
                THEN 1 
                ELSE NULL 
                END) count_src_nhd_poly
    FROM testing_sweeney.mn_2009_data
    GROUP BY year
    UNION ALL
    SELECT 
        year,
        SUM(CASE 
                WHEN lower("source") LIKE '%nhd%' THEN 1 
                ELSE NULL 
                END) count_source_nhd,
        SUM(CASE 
                WHEN ((lower("source") LIKE '%nhd%') AND (geom_type IN ('ST_LineString')))  
                THEN 1 
                ELSE NULL 
                END) count_src_nhd_lines,
        SUM(CASE 
                WHEN ((lower("source") LIKE '%nhd%') AND (geom_type IN ('ST_MultiPolygon')))  
                THEN 1 
                ELSE NULL 
                END) count_src_nhd_poly
    FROM testing_sweeney.mn_2011_data
    GROUP BY year
    UNION ALL
    SELECT 
        year,
        SUM(CASE 
                WHEN lower("source") LIKE '%nhd%' THEN 1 
                ELSE NULL 
                END) count_source_nhd,
        SUM(CASE 
                WHEN ((lower("source") LIKE '%nhd%') AND (geom_type IN ('ST_LineString')))  
                THEN 1 
                ELSE NULL 
                END) count_src_nhd_lines,
        SUM(CASE 
                WHEN ((lower("source") LIKE '%nhd%') AND (geom_type IN ('ST_MultiPolygon')))  
                THEN 1 
                ELSE NULL 
                END) count_src_nhd_poly
    FROM testing_sweeney.mn_2019_data
    GROUP BY year) count_source_nhd
USING(year)
FULL OUTER JOIN
    (SELECT 
        year,
        SUM(length)/1000 as total_length_km,
        SUM(area)/1000 as total_area_km
    FROM testing_sweeney.mn_2009_data
    GROUP BY year
    UNION ALL
    SELECT 
        year,
        SUM(length)/1000 as total_length_km,
        SUM(area)/1000 as total_area_km
    FROM testing_sweeney.mn_2011_data
    GROUP BY year
    UNION ALL
    SELECT 
        year,
        SUM(length)/1000 as total_length_km,
        SUM(area)/1000 as total_area_km
    FROM testing_sweeney.mn_2019_data
    GROUP BY year) length_area
USING(year)

