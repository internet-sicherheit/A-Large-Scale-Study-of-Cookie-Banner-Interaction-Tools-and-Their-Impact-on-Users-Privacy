# This SQL is used for conducting evaluation of profiles for accepting functional cookies (#5 #6 #8).

-- number of cookies
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
    (cookies.fc_getAlias(browser_id)='#5'
      OR cookies.fc_getAlias(browser_id)='#6'
      OR cookies.fc_getAlias(browser_id)='#8')
    AND in_cookiejar=1
  GROUP BY
    browser_id,
    visit_id )
GROUP BY
  alias
ORDER BY
  alias; #COOKIE CATEGORIES /*,
  --e5.2 categories OF cookies per visit 4nd changes*/
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
      ( cookies.fc_getAlias(browser_id)='#5'
        OR cookies.fc_getAlias(browser_id)='#6'
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
  alias ASC ; 
  

  
    /*,
  -,
  -,
  -,
  - e5.3 1st-party vs 3rd-party,
  -,
  - */
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
      (cookies.fc_getAlias(browser_id)='#5'
        OR cookies.fc_getAlias(browser_id)='#6'
        OR cookies.fc_getAlias(browser_id)='#8')
      AND in_cookiejar=1
    GROUP BY
      is_third_party,
      browser_id,
      visit_id)
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
  alias ASC;


  
  
  
  
  
  /*,
  -,
  - e5.4 number OF removed cookies,
  -,
  - */

select avg(ct), cookies.fc_getAlias(browser_id) alias from (

select count (*) ct,browser_id from
cookies.eval_cookies where

record_type='deleted'
group by browser_id,site_id
)
group by browser_id order by alias;


  /*,
  -,
  - e5.5 number OF http requests
  -,
  - */
  WITH
  http_changes AS (
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
      cookies.fc_getAlias(browser_id)='#5'
      OR cookies.fc_getAlias(browser_id)='#6'
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
        http_changes c2
      WHERE
        alias='#8' )-1 ),2) change
FROM
  http_changes c1
ORDER BY
  alias ASC ;


/*-,
,-
,-
-- e5.6 - sim tests

*/



SELECT
  '5_6' compare,
  AVG(name.sim_5_6) avg,
  STDDEV(name.sim_5_6) std,
  MIN(name.sim_5_6) min,
  MAX(name.sim_5_6) max
FROM
  cookies.sim_cookies_per_visit

union all
select
  '5_6_8',
  AVG(name.sim_5_6_8) avg,
  STDDEV(name.sim_5_6_8) std,
  MIN(name.sim_5_6_8) min,
  MAX(name.sim_5_6_8) max
FROM
  cookies.sim_cookies_per_visit
 order by compare;

 