# This SQL is used for conducting evaluation of the cookie operations per different profiles.
  /*,
  -,
  -,
  -,
  -- e11.0 number OF records per page,
  -*/
SELECT
  AVG(ct),
  STDDEV(ct) stdev,
  MIN(ct) min,
  MAX(ct) max,
  alias,
  record_type
FROM (
  SELECT
    COUNT(*) ct,
    cookies.fc_getAlias(browser_id) alias,
    visit_id,
    record_type
  FROM
    cookies.eval_cookies
  GROUP BY
    browser_id,
    record_type,
    visit_id) group by alias,record_type order by alias, record_type; 
    
    /*,-
    ,-
    ,-- e11.1 first- and third-party cookie ops 
    ,-- 
    ,-*/


    SELECT
  AVG(duration) avg,
  stddev(duration) stdev,
  min(duration) min,
  max(duration) max,
  is_third_party,
  record_type,
  CONCAT(record_type,REPLACE(replace(CAST(is_third_party AS string),
        '0',
        ' (first-party)'),'1',' (third-party)')) hue,
  COUNT(*) number_of_records
FROM (
  SELECT
    requests.duration duration,
    is_third_party,
    record_type
  FROM
    `your-bigquery-dataset.cookies.eval_cookies`
  WHERE
    requests.duration <31
    AND requests.duration IS NOT NULL
    AND is_third_party IS NOT NULL )
GROUP BY
  is_third_party,
  record_type;
    
    /*,
  -,
  -,
  -,
  - e11.2 diff time for each profile
  -,
  -*/
SELECT
  AVG(requests.duration) avg,
  STDDEV(requests.duration) stdev,
  MIN(requests.duration) min,
  MAX(requests.duration) max,
  COUNT(*) ct,
  cookies.fc_getAliasGroup(browser_id) alias,
  record_type,
  is_third_party
FROM
  `your-bigquery-dataset.cookies.eval_cookies`
WHERE
  requests.duration <31
  AND requests.duration IS NOT NULL
  AND is_third_party IS NOT NULL
GROUP BY
  browser_id,
  record_type,
  is_third_party
ORDER BY
  cookies.fc_getAlias(browser_id),
  is_third_party;