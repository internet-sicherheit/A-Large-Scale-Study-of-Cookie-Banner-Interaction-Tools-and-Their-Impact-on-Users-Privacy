# This SQL calculates the similarity between cookies in different profiles
CREATE OR REPLACE TABLE
  cookies.sim_cookies_per_visit AS
SELECT
  visit_id
FROM
  cookies.eval_cookies
WHERE
  in_cookiejar=1
GROUP BY
  visit_id;
ALTER TABLE
  `cookies.sim_cookies_per_visit` ADD COLUMN
IF NOT EXISTS name STRUCT< in_1 string,
  in_2 string,
  in_3 string,
  in_4 string,
  in_5 string,
  in_6 string,
  in_7 string,
  in_8 string,
  in_9 string,
  sim_1_3_7 decimal,
  sim_3_7 decimal,
  sim_1_3_7_8 decimal,
  sim_5_6 decimal,
  sim_5_6_8 decimal,
  sim_2_4 decimal,
  sim_2_4_8 decimal
  >;

  /* sim tests:

  AcceptAll_1: 1*3*7 & 3*7
  AcceptAll_2: 1*3*7*8

  AcceptFunc_1: 5*6
  AcceptFunc_2: 5*6*8

  RejectAll_1: 2*4
  RejectAll_2: 2*4*8 

  */

UPDATE
  `your-bigquery-dataset.cookies.sim_cookies_per_visit` t1
SET
  name.in_1=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_dontcare_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 ),
  name.in_2=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_omaticno_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 ),
  name.in_3=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_omaticall_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 ),
  name.in_4=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_ninja_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 ),
  name.in_5=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_cookieblock_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 ),
  name.in_6=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_superagent_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 ),
  name.in_7=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_customall_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 ),
  name.in_8=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_native_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 ),
  name.in_9=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_native_usa'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 )
WHERE
  TRUE;

  /* sim_1_3_7 decimal,
  sim_3_7 decimal,
  sim_1_3_7_8 decimal,
  sim_5_6 decimal,
  sim_5_6_8 decimal,
  sim_2_4 decimal,
  sim_2_4_8 decimal*/


  
UPDATE
  `your-bigquery-dataset.cookies.sim_cookies_per_visit` t1
SET
  name.sim_1_3_7= cookies.fc_sim_array(CONCAT(IFNULL(name.in_1, ''),'|', IFNULL(name.in_3, ''),'|', IFNULL(name.in_7, '') )),
  name.sim_3_7= cookies.fc_sim_array(CONCAT(IFNULL(name.in_3, ''),'|', IFNULL(name.in_7, ''))),
  name.sim_1_3_7_8= cookies.fc_sim_array(CONCAT(IFNULL(name.in_1, ''),'|', IFNULL(name.in_3, ''),'|', IFNULL(name.in_7, ''),'|', IFNULL(name.in_8, '') )),
  name.sim_5_6= cookies.fc_sim_array(CONCAT(IFNULL(name.in_5, ''),'|', IFNULL(name.in_6, ''))),
  name.sim_5_6_8= cookies.fc_sim_array(CONCAT(IFNULL(name.in_5, ''),'|', IFNULL(name.in_6, ''),'|', IFNULL(name.in_8, '') )),
  name.sim_2_4= cookies.fc_sim_array(CONCAT(IFNULL(name.in_2, ''),'|', IFNULL(name.in_4, ''))),
  name.sim_2_4_8= cookies.fc_sim_array(CONCAT(IFNULL(name.in_2, ''),'|', IFNULL(name.in_4, ''),'|', IFNULL(name.in_1, '') ))
  --,
  -- depth.sim_all= cookies.fc_sim_array(CONCAT(depth.in_0,'|', depth.in_1,'|', depth.in_2,'|', depth.in_3,'|', depth.in_4))
WHERE
  TRUE;
  /*
UPDATE
  `your-bigquery-dataset.cookies.sim_cookies_per_visit` t1
SET
  name.sim_all= (
  SELECT
    CAST(ROUND(AVG(Estimate), 2) AS numeric)
  FROM
    UNNEST([name.sim_0_1, name.sim_0_2, name.sim_0_3, name.sim_0_4, name.sim_1_2, name.sim_1_3, name.sim_1_4, name.sim_2_2, name.sim_2_3, name.sim_2_4, name.sim_3_4]) Estimate )
WHERE
  TRUE;*/




