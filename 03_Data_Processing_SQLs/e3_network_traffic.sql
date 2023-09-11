# This SQL is used for conducting evaluation of the network traffic.

  -- e3.1 number OF reqests per site
SELECT
  alias,
  AVG(ct) avg,
  STDDEV(ct) stdv,
  MIN(ct) min,
  MAX(ct) max
FROM (
  SELECT
    COUNT(*) ct,
    cookies.fc_getAlias(browser_id) alias
  FROM
    cookies.eval_requests
  GROUP BY
    site_id,
    browser_id )
GROUP BY
  alias
ORDER BY
  alias; /*,
  -,
  -,
  -,
  -- e3.2 number OF tracking requests per site.,
  -,
  -,
  -*/
SELECT
  alias,
  AVG(ct) avg,
  STDDEV(ct) stdv,
  MIN(ct) min,
  MAX(ct) max
FROM (
  SELECT
    COUNT(*) ct,
    cookies.fc_getAlias(browser_id) alias
  FROM
    cookies.eval_requests
  WHERE
    is_tracker=1
  GROUP BY
    site_id,
    browser_id )
GROUP BY
  alias
ORDER BY
  alias