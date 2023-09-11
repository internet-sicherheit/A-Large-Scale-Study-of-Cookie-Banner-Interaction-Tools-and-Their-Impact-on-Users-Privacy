# This SQL is used to generate the data for the plots used in the paper.

  /* p1_general_overview*/
SELECT
  cookies.fc_getAlias(browser_id) AS alias,
  'Total cookies' label,
  COUNT(*) ct,
  browser_id
FROM
  cookies.eval_cookies
WHERE
  in_cookiejar=1
GROUP BY
  browser_id
UNION ALL
SELECT
  cookies.fc_getAlias(browser_id),
  'Deleted cookies',
  COUNT(*) ct,
  browser_id
FROM
  cookies.eval_cookies
WHERE
  record_type='deleted'
GROUP BY
  browser_id
UNION ALL
SELECT
  cookies.fc_getAlias(browser_id),
  'Operations',
  COUNT(*) ct,
  browser_id
FROM
  cookies.eval_cookies
GROUP BY
  browser_id
ORDER BY
  alias,
  browser_id; /*,
  --,
  -- p2_cookie_cat_per_profile : cookie cat per profile*/
SELECT
  cookies.fc_getAlias(browser_id),
  browser_id,
  COUNT(*) ct,
  category,
  ROUND(COUNT(*) /(
    SELECT
      COUNT(*)
    FROM
      cookies.eval_cookies c2
    WHERE
      c1.browser_id=c2.browser_id )*100,1) AS pct
FROM
  cookies.eval_cookies c1
GROUP BY
  category,
  browser_id
ORDER BY
  cookies.fc_getAlias(browser_id),
  category; /*,
  --,
  -- p3_cookie_per_site_per_profile*/
SELECT
  COUNT(*) ct,
  cookies.fc_getAlias(browser_id) alias,
  browser_id
FROM
  cookies.eval_cookies
WHERE
  in_cookiejar=1
GROUP BY
  site_id,
  browser_id; /*,
  --,
  -- p4_cookie_cats_per_site_per_profile*/
SELECT
  COUNT(*) ct,
  cookies.fc_getAlias(browser_id) alias,
  browser_id
FROM
  cookies.eval_cookies
WHERE
  in_cookiejar=1
GROUP BY
  site_id,
  browser_id;



  --p5_buble_targeting_cookies
SELECT
  SUM(ct) total_cookies,
  COUNT(*) total_sites,
  host,
  alias,
FROM (
  SELECT
    cookies.fc_getAlias(browser_id) alias,
    host,
    site_id,
    COUNT(*) ct
  FROM
    cookies.eval_cookies
  WHERE
    in_cookiejar=1
    AND category='Targeting/Advertising'
    AND is_third_party=1
  GROUP BY
    host,
    browser_id,
    site_id)
GROUP BY
  host,
  alias
ORDER BY
  total_sites desc, alias asc;




-- p6_sim_cookie_cats

