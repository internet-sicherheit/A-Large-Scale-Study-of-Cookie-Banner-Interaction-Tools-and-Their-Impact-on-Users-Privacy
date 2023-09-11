# This SQL is used for conducting evaluation of the tracking requests.
  /*,
  -,
  -,
  - e9.1 number OF requests per site,
  -,
  - */
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
  GROUP BY
    visit_id,
    browser_id)
GROUP BY
  alias
ORDER BY
  alias; /*,
  -,
  -,
  - e9.2 number OF tracking requests per site,
  -,
  - */
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
  GROUP BY
    visit_id,
    browser_id)
GROUP BY
  alias
ORDER BY
  alias;
   