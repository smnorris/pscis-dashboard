# ----------------------------------
# dump PSCIS to geojson
# ----------------------------------

# remove existing file if already there, ogr doesn't overwrite geojson
rm -f assets/data/pscis_dump.json

# pg 2 geojson
ogr2ogr -f GeoJSON assets/data/pscis_dump.json \
  PG:'dbname=postgis user=postgres host=localhost password=postgres' \
  -t_srs EPSG:4326 \
  -lco COORDINATE_PRECISION=4 \
  -sql "SELECT \
      p.stream_crossing_id, \
      p.geom, \
      e.*, \
      a.assessment_id, \
      a.external_crossing_reference, \
      a.stream_name, \
      a.road_name, \
      a.road_km_mark, \
      a.crossing_type_code, \
      a.crossing_subtype_code, \
      a.assessment_date, \
      a.project_id as assmt_project_id, \
      a.funding_project_number as assmt_funding_project_number, \
      a.funding_project as assmt_funding_source_code, \
      a.responsible_party_name as assmt_resp_party_name, \
      a.consultant_name as assmt_consultant_name, \
      a.diameter_or_span, \
      a.length_or_width, \
      a.crew_members, \
      a.continuous_embeddedment_ind, \
      a.average_depth_embededdment, \
      a.resemble_channel_ind, \
      a.backwatered_ind, \
      a.percentage_backwatered, \
      a.fill_depth, \
      a.outlet_drop, \
      a.outlet_pool_depth, \
      a.inlet_drop_ind, \
      a.culvert_slope, \
      a.downstream_channel_width, \
      a.stream_slope, \
      a.stream_width_ratio, \
      a.beaver_activity_ind, \
      a.fish_observed_ind, \
      a.valley_fill_code, \
      a.habitat_value_code, \
      a.embed_score, \
      a.culvert_length_score, \
      a.outlet_drop_score, \
      a.culvert_slope_score, \
      a.stream_width_ratio_score, \
      a.final_score, \
      a.assessment_comment, \
      a.crossing_fix_code, \
      a.recommended_diameter_or_span, \
      'http://a100.gov.bc.ca/pub/pscismap/imageViewer.do?assessmentId='||a.assessment_id as image_view_url, \
      'http://a100.gov.bc.ca/pub/acat/public/advancedSearch.do?keywords=[PSCIS'||a.project_id||']&searchKeyType=searchAll&sortColumn=title' as ecocat_url, \
      stream.stream_order, \
      stream.gnis_name, \
      r.current_crossing_type_desc, \
      r.remediation_id, \
      r.completion_date, \
      r.remediation_cost, \
      r.habconf_verified_habitat_len, \
      r.remed_cost_benefit \
    FROM temp.pscis_memekay p \
    LEFT OUTER JOIN temp.pscis_habitat_memekay e \
    ON p.stream_crossing_id = e.stream_crossing_id \
    LEFT OUTER JOIN pscis.pscis_assessment_svw a \
    ON e.stream_crossing_id = a.stream_crossing_id \
    LEFT OUTER JOIN pscis.pscis_remediation_svw r \
    ON e.stream_crossing_id = r.stream_crossing_id \
    LEFT OUTER JOIN whse_basemapping.fwa_stream_networks_sp stream \
    ON e.blue_line_key = stream.blue_line_key \
    AND stream.downstream_route_measure = \
        (SELECT downstream_route_measure \
           FROM whse_basemapping.fwa_stream_networks_sp \
          WHERE blue_line_key = e.blue_line_key \
            AND downstream_route_measure < e.downstream_route_measure \
       ORDER BY downstream_route_measure DESC \
          LIMIT 1)"

# shrink the file as much as possible
# liljson disturbs the property order, don't use it for now
# cat assets/data/pfn_dump.json | python ~/bin/python/liljson --precision 4 > assets/data/pfn.json
cp assets/data/pscis_dump.json assets/data/pscis.json
rm -f assets/data/pscis_dump.json