select * except (avg,min,max,std), round(avg,3) sim from (

SELECT
  'Functionality' analyse,
  'AcceptAll' gruppe,
  '1_3_7_8' compare,
  AVG(cat_func.sim_1_3_7_8) avg,
  STDDEV(cat_func.sim_1_3_7_8) std,
  MIN(cat_func.sim_1_3_7_8) min,
  MAX(cat_func.sim_1_3_7_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Functionality' analyse,
  'AcceptAll',
  '1_3_7',
  AVG(cat_func.sim_1_3_7) avg,
  STDDEV(cat_func.sim_1_3_7) std,
  MIN(cat_func.sim_1_3_7) min,
  MAX(cat_func.sim_1_3_7) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Functionality' analyse,
  'AcceptFunc',
  '5_6_8' compare,
  AVG(cat_func.sim_5_6_8) avg,
  STDDEV(cat_func.sim_5_6_8) std,
  MIN(cat_func.sim_5_6_8) min,
  MAX(cat_func.sim_5_6_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Functionality' analyse,
  'AcceptFunc',
  '5_6' compare,
  AVG(cat_func.sim_5_6) avg,
  STDDEV(cat_func.sim_5_6) std,
  MIN(cat_func.sim_5_6) min,
  MAX(cat_func.sim_5_6) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Functionality' analyse,
  'RejectAll',
  '2_4_8' compare,
  AVG(cat_func.sim_2_4_8) avg,
  STDDEV(cat_func.sim_2_4_8) std,
  MIN(cat_func.sim_2_4_8) min,
  MAX(cat_func.sim_2_4_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Functionality' analyse,
  'RejectAll',
  '2_4' compare,
  AVG(cat_func.sim_2_4) avg,
  STDDEV(cat_func.sim_2_4) std,
  MIN(cat_func.sim_2_4) min,
  MAX(cat_func.sim_2_4) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Targeting/Advertising' analyse,
  'AcceptAll' gruppe,
  '1_3_7_8' compare,
  AVG(cat_target.sim_1_3_7_8) avg,
  STDDEV(cat_target.sim_1_3_7_8) std,
  MIN(cat_target.sim_1_3_7_8) min,
  MAX(cat_target.sim_1_3_7_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Targeting/Advertising' analyse,
  'AcceptAll',
  '1_3_7',
  AVG(cat_target.sim_1_3_7) avg,
  STDDEV(cat_target.sim_1_3_7) std,
  MIN(cat_target.sim_1_3_7) min,
  MAX(cat_target.sim_1_3_7) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Targeting/Advertising' analyse,
  'AcceptAll',
  '3_7' compare,
  AVG(cat_target.sim_3_7) avg,
  STDDEV(cat_target.sim_3_7) std,
  MIN(cat_target.sim_3_7) min,
  MAX(cat_target.sim_3_7) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Targeting/Advertising' analyse,
  'AcceptFunc',
  '5_6_8' compare,
  AVG(cat_target.sim_5_6_8) avg,
  STDDEV(cat_target.sim_5_6_8) std,
  MIN(cat_target.sim_5_6_8) min,
  MAX(cat_target.sim_5_6_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Targeting/Advertising' analyse,
  'AcceptFunc',
  '5_6' compare,
  AVG(cat_target.sim_5_6) avg,
  STDDEV(cat_target.sim_5_6) std,
  MIN(cat_target.sim_5_6) min,
  MAX(cat_target.sim_5_6) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Targeting/Advertising' analyse,
  'RejectAll',
  '2_4_8' compare,
  AVG(cat_target.sim_2_4_8) avg,
  STDDEV(cat_target.sim_2_4_8) std,
  MIN(cat_target.sim_2_4_8) min,
  MAX(cat_target.sim_2_4_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Targeting/Advertising' analyse,
  'RejectAll',
  '2_4' compare,
  AVG(cat_target.sim_2_4) avg,
  STDDEV(cat_target.sim_2_4) std,
  MIN(cat_target.sim_2_4) min,
  MAX(cat_target.sim_2_4) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Strictly Necessary' analyse,
  'AcceptAll' gruppe,
  '1_3_7_8' compare,
  AVG(cat_strict.sim_1_3_7_8) avg,
  STDDEV(cat_strict.sim_1_3_7_8) std,
  MIN(cat_strict.sim_1_3_7_8) min,
  MAX(cat_strict.sim_1_3_7_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Strictly Necessary' analyse,
  'AcceptAll',
  '1_3_7',
  AVG(cat_strict.sim_1_3_7) avg,
  STDDEV(cat_strict.sim_1_3_7) std,
  MIN(cat_strict.sim_1_3_7) min,
  MAX(cat_strict.sim_1_3_7) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Strictly Necessary' analyse,
  'AcceptAll',
  '3_7' compare,
  AVG(cat_strict.sim_3_7) avg,
  STDDEV(cat_strict.sim_3_7) std,
  MIN(cat_strict.sim_3_7) min,
  MAX(cat_strict.sim_3_7) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Strictly Necessary' analyse,
  'AcceptFunc',
  '5_6_8' compare,
  AVG(cat_strict.sim_5_6_8) avg,
  STDDEV(cat_strict.sim_5_6_8) std,
  MIN(cat_strict.sim_5_6_8) min,
  MAX(cat_strict.sim_5_6_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Strictly Necessary' analyse,
  'AcceptFunc',
  '5_6' compare,
  AVG(cat_strict.sim_5_6) avg,
  STDDEV(cat_strict.sim_5_6) std,
  MIN(cat_strict.sim_5_6) min,
  MAX(cat_strict.sim_5_6) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Strictly Necessary' analyse,
  'RejectAll',
  '2_4_8' compare,
  AVG(cat_strict.sim_2_4_8) avg,
  STDDEV(cat_strict.sim_2_4_8) std,
  MIN(cat_strict.sim_2_4_8) min,
  MAX(cat_strict.sim_2_4_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Strictly Necessary' analyse,
  'RejectAll',
  '2_4' compare,
  AVG(cat_strict.sim_2_4) avg,
  STDDEV(cat_strict.sim_2_4) std,
  MIN(cat_strict.sim_2_4) min,
  MAX(cat_strict.sim_2_4) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Performance'analyse,
  'AcceptAll' gruppe,
  '1_3_7_8' compare,
  AVG(cat_performance.sim_1_3_7_8) avg,
  STDDEV(cat_performance.sim_1_3_7_8) std,
  MIN(cat_performance.sim_1_3_7_8) min,
  MAX(cat_performance.sim_1_3_7_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Performance'analyse,
  'AcceptAll',
  '1_3_7',
  AVG(cat_performance.sim_1_3_7) avg,
  STDDEV(cat_performance.sim_1_3_7) std,
  MIN(cat_performance.sim_1_3_7) min,
  MAX(cat_performance.sim_1_3_7) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Performance'analyse,
  'AcceptAll',
  '3_7' compare,
  AVG(cat_performance.sim_3_7) avg,
  STDDEV(cat_performance.sim_3_7) std,
  MIN(cat_performance.sim_3_7) min,
  MAX(cat_performance.sim_3_7) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Performance'analyse,
  'AcceptFunc',
  '5_6_8' compare,
  AVG(cat_performance.sim_5_6_8) avg,
  STDDEV(cat_performance.sim_5_6_8) std,
  MIN(cat_performance.sim_5_6_8) min,
  MAX(cat_performance.sim_5_6_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Performance'analyse,
  'AcceptFunc',
  '5_6' compare,
  AVG(cat_performance.sim_5_6) avg,
  STDDEV(cat_performance.sim_5_6) std,
  MIN(cat_performance.sim_5_6) min,
  MAX(cat_performance.sim_5_6) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Performance'analyse,
  'RejectAll',
  '2_4_8' compare,
  AVG(cat_performance.sim_2_4_8) avg,
  STDDEV(cat_performance.sim_2_4_8) std,
  MIN(cat_performance.sim_2_4_8) min,
  MAX(cat_performance.sim_2_4_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Performance'analyse,
  'RejectAll',
  '2_4' compare,
  AVG(cat_performance.sim_2_4) avg,
  STDDEV(cat_performance.sim_2_4) std,
  MIN(cat_performance.sim_2_4) min,
  MAX(cat_performance.sim_2_4) max
FROM
  cookies.sim_cookies_per_visit)
  where compare not like '%_8'
ORDER BY
  analyse,
  gruppe,
  compare ;


-- p7_sim_of_cats_profile

 select * from(

SELECT
  'Functionality' analyse,
  'AcceptAll' gruppe,
  '1_3_7_8' compare,
  cat_func.sim_1_3_7_8 sim
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Functionality' analyse,
  'AcceptAll',
  '1_3_7',
  cat_func.sim_1_3_7
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Functionality' analyse,
  'AcceptFunc',
  '5_6_8' compare,
  cat_func.sim_5_6_8
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Functionality' analyse,
  'AcceptFunc',
  '5_6' compare,
cat_func.sim_5_6
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Functionality' analyse,
  'RejectAll',
  '2_4_8' compare,
cat_func.sim_2_4_8
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Functionality' analyse,
  'RejectAll',
  '2_4' compare,
  cat_func.sim_2_4
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Targeting/Advertising' analyse,
  'AcceptAll' gruppe,
  '1_3_7_8' compare,
  cat_target.sim_1_3_7_8
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Targeting/Advertising' analyse,
  'AcceptAll',
  '1_3_7',
  cat_target.sim_1_3_7
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Targeting/Advertising' analyse,
  'AcceptAll',
  '3_7' compare,
  cat_target.sim_3_7
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Targeting/Advertising' analyse,
  'AcceptFunc',
  '5_6_8' compare,
  cat_target.sim_5_6_8
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Targeting/Advertising' analyse,
  'AcceptFunc',
  '5_6' compare,
  cat_target.sim_5_6
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Targeting/Advertising' analyse,
  'RejectAll',
  '2_4_8' compare,
  cat_target.sim_2_4_8
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Targeting/Advertising' analyse,
  'RejectAll',
  '2_4' compare,
  cat_target.sim_2_4
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Strictly Necessary' analyse,
  'AcceptAll' gruppe,
  '1_3_7_8' compare,
  cat_strict.sim_1_3_7_8
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Strictly Necessary' analyse,
  'AcceptAll',
  '1_3_7',
  cat_strict.sim_1_3_7
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Strictly Necessary' analyse,
  'AcceptAll',
  '3_7' compare,
  cat_strict.sim_3_7
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Strictly Necessary' analyse,
  'AcceptFunc',
  '5_6_8' compare,
  cat_strict.sim_5_6_8
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Strictly Necessary' analyse,
  'AcceptFunc',
  '5_6' compare,
  cat_strict.sim_5_6
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Strictly Necessary' analyse,
  'RejectAll',
  '2_4_8' compare,
  cat_strict.sim_2_4_8
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Strictly Necessary' analyse,
  'RejectAll',
  '2_4' compare,
  cat_strict.sim_2_4
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Performance'analyse,
  'AcceptAll' gruppe,
  '1_3_7_8' compare,
  cat_performance.sim_1_3_7_8
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Performance'analyse,
  'AcceptAll',
  '1_3_7',
  cat_performance.sim_1_3_7
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Performance'analyse,
  'AcceptAll',
  '3_7' compare,
  cat_performance.sim_3_7
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Performance'analyse,
  'AcceptFunc',
  '5_6_8' compare,
  cat_performance.sim_5_6_8
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Performance'analyse,
  'AcceptFunc',
  '5_6' compare,
  cat_performance.sim_5_6
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Performance'analyse,
  'RejectAll',
  '2_4_8' compare,
  cat_performance.sim_2_4_8
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Performance'analyse,
  'RejectAll',
  '2_4' compare,
  cat_performance.sim_2_4
FROM
  cookies.sim_cookies_per_visit)
  where compare not like '%_8' ;

/*
,-
,-
,- --p8_cookie_ops_in_time_pct
*/
/*
create or replace table cookies.tmp_cookies_timeseries as
SELECT
  cookies.fc_getAlias(browser_id) alias,
  REPLACE(replace(record_type,
      'deleted',
      '-1'),'added-or-changed','0') record_type,
  is_third_party,
  in_cookiejar,
  CAST(SAFE_DIVIDE(requests.diff,requests.duration)*100 AS int) time_in_pct
FROM
  cookies.eval_cookies;
*/
SELECT
  duration as time,
  alias as profile,
  is_third_party,
  record_type_all,
  concat(record_type_all,replace(replace(cast(is_third_party as string),'0',' (First-Party Cookie)') ,'1',' (Third-Party Cookie)')) hue,
  COUNT(*) number_of_records
FROM (
  SELECT
    requests.duration duration,
    cookies.fc_getAlias(browser_id) alias,
    is_third_party,
     record_type_all
  FROM
    `your-bigquery-dataset.cookies.eval_cookies`
  WHERE
    requests.duration <31
    AND requests.duration IS NOT NULL
    and is_third_party is not null
    )
GROUP BY
  duration,
  alias,
  is_third_party,
  record_type_all;


-- p9_cookies_per_rank

SELECT
  rank_bucket,
  alias,
  category,
  AVG(ct) avg,
  STDDEV(ct) std,
  MIN(ct) min,
  MAX(ct) max
FROM (
  SELECT
    COUNT(*) ct,
    cookies.fc_getAlias(browser_id) alias,
    browser_id,
    category,
    site_id,
    rank_bucket
  FROM
    cookies.eval_cookies c
  INNER JOIN
    cookies.sites s
  ON
    c.site_id=s.id
  WHERE
    in_cookiejar=1
  GROUP BY
    site_id,
    browser_id,
    category,
    rank_bucket) c
    where alias!='#9'
    and category!='Unknown'
GROUP BY
  category,
  alias,
  rank_bucket
ORDER BY
  category,
  rank_bucket,
  alias;



-- p99_sim_by_rank




SELECT
  'children' sim_group,
  row_id,
  children.sim_all,
  rank_bucket
FROM
  `your-bigquery-dataset.diff.tree_by_chain`
WHERE
  children.ct_0>0
  OR children.ct_1>0
  OR children.ct_2>0
  OR children.ct_3>0
  OR children.ct_4>0
GROUP BY
  rank_bucket,
  row_id,
  children.sim_all
UNION ALL
SELECT
  'parent' sim_group,
  row_id,
  parent.eval_all,
  rank_bucket
FROM
  `your-bigquery-dataset.diff.tree_by_chain`
WHERE
  depth>1
GROUP BY
  rank_bucket,
  row_id,
  parent.eval_all;



-- p10: multiple runs




SELECT
  COUNT(*) ct,
  visit_id,
  measurement_id,
  cookies.fc_getAlias(browser_id) browser_id,
  category
FROM
  cookies2.cookies
WHERE
  measurement_id="1_frankfurt"
  OR measurement_id="2_paris"
  OR measurement_id="3_stockholm"
GROUP BY
  browser_id,
  measurement_id,
  category,visit_id 


union all





SELECT
  COUNT(*) ct,
  visit_id,
  measurement_id,
  cookies.fc_getAlias(browser_id) browser_id,
  'Tracking requests'
FROM
  cookies2.requests
WHERE
  (measurement_id="1_frankfurt"
  OR measurement_id="2_paris"
  OR measurement_id="3_stockholm"
  ) and is_tracker=1
GROUP BY
  browser_id,
  measurement_id,
  visit_id ;




--- p11 stats about omatic in all settings




SELECT
  COUNT(*) ct,
  visit_id,
  browser_id,
  category
FROM
  cookies2.cookies
WHERE
  measurement_id="consent_o_matic_settings"
GROUP BY
  browser_id,
  category,
  visit_id
UNION ALL
SELECT
  COUNT(*) ct,
  visit_id,
  browser_id,
  'Tracking requests'
FROM
  cookies2.requests
WHERE
  measurement_id="consent_o_matic_settings"
GROUP BY
  browser_id,
  visit_id ;

