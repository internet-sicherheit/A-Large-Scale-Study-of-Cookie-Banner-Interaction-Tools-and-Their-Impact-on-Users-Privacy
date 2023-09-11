# This SQL is used for conducting evaluation on our own extension.
  -- e10.0 number OF CB
WITH
  custom extension
SELECT
  COUNT(*)
FROM
  `your-bigquery-dataset.cookies.sites`
WHERE
  log_customall IS NOT NULL
  AND in_scope = 1; /*,
  -,
  -,
  -,
  -- e10.1 tracking requests,
  -*/
SELECT
  ROUND(AVG(ct),1) avg,
  STDDEV(ct) stdev,
  MIN(ct) min,
  MAX(ct) max,
  alias
FROM (
  SELECT
    COUNT(*) ct,
    cookies.fc_getAlias(browser_id) alias
  FROM
    cookies.eval_requests
  WHERE
    is_tracker=1
    AND site_id IN (
    SELECT
      id
    FROM
      `your-bigquery-dataset.cookies.sites`
    WHERE
      log_customall IS NOT NULL
      AND in_scope = 1 )
  GROUP BY
    visit_id,
    browser_id)
GROUP BY
  alias
ORDER BY
  alias; /*,
  -,
  -,
  - -- e10.2 cookie cat types,
  - */
WITH
  category_changes AS (
  SELECT
    COUNT(*) ct,
    cookies.fc_getAlias(browser_id) alias,
    visit_id,
    category
  FROM
    cookies.eval_cookies
  WHERE
    in_cookiejar=1
    AND site_id IN (
    SELECT
      id
    FROM
      `your-bigquery-dataset.cookies.sites`
    WHERE
      log_customall IS NOT NULL
      AND in_scope = 1 )
  GROUP BY
    browser_id,
    visit_id,
    category)
SELECT
  alias,
  category,
  ROUND(AVG(diff),2) avg,
  ROUND(STDDEV(diff),2) stdev,
  ROUND(MIN(diff),2) min,
  ROUND(MAX(diff),2) max,
FROM (
  SELECT
    *,
    ( ct/(
      SELECT
        ct AS c_8
      FROM
        category_changes c2
      WHERE
        alias='#8'
        AND c1.visit_id=c2.visit_id
        AND c1.category=c2.category) ) diff
  FROM
    category_changes c1 )
WHERE
  category !='Unknown'
GROUP BY
  alias,
  category
ORDER BY
  category,
  alias,
  avg