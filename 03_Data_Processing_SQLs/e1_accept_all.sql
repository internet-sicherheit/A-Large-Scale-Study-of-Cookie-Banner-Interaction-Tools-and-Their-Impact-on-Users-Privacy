# This SQL is used for evaluating the accept-all (#1, #3, #7, #8) profiles

  /*,
  -- e1.0: our custom profil ALL profiles*/
SELECT
  COUNT(*) ct,
  COUNT(*)/(
  SELECT
    COUNT(*)
  FROM
    cookies.eval_sites) pct
FROM
  cookies.eval_sites
WHERE
  acceptall_logs IS NOT NULL
  AND JSON_VALUE(acceptall_logs,'$.AcceptAllFired')='True'; --,
  /*,
  -- e1.1 number OF total cookies FOR accept ALL*/
SELECT
  cookies.fc_getAlias(browser_id) alias,
  COUNT(*)
FROM
  cookies.eval_cookies
WHERE
  (cookies.fc_getAlias(browser_id)='#1'
    OR cookies.fc_getAlias(browser_id)='#3'
    OR cookies.fc_getAlias(browser_id)='#7')
  AND in_cookiejar=1
GROUP BY
  browser_id
ORDER BY
  alias; /*,
  -- e1.1 number OF total cookies FOR accept ALL*/
SELECT
  cookies.fc_getAlias(browser_id) alias,
  COUNT(*) ct
FROM
  cookies.eval_cookies
WHERE
  (cookies.fc_getAlias(browser_id)='#1'
    OR cookies.fc_getAlias(browser_id)='#3'
    OR cookies.fc_getAlias(browser_id)='#7'
    OR cookies.fc_getAlias(browser_id)='#8')
  AND in_cookiejar=1
GROUP BY
  browser_id
ORDER BY
  alias; /*,
  --e1.2 number OF cookies per site*/
SELECT
  alias,
  AVG(ct) avg,
  STDDEV(ct) stdev,
  MIN(ct) min,
  MAX(ct) max
FROM (
  SELECT
    cookies.fc_getAlias(browser_id) alias,
    COUNT(*) ct
  FROM
    cookies.eval_cookies c2
  WHERE
    (cookies.fc_getAlias(browser_id)='#1'
      OR cookies.fc_getAlias(browser_id)='#3'
      OR cookies.fc_getAlias(browser_id)='#7'
      OR cookies.fc_getAlias(browser_id)='#8')
    AND in_cookiejar=1
  GROUP BY
    browser_id,
    visit_id )
GROUP BY
  alias
ORDER BY
  alias; #COOKIE CATEGORIES /*,
  --e1.3 categories OF cookies per visit 4nd changes*/
WITH
  category_changes AS (
  SELECT
    ROUND(AVG(ct),2) avg,
    category,
    browser_id,
    cookies.fc_getAlias(browser_id) alias,
  FROM (
    SELECT
      COUNT(*) ct,
      category,
      browser_id
    FROM
      cookies.eval_cookies
    WHERE
      (cookies.fc_getAlias(browser_id)='#1'
        OR cookies.fc_getAlias(browser_id)='#3'
        OR cookies.fc_getAlias(browser_id)='#7'
        OR cookies.fc_getAlias(browser_id)='#8')
      AND in_cookiejar=1
    GROUP BY
      browser_id,
      visit_id,
      category)
  GROUP BY
    category,
    browser_id )
SELECT
  *,
  ROUND((
    SELECT
      avg/(
      SELECT
        avg
      FROM
        category_changes c2
      WHERE
        alias='#8'
        AND c1.category=c2.category )-1 ),2) change
FROM
  category_changes c1
ORDER BY
  category,
  alias ASC ; /*,
  -- 1.4 accept-ALL third-party */
WITH
  category_changes AS (
  SELECT
    ROUND(AVG(ct),2) avg,
    category,
    is_third_party,
    browser_id,
    cookies.fc_getAlias(browser_id) alias,
  FROM (
    SELECT
      COUNT(*) ct,
      category,
      browser_id,
      is_third_party
    FROM
      cookies.eval_cookies
    WHERE
      (cookies.fc_getAlias(browser_id)='#1'
        OR cookies.fc_getAlias(browser_id)='#3'
        OR cookies.fc_getAlias(browser_id)='#7'
        OR cookies.fc_getAlias(browser_id)='#8')
      AND in_cookiejar=1
    GROUP BY
      is_third_party,
      browser_id,
      visit_id,
      category)
  GROUP BY
    is_third_party,
    category,
    browser_id )
