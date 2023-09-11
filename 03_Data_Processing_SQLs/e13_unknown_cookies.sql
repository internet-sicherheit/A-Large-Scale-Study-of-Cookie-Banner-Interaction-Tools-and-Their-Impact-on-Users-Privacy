# This SQL is used for conducting evaluation of the unknown cookies.
  /*,
  -,
  -,
  - e13.0 number OF total cookies,
  -,
  -*/
SELECT
  COUNT(*) ct,
  COUNT(*)/(
  SELECT
    COUNT(*)
  FROM
    cookies.eval_cookies ) pct
FROM
  cookies.eval_cookies
WHERE
  category='Unknown'; -- e13.1 third_party
SELECT
  is_third_party,
  category,
  COUNT(*),
  SAFE_DIVIDE(COUNT(*),(
    SELECT
      COUNT(*)
    FROM
      cookies.eval_cookies e2
    WHERE
      e2.category=e1.category
      AND in_cookiejar=1)) pct
FROM
  `your-bigquery-dataset.cookies.eval_cookies` e1
WHERE
  in_cookiejar=1
GROUP BY
  is_third_party,
  category
ORDER BY
  category,
  is_third_party; --13.2 BY is_session
SELECT
  is_session,
  category,
  COUNT(*),
  SAFE_DIVIDE(COUNT(*),(
    SELECT
      COUNT(*)
    FROM
      cookies.eval_cookies e2
    WHERE
      e2.category=e1.category
      AND in_cookiejar=1)) pct
FROM
  `your-bigquery-dataset.cookies.eval_cookies` e1
WHERE
  in_cookiejar=1
GROUP BY
  is_session,
  category
ORDER BY
  category,
  is_session; /*,
  ,
  -,
   13.3 ---- uniq*/
SELECT
  COUNT(*) ct,
  round((COUNT(*)/(select count(*) from cookies.eval_cookies where in_cookiejar=1))*100,2) pct,
  (
  SELECT
    COUNT(*)
  FROM
    cookies.eval_cookies
  WHERE in_cookiejar=1),
  name
FROM
  cookies.eval_cookies
WHERE
  in_cookiejar=1
  AND category='Unknown'
GROUP BY
  name
ORDER BY
  COUNT(*) DESC;

/* e13.3.1 -- uniq %
*/


select count(*) from (SELECT
  COUNT(*) ct,
  round((COUNT(*)/(select count(*) from cookies.eval_cookies where in_cookiejar=1))*100,2) pct,
  (
  SELECT
    COUNT(*)
  FROM
    cookies.eval_cookies
  WHERE in_cookiejar=1),
  name
FROM
  cookies.eval_cookies
WHERE
  in_cookiejar=1
  AND category='Unknown'
GROUP BY
  name 
)
where ct=1;



  /*,-
  ,-
  ,- e13.4 sample values of unknown cookies

  */

  select distinct(value) from cookies.eval_cookies where in_cookiejar=1 and name='__cf_bm';
  select distinct(value) from cookies.eval_cookies where in_cookiejar=1 and name='c';
  select distinct(value) from cookies.eval_cookies where in_cookiejar=1 and name='CMTS';
  select distinct(value) from cookies.eval_cookies where in_cookiejar=1 and name='A3';
  select distinct(value) from cookies.eval_cookies where in_cookiejar=1 and name='li_gc';

 