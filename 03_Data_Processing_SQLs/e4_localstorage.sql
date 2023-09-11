# This SQL is used for conducting evaluation of the local storage.
  -- e4.1 number OF localstorage per site
SELECT
  alias,
  ROUND(AVG(ct),1) avg,
  ROUND(STDDEV(ct),1) stdev,
  ROUND(MIN(ct),1) min,
  ROUND(MAX(ct),1) max,
FROM (
  SELECT
    COUNT(*) ct,
    cookies.fc_getAlias(browser_id) alias,
    site_id
  FROM
    cookies.eval_localstorage
  GROUP BY
    browser_id,
    site_id )
GROUP BY
  alias
ORDER BY
  alias; /*,
  -,
  -,
  -,
  - e4.2 value key leaked IN tracking requests,
  -,
  -,
  -*/
WITH
  category_changes AS (
  SELECT
    'trackers',
    alias,
    ROUND(AVG(ct),1) avg,
    ROUND(STDDEV(ct),1) stdev,
    ROUND(MIN(ct),1) min,
    ROUND(MAX(ct),1) max,
  FROM (
    SELECT
      cookies.fc_getAlias(r.browser_id) alias,
      r.browser_id,
      COUNT(*) ct,
      r.site_id
    FROM
      cookies.eval_requests r
    WHERE
      r.is_tracker=1
    GROUP BY
      r.browser_id,
      r.site_id)
  GROUP BY
    alias )
SELECT
  *,
  (
  SELECT
    ROUND(c1.avg/c2.avg,2) diff
  FROM
    category_changes c2
  WHERE
    c2.alias=c1.alias )
FROM (
  SELECT
    'keyvalue leaked',
    alias,
    ROUND(AVG(ct),1) avg,
    ROUND(STDDEV(ct),1) stdev,
    ROUND(MIN(ct),1) min,
    ROUND(MAX(ct),1) max
  FROM (
    SELECT
      cookies.fc_getAlias(r.browser_id) alias,
      r.browser_id,
      COUNT(*) ct,
      r.site_id
    FROM
      cookies.eval_requests r
    INNER JOIN
      cookies.eval_localstorage l
    ON
      r.site_id = l.site_id
      AND r.browser_id=l.browser_id
    WHERE
      cookies.fc_contains(REPLACE(r.url,NET.HOST(r.url),'#'),
        l.value)
      AND BYTE_LENGTH(l.value)>7
      AND r.is_tracker=1
    GROUP BY
      r.browser_id,
      r.site_id)
  GROUP BY
    alias ) c1
ORDER BY
  alias; /*,
  -,
  -,
  -,
  - e4.4 -- cat 0f leaked ls keys,
  -,
  -,
  - */ # RUN BOTTOM SQL 4ND REPLACE THE TMP TABLE BELLOW
SELECT
  *,
  ROUND(f0_/total,2) pct
FROM (
  SELECT
    *,
    (
    SELECT
      SUM(f0_)
    FROM
      `your-bigquery-dataset._c5b6574eae1819b16fd596d2b4a5a5ca709574cb.anon49183a9cee4f65b4f22fede49418b3fcd561adbe33815010ddcbf5adba2b3f88` c2
    WHERE
      category !='Unknown'
      AND c2.alias=c1.alias
    GROUP BY
      alias) total
  FROM
    `your-bigquery-dataset._c5b6574eae1819b16fd596d2b4a5a5ca709574cb.anon49183a9cee4f65b4f22fede49418b3fcd561adbe33815010ddcbf5adba2b3f88` c1
  WHERE
    category !='Unknown')
ORDER BY
  category; /*,
  -,
  -,
  -,
  - e4.5 total LS per profile -,
  -*/
SELECT
  AVG(ct)
FROM (
  SELECT
    COUNT(*) ct,
    cookies.fc_getAlias(browser_id)
  FROM
    cookies.eval_localstorage
  GROUP BY
    browser_id ) ; /*,
  -,
  -,
  - e4.6 LS per site,
  -,
  -*/
SELECT
  AVG(ct) avg,
  STDDEV(ct) stdev,
  MIN(ct) min,
  MAX(ct) max
FROM (
  SELECT
    COUNT(*) ct
  FROM
    cookies.eval_localstorage
  GROUP BY
    site_id,
    browser_id );


    /*,-
    ,-
    ,- e4.7 LS per site and profile
    */


    SELECT
  AVG(ct),
  alias
FROM (
  SELECT
    COUNT(*) ct,
    cookies.fc_getAlias(browser_id) alias
  FROM
    cookies.eval_localstorage
  GROUP BY
    browser_id,
    site_id )
GROUP BY
  alias
  order by alias;






