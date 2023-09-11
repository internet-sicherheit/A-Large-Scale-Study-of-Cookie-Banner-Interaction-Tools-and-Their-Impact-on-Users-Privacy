# This SQL is used to conduct evaluations on cookie types.

  -- e8.1 high level cookie cat changes per profile excpet #5
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
  GROUP BY
    browser_id,
    visit_id,
    category)
SELECT
  category,
  AVG(avg)
FROM (
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
    alias !='#9'
    AND alias !='#5'
    AND category !='Unknown'
  GROUP BY
    alias,
    category
  ORDER BY
    category,
    alias,
    avg)
GROUP BY
  category; /*,
  -,
  ,
  - e8.2 cookie cats changes BY FIRST vs third party,
  -,
  -*/
WITH
  category_changes AS (
  SELECT
    COUNT(*) ct,
    cookies.fc_getAlias(browser_id) alias,
    visit_id,
    category,
    is_third_party
  FROM
    cookies.eval_cookies
  WHERE
    in_cookiejar=1
  GROUP BY
    browser_id,
    visit_id,
    category,
    is_third_party)
SELECT
  category,
  is_third_party,
  AVG(avg)
FROM (
  SELECT
    alias,
    category,
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
          AND c1.visit_id=c2.visit_id
          AND c1.category=c2.category
          AND c1.is_third_party=c2.is_third_party) ) diff
    FROM
      category_changes c1 )
  WHERE
    alias !='#9'
    AND alias !='#5'
    AND category !='Unknown'
  GROUP BY
    alias,
    is_third_party,
    category
  ORDER BY
    category,
    alias,
    avg)
GROUP BY
  category,
  is_third_party
ORDER BY
  is_third_party; /*,
  -,
  -,
  - e8.3 baselien profile number OF cookies per cat,
  - */
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
  category,
  alias
ORDER BY
  category,
  alias; /*,
  -,
  -,
  -,
  - e8.5 category changes,
  -,
  -,
  - */
WITH
  category_changes AS (
  SELECT
    COUNT(*) ct,
    cookies.fc_getAlias(browser_id) alias,
    site_id,
    category
  FROM
    cookies.eval_localstorage 
  GROUP BY
    browser_id,
    site_id,
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
        AND c1.site_id=c2.site_id
        AND c1.category=c2.category) ) diff
  FROM
    category_changes c1 )
WHERE
  alias !='#9'
GROUP BY
  alias,
  category
ORDER BY
  category,
  alias,
  avg;






  