SELECT
  *,
  ROUND((
    SELECT
      avg/(
      SELECT
        avg
      FROM
        category_changes c2
      WHERE
        alias='#8'
        AND c1.category=c2.category
        AND c1.is_third_party=c2.is_third_party )-1 ),2) change
FROM
  category_changes c1
ORDER BY
  category,
  is_third_party,
  alias ASC ; /*,
  -,
  -,
  - e1.4.1 third-party vs FIRST-party,
  -,
  -*/
WITH
  category_changes AS (
  SELECT
    ROUND(AVG(ct),2) avg,
    is_third_party,
    browser_id,
    cookies.fc_getAlias(browser_id) alias,
  FROM (
    SELECT
      COUNT(*) ct,
      browser_id,
      is_third_party
    FROM
      cookies.eval_cookies
    WHERE
      (cookies.fc_getAlias(browser_id)='#1'
        OR cookies.fc_getAlias(browser_id)='#3'
        OR cookies.fc_getAlias(browser_id)='#7'
        OR cookies.fc_getAlias(browser_id)='#8')
      AND in_cookiejar=1
    GROUP BY
      is_third_party,
      browser_id,
      visit_id )
  GROUP BY
    is_third_party,
    browser_id )
SELECT
  *,
  ROUND((
    SELECT
      avg/(
      SELECT
        avg
      FROM
        category_changes c2
      WHERE
        alias='#8'
        AND c1.is_third_party=c2.is_third_party )-1 ),2) change
FROM
  category_changes c1
ORDER BY
  is_third_party,
  alias ASC ; /*,
  #,
  #,
  # LocalStorage */ /*,
  -- e1.5 localstorage per site */
SELECT
  AVG(ct) avg,
  STDDEV(ct) stdv,
  MIN(ct) min,
  MAX(ct) max,
  alias
FROM (
  SELECT
    COUNT(*) ct,
    cookies.fc_getAlias(browser_id) alias,
    site_id
  FROM
    cookies.eval_localstorage
  WHERE
    cookies.fc_getAlias(browser_id)='#1'
    OR cookies.fc_getAlias(browser_id)='#3'
    OR cookies.fc_getAlias(browser_id)='#7'
    OR cookies.fc_getAlias(browser_id)='#8'
  GROUP BY
    browser_id,
    site_id)
GROUP BY
  alias
ORDER BY
  alias; /*,
  --e1.6: third-party localstorage per site */
WITH
  localstorage_changes AS (
  SELECT
    AVG(ct) avg,
    STDDEV(ct) stdv,
    MIN(ct) min,
    MAX(ct) max,
    alias,
    is_third_party
  FROM (
    SELECT
      COUNT(*) ct,
      cookies.fc_getAlias(browser_id) alias,
      site_id,
      is_third_party
    FROM
      cookies.eval_localstorage
    WHERE
      cookies.fc_getAlias(browser_id)='#1'
      OR cookies.fc_getAlias(browser_id)='#3'
      OR cookies.fc_getAlias(browser_id)='#7'
      OR cookies.fc_getAlias(browser_id)='#8'
    GROUP BY
      browser_id,
      site_id,
      is_third_party)
  GROUP BY
    alias,
    is_third_party
  ORDER BY
    is_third_party,
    alias )
SELECT
  *,
  ROUND((
    SELECT
      avg/(
      SELECT
        avg
      FROM
        localstorage_changes c2
      WHERE
        alias='#8'
        AND c1.is_third_party=c2.is_third_party )-1 ),2) change
FROM
  localstorage_changes c1
ORDER BY
  is_third_party,
  alias ASC ; /*,
  #,
  #,
  # Tracking Requests */ /*,
  -- e1.7: http traffic */
WITH
  tracking_changes AS (
  SELECT
    AVG(ct) avg,
    STDDEV(ct) stdv,
    MIN(ct) min,
    MAX(ct) max,
    alias
  FROM (
    SELECT
      COUNT(*) ct,
      cookies.fc_getAlias(browser_id) alias,
      visit_id
    FROM
      cookies.eval_requests
    WHERE
      cookies.fc_getAlias(browser_id)='#1'
      OR cookies.fc_getAlias(browser_id)='#3'
      OR cookies.fc_getAlias(browser_id)='#7'
      OR cookies.fc_getAlias(browser_id)='#8'
    GROUP BY
      browser_id,
      visit_id)
  GROUP BY
    alias
  ORDER BY
    alias )
SELECT
  *,
  ROUND((
    SELECT
      avg/(
      SELECT
        avg
      FROM
        tracking_changes c2
      WHERE
        alias='#8' )-1 ),2) change
FROM
  tracking_changes c1
ORDER BY
  alias ASC ; /*,
  -- e1.8: changes BY FIRST-party vs third-party*/