ALTER TABLE
  `cookies.sim_cookies_per_visit` ADD COLUMN 
IF NOT EXISTS cat_strict STRUCT< in_1 string,
  in_2 string,
  in_3 string,
  in_4 string,
  in_5 string,
  in_6 string,
  in_7 string,
  in_8 string,
  in_9 string,
  sim_1_3_7 decimal,
  sim_3_7 decimal,
  sim_1_3_7_8 decimal,
  sim_5_6 decimal,
  sim_5_6_8 decimal,
  sim_2_4 decimal,
  sim_2_4_8 decimal
  >;


UPDATE
  `your-bigquery-dataset.cookies.sim_cookies_per_visit` t1
SET
  cat_strict.in_1=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_dontcare_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 ),
  cat_strict.in_2=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_omaticno_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 ),
  cat_strict.in_3=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_omaticall_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 ),
  cat_strict.in_4=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_ninja_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 ),
  cat_strict.in_5=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_cookieblock_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 ),
  cat_strict.in_6=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_superagent_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 ),
  cat_strict.in_7=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_customall_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 ),
  cat_strict.in_8=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_native_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 ),
  cat_strict.in_9=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_native_usa'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 )
WHERE
  TRUE;



ALTER TABLE
  `cookies.sim_cookies_per_visit` ADD COLUMN 
IF NOT EXISTS cat_func STRUCT< in_1 string,
  in_2 string,
  in_3 string,
  in_4 string,
  in_5 string,
  in_6 string,
  in_7 string,
  in_8 string,
  in_9 string,
  sim_1_3_7 decimal,
  sim_3_7 decimal,
  sim_1_3_7_8 decimal,
  sim_5_6 decimal,
  sim_5_6_8 decimal,
  sim_2_4 decimal,
  sim_2_4_8 decimal
  >;


UPDATE
  `your-bigquery-dataset.cookies.sim_cookies_per_visit` t1
SET
  cat_func.in_1=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_dontcare_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Functionality'
    ),
  cat_func.in_2=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_omaticno_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Functionality'),
  cat_func.in_3=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_omaticall_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Functionality'),
  cat_func.in_4=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_ninja_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Functionality'),
  cat_func.in_5=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_cookieblock_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Functionality'),
  cat_func.in_6=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_superagent_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Functionality'),
  cat_func.in_7=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_customall_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Functionality'),
  cat_func.in_8=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_native_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Functionality'),
  cat_func.in_9=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_native_usa'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Functionality')
WHERE
  TRUE;
  


ALTER TABLE
  `cookies.sim_cookies_per_visit` ADD COLUMN 
IF NOT EXISTS cat_performance STRUCT< in_1 string,
  in_2 string,
  in_3 string,
  in_4 string,
  in_5 string,
  in_6 string,
  in_7 string,
  in_8 string,
  in_9 string,
  sim_1_3_7 decimal,
  sim_3_7 decimal,
  sim_1_3_7_8 decimal,
  sim_5_6 decimal,
  sim_5_6_8 decimal,
  sim_2_4 decimal,
  sim_2_4_8 decimal
  >;


UPDATE
  `your-bigquery-dataset.cookies.sim_cookies_per_visit` t1
SET
  cat_performance.in_1=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_dontcare_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Performance'
    ),
  cat_performance.in_2=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_omaticno_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Performance'),
  cat_performance.in_3=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_omaticall_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Performance'),
  cat_performance.in_4=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_ninja_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Performance'),
  cat_performance.in_5=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_cookieblock_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Performance'),
  cat_performance.in_6=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_superagent_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Performance'),
  cat_performance.in_7=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_customall_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Performance'),
  cat_performance.in_8=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_native_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Performance'),
  cat_performance.in_9=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_native_usa'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Performance')
WHERE
  TRUE;
  

ALTER TABLE
  `cookies.sim_cookies_per_visit` ADD COLUMN 
