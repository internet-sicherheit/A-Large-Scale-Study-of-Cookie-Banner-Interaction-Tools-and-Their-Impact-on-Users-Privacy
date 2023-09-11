# This SQL is used for calculating the similarity of the cookie by different profiles and cookie categories.
SELECT
  'Functionality' analyse,
  'AcceptAll' gruppe,
  '1_3_7_8' compare,
  AVG(cat_func.sim_1_3_7_8) avg,
  STDDEV(cat_func.sim_1_3_7_8) std,
  MIN(cat_func.sim_1_3_7_8) min,
  MAX(cat_func.sim_1_3_7_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Functionality' analyse,
  'AcceptAll',
  '1_3_7',
  AVG(cat_func.sim_1_3_7) avg,
  STDDEV(cat_func.sim_1_3_7) std,
  MIN(cat_func.sim_1_3_7) min,
  MAX(cat_func.sim_1_3_7) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Functionality' analyse,
  'AcceptAll',
  '3_7' compare,
  AVG(cat_func.sim_3_7) avg,
  STDDEV(cat_func.sim_3_7) std,
  MIN(cat_func.sim_3_7) min,
  MAX(cat_func.sim_3_7) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Functionality' analyse,
  'AcceptFunc',
  '5_6_8' compare,
  AVG(cat_func.sim_5_6_8) avg,
  STDDEV(cat_func.sim_5_6_8) std,
  MIN(cat_func.sim_5_6_8) min,
  MAX(cat_func.sim_5_6_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Functionality' analyse,
  'AcceptFunc',
  '5_6' compare,
  AVG(cat_func.sim_5_6) avg,
  STDDEV(cat_func.sim_5_6) std,
  MIN(cat_func.sim_5_6) min,
  MAX(cat_func.sim_5_6) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Functionality' analyse,
  'RejectAll',
  '2_4_8' compare,
  AVG(cat_func.sim_2_4_8) avg,
  STDDEV(cat_func.sim_2_4_8) std,
  MIN(cat_func.sim_2_4_8) min,
  MAX(cat_func.sim_2_4_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Functionality' analyse,
  'RejectAll',
  '2_4' compare,
  AVG(cat_func.sim_2_4) avg,
  STDDEV(cat_func.sim_2_4) std,
  MIN(cat_func.sim_2_4) min,
  MAX(cat_func.sim_2_4) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Targeting/Advertising' analyse,
  'AcceptAll' gruppe,
  '1_3_7_8' compare,
  AVG(cat_target.sim_1_3_7_8) avg,
  STDDEV(cat_target.sim_1_3_7_8) std,
  MIN(cat_target.sim_1_3_7_8) min,
  MAX(cat_target.sim_1_3_7_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Targeting/Advertising' analyse,
  'AcceptAll',
  '1_3_7',
  AVG(cat_target.sim_1_3_7) avg,
  STDDEV(cat_target.sim_1_3_7) std,
  MIN(cat_target.sim_1_3_7) min,
  MAX(cat_target.sim_1_3_7) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Targeting/Advertising' analyse,
  'AcceptAll',
  '3_7' compare,
  AVG(cat_target.sim_3_7) avg,
  STDDEV(cat_target.sim_3_7) std,
  MIN(cat_target.sim_3_7) min,
  MAX(cat_target.sim_3_7) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Targeting/Advertising' analyse,
  'AcceptFunc',
  '5_6_8' compare,
  AVG(cat_target.sim_5_6_8) avg,
  STDDEV(cat_target.sim_5_6_8) std,
  MIN(cat_target.sim_5_6_8) min,
  MAX(cat_target.sim_5_6_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Targeting/Advertising' analyse,
  'AcceptFunc',
  '5_6' compare,
  AVG(cat_target.sim_5_6) avg,
  STDDEV(cat_target.sim_5_6) std,
  MIN(cat_target.sim_5_6) min,
  MAX(cat_target.sim_5_6) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Targeting/Advertising' analyse,
  'RejectAll',
  '2_4_8' compare,
  AVG(cat_target.sim_2_4_8) avg,
  STDDEV(cat_target.sim_2_4_8) std,
  MIN(cat_target.sim_2_4_8) min,
  MAX(cat_target.sim_2_4_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Targeting/Advertising' analyse,
  'RejectAll',
  '2_4' compare,
  AVG(cat_target.sim_2_4) avg,
  STDDEV(cat_target.sim_2_4) std,
  MIN(cat_target.sim_2_4) min,
  MAX(cat_target.sim_2_4) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Strictly Necessary' analyse,
  'AcceptAll' gruppe,
  '1_3_7_8' compare,
  AVG(cat_strict.sim_1_3_7_8) avg,
  STDDEV(cat_strict.sim_1_3_7_8) std,
  MIN(cat_strict.sim_1_3_7_8) min,
  MAX(cat_strict.sim_1_3_7_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Strictly Necessary' analyse,
  'AcceptAll',
  '1_3_7',
  AVG(cat_strict.sim_1_3_7) avg,
  STDDEV(cat_strict.sim_1_3_7) std,
  MIN(cat_strict.sim_1_3_7) min,
  MAX(cat_strict.sim_1_3_7) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Strictly Necessary' analyse,
  'AcceptAll',
  '3_7' compare,
  AVG(cat_strict.sim_3_7) avg,
  STDDEV(cat_strict.sim_3_7) std,
  MIN(cat_strict.sim_3_7) min,
  MAX(cat_strict.sim_3_7) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Strictly Necessary' analyse,
  'AcceptFunc',
  '5_6_8' compare,
  AVG(cat_strict.sim_5_6_8) avg,
  STDDEV(cat_strict.sim_5_6_8) std,
  MIN(cat_strict.sim_5_6_8) min,
  MAX(cat_strict.sim_5_6_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Strictly Necessary' analyse,
  'AcceptFunc',
  '5_6' compare,
  AVG(cat_strict.sim_5_6) avg,
  STDDEV(cat_strict.sim_5_6) std,
  MIN(cat_strict.sim_5_6) min,
  MAX(cat_strict.sim_5_6) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Strictly Necessary' analyse,
  'RejectAll',
  '2_4_8' compare,
  AVG(cat_strict.sim_2_4_8) avg,
  STDDEV(cat_strict.sim_2_4_8) std,
  MIN(cat_strict.sim_2_4_8) min,
  MAX(cat_strict.sim_2_4_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Strictly Necessary' analyse,
  'RejectAll',
  '2_4' compare,
  AVG(cat_strict.sim_2_4) avg,
  STDDEV(cat_strict.sim_2_4) std,
  MIN(cat_strict.sim_2_4) min,
  MAX(cat_strict.sim_2_4) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Performance'analyse,
  'AcceptAll' gruppe,
  '1_3_7_8' compare,
  AVG(cat_performance.sim_1_3_7_8) avg,
  STDDEV(cat_performance.sim_1_3_7_8) std,
  MIN(cat_performance.sim_1_3_7_8) min,
  MAX(cat_performance.sim_1_3_7_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Performance'analyse,
  'AcceptAll',
  '1_3_7',
  AVG(cat_performance.sim_1_3_7) avg,
  STDDEV(cat_performance.sim_1_3_7) std,
  MIN(cat_performance.sim_1_3_7) min,
  MAX(cat_performance.sim_1_3_7) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Performance'analyse,
  'AcceptAll',
  '3_7' compare,
  AVG(cat_performance.sim_3_7) avg,
  STDDEV(cat_performance.sim_3_7) std,
  MIN(cat_performance.sim_3_7) min,
  MAX(cat_performance.sim_3_7) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Performance'analyse,
  'AcceptFunc',
  '5_6_8' compare,
  AVG(cat_performance.sim_5_6_8) avg,
  STDDEV(cat_performance.sim_5_6_8) std,
  MIN(cat_performance.sim_5_6_8) min,
  MAX(cat_performance.sim_5_6_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Performance'analyse,
  'AcceptFunc',
  '5_6' compare,
  AVG(cat_performance.sim_5_6) avg,
  STDDEV(cat_performance.sim_5_6) std,
  MIN(cat_performance.sim_5_6) min,
  MAX(cat_performance.sim_5_6) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Performance'analyse,
  'RejectAll',
  '2_4_8' compare,
  AVG(cat_performance.sim_2_4_8) avg,
  STDDEV(cat_performance.sim_2_4_8) std,
  MIN(cat_performance.sim_2_4_8) min,
  MAX(cat_performance.sim_2_4_8) max
FROM
  cookies.sim_cookies_per_visit
UNION ALL
SELECT
  'Performance'analyse,
  'RejectAll',
  '2_4' compare,
  AVG(cat_performance.sim_2_4) avg,
  STDDEV(cat_performance.sim_2_4) std,
  MIN(cat_performance.sim_2_4) min,
  MAX(cat_performance.sim_2_4) max
FROM
  cookies.sim_cookies_per_visit
ORDER BY
  analyse,
  gruppe,
  compare ;