WITH
  tracking_changes AS (
  SELECT
    AVG(ct) avg,
    STDDEV(ct) stdv,
    MIN(ct) min,
    MAX(ct) max,
    alias,
    is_third_party_channel
  FROM (
    SELECT
      COUNT(*) ct,
      cookies.fc_getAlias(browser_id) alias,
      visit_id,
      is_third_party_channel
    FROM
      cookies.eval_requests
    WHERE
      cookies.fc_getAlias(browser_id)='#1'
      OR cookies.fc_getAlias(browser_id)='#3'
      OR cookies.fc_getAlias(browser_id)='#7'
      OR cookies.fc_getAlias(browser_id)='#8'
    GROUP BY
      browser_id,
      visit_id,
      is_third_party_channel)
  GROUP BY
    alias,
    is_third_party_channel
  ORDER BY
    is_third_party_channel,
    alias )
SELECT
  *,
  ROUND((
    SELECT
      avg/(
      SELECT
        avg
      FROM
        tracking_changes c2
      WHERE
        alias='#8'
        AND c1.is_third_party_channel=c2.is_third_party_channel )-1 ),2) change
FROM
  tracking_changes c1
ORDER BY
  is_third_party_channel,
  alias ASC ; /* -- e1.9: resource types */ --third-party
WITH
  tracking_changes AS (
  SELECT
    AVG(ct) avg,
    STDDEV(ct) stdv,
    MIN(ct) min,
    MAX(ct) max,
    alias,
    resource_type
  FROM (
    SELECT
      COUNT(*) ct,
      cookies.fc_getAlias(browser_id) alias,
      visit_id,
      resource_type
    FROM
      cookies.eval_requests
    WHERE
      cookies.fc_getAlias(browser_id)='#1'
      OR cookies.fc_getAlias(browser_id)='#3'
      OR cookies.fc_getAlias(browser_id)='#7'
      OR cookies.fc_getAlias(browser_id)='#8'
    GROUP BY
      browser_id,
      visit_id,
      resource_type)
  GROUP BY
    alias,
    resource_type
  ORDER BY
    resource_type,
    alias )
SELECT
  *,
  ROUND((
    SELECT
      avg/(
      SELECT
        avg
      FROM
        tracking_changes c2
      WHERE
        alias='#8'
        AND c1.resource_type=c2.resource_type )-1 ),2) change
FROM
  tracking_changes c1
ORDER BY
  change,
  resource_type,
  alias ASC ; /*,
  -- e1.10: tracking changes */
WITH
  tracking_changes AS (
  SELECT
    AVG(ct) avg,
    STDDEV(ct) stdv,
    MIN(ct) min,
    MAX(ct) max,
    alias,
    is_tracker
  FROM (
    SELECT
      COUNT(*) ct,
      cookies.fc_getAlias(browser_id) alias,
      visit_id,
      is_tracker
    FROM
      cookies.eval_requests
    WHERE
      cookies.fc_getAlias(browser_id)='#1'
      OR cookies.fc_getAlias(browser_id)='#3'
      OR cookies.fc_getAlias(browser_id)='#7'
      OR cookies.fc_getAlias(browser_id)='#8'
    GROUP BY
      browser_id,
      visit_id,
      is_tracker)
  GROUP BY
    alias,
    is_tracker
  ORDER BY
    is_tracker,
    alias )
SELECT
  *,
  ROUND((
    SELECT
      avg/(
      SELECT
        avg
      FROM
        tracking_changes c2
      WHERE
        alias='#8'
        AND c1.is_tracker=c2.is_tracker )-1 ),2) change
FROM
  tracking_changes c1
ORDER BY
  is_tracker,
  alias ASC ; /*,
  --e1.11: si 0f group AcceptAll
  -,
  - */


SELECT
  '1_3_7_8' compare,
  AVG(name.sim_1_3_7_8) avg,
  STDDEV(name.sim_1_3_7_8) std,
  MIN(name.sim_1_3_7_8) min,
  MAX(name.sim_1_3_7_8) max
FROM
  cookies.sim_cookies_per_visit

union all
select
  '1_3_7',
  AVG(name.sim_1_3_7) avg,
  STDDEV(name.sim_1_3_7) std,
  MIN(name.sim_1_3_7) min,
  MAX(name.sim_1_3_7) max
FROM
  cookies.sim_cookies_per_visit

union all
select
  '3_7' compare,
  AVG(name.sim_3_7) avg,
  STDDEV(name.sim_3_7) std,
  MIN(name.sim_3_7) min,
  MAX(name.sim_3_7) max
FROM
  cookies.sim_cookies_per_visit order by compare;