IF NOT EXISTS cat_target STRUCT< in_1 string,
  in_2 string,
  in_3 string,
  in_4 string,
  in_5 string,
  in_6 string,
  in_7 string,
  in_8 string,
  in_9 string,
  sim_1_3_7 decimal,
  sim_3_7 decimal,
  sim_1_3_7_8 decimal,
  sim_5_6 decimal,
  sim_5_6_8 decimal,
  sim_2_4 decimal,
  sim_2_4_8 decimal
  >;




UPDATE
  `your-bigquery-dataset.cookies.sim_cookies_per_visit` t1
SET
  cat_target.in_1=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_dontcare_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Targeting/Advertising'
    ),
  cat_target.in_2=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_omaticno_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Targeting/Advertising'),
  cat_target.in_3=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_omaticall_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Targeting/Advertising'),
  cat_target.in_4=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_ninja_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Targeting/Advertising'),
  cat_target.in_5=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_cookieblock_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Targeting/Advertising'),
  cat_target.in_6=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_superagent_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Targeting/Advertising'),
  cat_target.in_7=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_customall_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Targeting/Advertising'),
  cat_target.in_8=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_native_eu'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Targeting/Advertising'),
  cat_target.in_9=(
  SELECT
    IFNULL(STRING_AGG(DISTINCT CONCAT(CAST(name AS string),'@',CAST(host AS string) )), NULL)
  FROM
    `your-bigquery-dataset.cookies.eval_cookies` t2
  WHERE
    t2.browser_id='openwpm_native_usa'
    AND t2.visit_id=t1.visit_id
    AND in_cookiejar=1 
    AND category='Targeting/Advertising')
WHERE
  TRUE;
  






/* ,-
SIM TEST*/



UPDATE
  `your-bigquery-dataset.cookies.sim_cookies_per_visit` t1
SET
  cat_performance.sim_1_3_7= cookies.fc_sim_array(CONCAT(IFNULL(cat_performance.in_1, ''),'|', IFNULL(cat_performance.in_3, ''),'|', IFNULL(cat_performance.in_7, '') )),
  cat_performance.sim_3_7= cookies.fc_sim_array(CONCAT(IFNULL(cat_performance.in_3, ''),'|', IFNULL(cat_performance.in_7, ''))),
  cat_performance.sim_1_3_7_8= cookies.fc_sim_array(CONCAT(IFNULL(cat_performance.in_1, ''),'|', IFNULL(cat_performance.in_3, ''),'|', IFNULL(cat_performance.in_7, ''),'|', IFNULL(cat_performance.in_8, '') )),
  cat_performance.sim_5_6= cookies.fc_sim_array(CONCAT(IFNULL(cat_performance.in_5, ''),'|', IFNULL(cat_performance.in_6, ''))),
  cat_performance.sim_5_6_8= cookies.fc_sim_array(CONCAT(IFNULL(cat_performance.in_5, ''),'|', IFNULL(cat_performance.in_6, ''),'|', IFNULL(cat_performance.in_8, '') )),
  cat_performance.sim_2_4= cookies.fc_sim_array(CONCAT(IFNULL(cat_performance.in_2, ''),'|', IFNULL(cat_performance.in_4, ''))),
  cat_performance.sim_2_4_8= cookies.fc_sim_array(CONCAT(IFNULL(cat_performance.in_2, ''),'|', IFNULL(cat_performance.in_4, ''),'|', IFNULL(cat_performance.in_1, '') ))
WHERE
  TRUE;



UPDATE
  `your-bigquery-dataset.cookies.sim_cookies_per_visit` t1
SET
  cat_strict.sim_1_3_7= cookies.fc_sim_array(CONCAT(IFNULL(cat_strict.in_1, ''),'|', IFNULL(cat_strict.in_3, ''),'|', IFNULL(cat_strict.in_7, '') )),
  cat_strict.sim_3_7= cookies.fc_sim_array(CONCAT(IFNULL(cat_strict.in_3, ''),'|', IFNULL(cat_strict.in_7, ''))),
  cat_strict.sim_1_3_7_8= cookies.fc_sim_array(CONCAT(IFNULL(cat_strict.in_1, ''),'|', IFNULL(cat_strict.in_3, ''),'|', IFNULL(cat_strict.in_7, ''),'|', IFNULL(cat_strict.in_8, '') )),
  cat_strict.sim_5_6= cookies.fc_sim_array(CONCAT(IFNULL(cat_strict.in_5, ''),'|', IFNULL(cat_strict.in_6, ''))),
  cat_strict.sim_5_6_8= cookies.fc_sim_array(CONCAT(IFNULL(cat_strict.in_5, ''),'|', IFNULL(cat_strict.in_6, ''),'|', IFNULL(cat_strict.in_8, '') )),
  cat_strict.sim_2_4= cookies.fc_sim_array(CONCAT(IFNULL(cat_strict.in_2, ''),'|', IFNULL(cat_strict.in_4, ''))),
  cat_strict.sim_2_4_8= cookies.fc_sim_array(CONCAT(IFNULL(cat_strict.in_2, ''),'|', IFNULL(cat_strict.in_4, ''),'|', IFNULL(cat_strict.in_1, '') ))
