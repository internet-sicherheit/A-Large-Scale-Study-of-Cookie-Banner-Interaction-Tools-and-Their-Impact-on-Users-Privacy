# This SQL is used to generate the data for the statistical calculations used in the paper.
  -- s1 Σ cookies vs. profile -- s1_cookies_vs_profile
SELECT
  COUNT(*) ct,
  cookies.fc_getAlias(browser_id) alias,
FROM
  cookies.eval_cookies
WHERE
  in_cookiejar=1
GROUP BY
  browser_id,
  visit_id; /*,
  -,
  -,
  -,
  - s2: Σ 1st & 3rd party cookies vs. profile,
  - s2_1s-3rd_vs_profile - */
SELECT
  COUNT(*) ct,
  cookies.fc_getAlias(browser_id) alias,
  is_third_party
FROM
  cookies.eval_cookies
WHERE
  in_cookiejar=1
GROUP BY
  is_third_party,
  browser_id,
  visit_id;/*,
  -,
  -,
  -,
  - s3: Σ cat cookies vs. profile,
  s3_cat_cookies_vs_profile - */
SELECT
  cookies.fc_getAlias(browser_id) alias,
  COUNT(*) ct,
  category
FROM
  cookies.eval_cookies
WHERE
  in_cookiejar=1
GROUP BY
  category,
  browser_id,
  visit_id; /*,
  -,
  -,
  -,
  - s4: Σ local_storage vs. profile,
  s4_localstorage_vs_profile - */
SELECT
  REPLACE(cookies.fc_getAlias(browser_id),'#','') alias,
  COUNT(*) ct,
FROM
  cookies.eval_localstorage
GROUP BY
  browser_id,
  site_id; /*,
  -,
  -,
  -,
  - s5: Σ tracking vs. profile,
  s5_tracking_vs_profile - */
SELECT
  REPLACE(cookies.fc_getAlias(browser_id),'#','') alias,
  COUNT(*) ct,
FROM
  cookies.eval_requests
GROUP BY
  browser_id,
  visit_id; /*,
  -,
  -,
  - -- s7_localstorage_vs_profile */
SELECT
  COUNT(*) ct,
  cookies.fc_getAlias(browser_id)
FROM
  cookies.eval_localstorage
GROUP BY
  site_id,
  browser_id; /*,
  -,
  -,
  -,
  - s8_cat_ls_vs_profile,
  - */
SELECT
  cookies.fc_getAlias(browser_id) alias,
  COUNT(*) ct,
  category
FROM
  cookies.eval_localstorage
GROUP BY
  category,
  browser_id,
  site_id;



  /*,-
  ,-
  ,-
  ,- s9_tracking_vs_profile
  ,- 
  */



  SELECT
  COUNT(*) ct,
  cookies.fc_getAlias(browser_id) alias
FROM
  cookies.eval_requests
WHERE
  is_tracker=1
GROUP BY
  visit_id,
  browser_id;

  




  