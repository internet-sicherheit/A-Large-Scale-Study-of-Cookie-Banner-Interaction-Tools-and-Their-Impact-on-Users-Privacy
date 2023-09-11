# This SQL is used to generate the data for the tables used in the paper.

  -- TABLE 1: general overview per profile
WITH
  ref AS (
  SELECT
    cookies.fc_getAlias(browser_id) alias
  FROM
    cookies.eval_cookies
  GROUP BY
    browser_id )
SELECT
  ref.alias,
  FORMAT("%'d", cookie_jar) cookie_jar,
  FORMAT("%'d", c_first_party) c_first_party,
  FORMAT("%'d", c_third_party) c_third_party, 
  FORMAT("%'d", c_cat_strict) c_cat_strict,
  FORMAT("%'d", c_cat_func) c_cat_func,
  FORMAT("%'d", c_cat_targeting) c_cat_targeting,
  FORMAT("%'d", c_cat_performance) c_cat_performance,
  --FORMAT("%'d", cookie_total_ops) cookie_total_ops,
  --FORMAT("%'d", deleted) deleted,
  FORMAT("%'d", localstorage) localstorage,
  --FORMAT("%'d", http_requests) http_requests,
  FORMAT("%'d", tracking_req) tracking_req,
  --FORMAT("%'d", dns) dns
FROM
  ref
INNER JOIN (
  SELECT
    cookies.fc_getAlias(browser_id) alias,
    COUNT(*) cookie_jar
  FROM
    cookies.eval_cookies c
  WHERE
    c.in_cookiejar=1
  GROUP BY
    alias ) c1
ON
  ref.alias=c1.alias
INNER JOIN (
  SELECT
    cookies.fc_getAlias(browser_id) alias,
    COUNT(*) c_first_party
  FROM
    cookies.eval_cookies c
  WHERE
    c.is_third_party=0
    AND in_cookiejar=1
  GROUP BY
    alias ) c2
ON
  ref.alias=c2.alias
INNER JOIN (
  SELECT
    cookies.fc_getAlias(browser_id) alias,
    COUNT(*) c_third_party
  FROM
    cookies.eval_cookies c
  WHERE
    c.is_third_party=1
    AND in_cookiejar=1
  GROUP BY
    alias ) c3
ON
  ref.alias=c3.alias
INNER JOIN (
  SELECT
    cookies.fc_getAlias(browser_id) alias,
    COUNT(*) c_cat_unknown
  FROM
    cookies.eval_cookies c
  WHERE
    c.category='Unknown'
    AND in_cookiejar=1
  GROUP BY
    alias ) c11
ON
  ref.alias=c11.alias
INNER JOIN (
  SELECT
    cookies.fc_getAlias(browser_id) alias,
    COUNT(*) c_cat_strict
  FROM
    cookies.eval_cookies c
  WHERE
    c.category='Strictly Necessary'
    AND in_cookiejar=1
  GROUP BY
    alias ) c4
ON
  ref.alias=c4.alias
INNER JOIN (
  SELECT
    cookies.fc_getAlias(browser_id) alias,
    COUNT(*) c_cat_func
  FROM
    cookies.eval_cookies c
  WHERE
    c.category='Functionality'
    AND in_cookiejar=1
  GROUP BY
    alias ) c5
ON
  ref.alias=c5.alias
INNER JOIN (
  SELECT
    cookies.fc_getAlias(browser_id) alias,
    COUNT(*) c_cat_targeting
  FROM
    cookies.eval_cookies c
  WHERE
    c.category='Targeting/Advertising'
    AND in_cookiejar=1
  GROUP BY
    alias ) c6
ON
  ref.alias=c6.alias
INNER JOIN (
  SELECT
    cookies.fc_getAlias(browser_id) alias,
    COUNT(*) c_cat_performance
  FROM
    cookies.eval_cookies c
  WHERE
    c.category='Performance'
    AND in_cookiejar=1
  GROUP BY
    alias ) c7
ON
  ref.alias=c7.alias --
INNER JOIN (
  SELECT
    cookies.fc_getAlias(browser_id) alias,
    COUNT(*) cookie_total_ops
  FROM
    cookies.eval_cookies c
  GROUP BY
    alias ) t2
ON
  ref.alias=t2.alias
INNER JOIN (
  SELECT
    cookies.fc_getAlias(browser_id) alias,
    COUNT(*) deleted
  FROM
    cookies.eval_cookies c
  WHERE
    record_type='deleted'
  GROUP BY
    alias ) t3
ON
  ref.alias=t3.alias
INNER JOIN (
  SELECT
    cookies.fc_getAlias(browser_id) alias,
    COUNT(*) localstorage
  FROM
    cookies.eval_localstorage c
  GROUP BY
    alias ) t4
ON
  ref.alias=t4.alias
INNER JOIN (
  SELECT
    cookies.fc_getAlias(browser_id) alias,
    COUNT(*) http_requests
  FROM
    cookies.eval_requests c
  GROUP BY
    alias ) t5
ON
  ref.alias=t5.alias
INNER JOIN (
  SELECT
    cookies.fc_getAlias(browser_id) alias,
    COUNT(*) tracking_req
  FROM
    cookies.eval_requests c
  WHERE
    is_tracker=1
  GROUP BY
    alias ) t6
ON
  ref.alias=t6.alias
INNER JOIN (
  SELECT
    cookies.fc_getAlias(browser_id) alias,
    COUNT(*) dns
  FROM
    cookies.eval_dns_responses c
  GROUP BY
    alias ) t7
ON
  ref.alias=t7.alias
ORDER BY
  ref.alias;


  