WHERE
  TRUE;
  



UPDATE
  `your-bigquery-dataset.cookies.sim_cookies_per_visit` t1
SET
  cat_target.sim_1_3_7= cookies.fc_sim_array(CONCAT(IFNULL(cat_target.in_1, ''),'|', IFNULL(cat_target.in_3, ''),'|', IFNULL(cat_target.in_7, '') )),
  cat_target.sim_3_7= cookies.fc_sim_array(CONCAT(IFNULL(cat_target.in_3, ''),'|', IFNULL(cat_target.in_7, ''))),
  cat_target.sim_1_3_7_8= cookies.fc_sim_array(CONCAT(IFNULL(cat_target.in_1, ''),'|', IFNULL(cat_target.in_3, ''),'|', IFNULL(cat_target.in_7, ''),'|', IFNULL(cat_target.in_8, '') )),
  cat_target.sim_5_6= cookies.fc_sim_array(CONCAT(IFNULL(cat_target.in_5, ''),'|', IFNULL(cat_target.in_6, ''))),
  cat_target.sim_5_6_8= cookies.fc_sim_array(CONCAT(IFNULL(cat_target.in_5, ''),'|', IFNULL(cat_target.in_6, ''),'|', IFNULL(cat_target.in_8, '') )),
  cat_target.sim_2_4= cookies.fc_sim_array(CONCAT(IFNULL(cat_target.in_2, ''),'|', IFNULL(cat_target.in_4, ''))),
  cat_target.sim_2_4_8= cookies.fc_sim_array(CONCAT(IFNULL(cat_target.in_2, ''),'|', IFNULL(cat_target.in_4, ''),'|', IFNULL(cat_target.in_1, '') ))
WHERE
  TRUE;



UPDATE
  `your-bigquery-dataset.cookies.sim_cookies_per_visit` t1
SET
  cat_func.sim_1_3_7= cookies.fc_sim_array(CONCAT(IFNULL(cat_func.in_1, ''),'|', IFNULL(cat_func.in_3, ''),'|', IFNULL(cat_func.in_7, '') )),
  cat_func.sim_3_7= cookies.fc_sim_array(CONCAT(IFNULL(cat_func.in_3, ''),'|', IFNULL(cat_func.in_7, ''))),
  cat_func.sim_1_3_7_8= cookies.fc_sim_array(CONCAT(IFNULL(cat_func.in_1, ''),'|', IFNULL(cat_func.in_3, ''),'|', IFNULL(cat_func.in_7, ''),'|', IFNULL(cat_func.in_8, '') )),
  cat_func.sim_5_6= cookies.fc_sim_array(CONCAT(IFNULL(cat_func.in_5, ''),'|', IFNULL(cat_func.in_6, ''))),
  cat_func.sim_5_6_8= cookies.fc_sim_array(CONCAT(IFNULL(cat_func.in_5, ''),'|', IFNULL(cat_func.in_6, ''),'|', IFNULL(cat_func.in_8, '') )),
  cat_func.sim_2_4= cookies.fc_sim_array(CONCAT(IFNULL(cat_func.in_2, ''),'|', IFNULL(cat_func.in_4, ''))),
  cat_func.sim_2_4_8= cookies.fc_sim_array(CONCAT(IFNULL(cat_func.in_2, ''),'|', IFNULL(cat_func.in_4, ''),'|', IFNULL(cat_func.in_1, '') ))
  WHERE
  TRUE;

 