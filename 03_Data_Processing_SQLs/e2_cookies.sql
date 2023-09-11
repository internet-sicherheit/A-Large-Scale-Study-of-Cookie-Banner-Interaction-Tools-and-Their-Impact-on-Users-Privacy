# This SQL is used for conducting a general analysis of the cookies.
  # Cookie analysis --e2.1 1st vs 3rd-party: cookies per webpage
WITH
  category_changes AS (
  SELECT
    COUNT(*) ct,
    cookies.fc_getAlias(browser_id) alias,
    visit_id,
    is_third_party
  FROM
    cookies.eval_cookies
  WHERE
    in_cookiejar=1
  GROUP BY
    browser_id,
    visit_id,
    is_third_party)
SELECT
  alias,
  is_third_party,
  ROUND(AVG(diff),1) avg,
  ROUND(STDDEV(diff),1) stdev,
  ROUND(MIN(diff),1) min,
  ROUND(MAX(diff),1) max,
FROM (
  SELECT
    *,
    ct AS diff
  FROM
    category_changes c1 )
GROUP BY
  alias,
  is_third_party
ORDER BY
  is_third_party,
  alias; /*,
  -,
  --- e2.2 1st vs 3rd-party: changes per profile,
  - - */
WITH
  category_changes AS (
  SELECT
    COUNT(*) ct,
    cookies.fc_getAlias(browser_id) alias,
    visit_id,
    is_third_party
  FROM
    cookies.eval_cookies
  WHERE
    in_cookiejar=1
  GROUP BY
    browser_id,
    visit_id,
    is_third_party)
SELECT
  alias,
  is_third_party,
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
        AND c1.is_third_party=c2.is_third_party
        AND c1.visit_id=c2.visit_id) ) diff
  FROM
    category_changes c1 )
GROUP BY
  alias,
  is_third_party
ORDER BY
  is_third_party,
  alias; /*,
  ,
  -,
  -,
  - --e2.3 cookie categories per 1st-3rd party,
  -,
  -,
  - */
WITH
  category_changes AS (
  SELECT
    COUNT(*) ct,
    cookies.fc_getAlias(browser_id) alias,
    visit_id,
    is_third_party,
    category
  FROM
    cookies.eval_cookies
  WHERE
    in_cookiejar=1
  GROUP BY
    browser_id,
    visit_id,
    is_third_party,
    category)
SELECT
  alias,
  is_third_party,
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
        AND c1.is_third_party=c2.is_third_party
        AND c1.visit_id=c2.visit_id
        AND c1.category=c2.category) ) diff
  FROM
    category_changes c1 )
GROUP BY
  alias,
  is_third_party,
  category
ORDER BY
  category,
  is_third_party,
  alias; /*,
  -,
  -,
  -,
  - e2.4: number OF cookies per site
  AND category,
  -,
  -,
  -*/
SELECT
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
    category
  FROM
    cookies.eval_cookies
  WHERE
    in_cookiejar=1
  GROUP BY
    site_id,
    browser_id,
    category)
GROUP BY 
  category,alias
  order by category,alias