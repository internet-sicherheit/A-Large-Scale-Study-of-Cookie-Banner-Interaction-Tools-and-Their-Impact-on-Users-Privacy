# This SQL is used for conducting a general analysis per profile.

--e10.0 number of visits for temp measurements
SELECT
  COUNT(*),
  measurement_id
FROM
  `your-bigquery-dataset.cookies2.visits`
GROUP BY
  measurement_id;
--e10.1 failure rates of the crawler


select avg(success_rate) from (
  SELECT 'state_openwpm_native_eu' browser, count(*) ct,  count(*)/30000 success_rate, cookies.fc_getAlias('openwpm_native_eu') browser FROM `your-bigquery-dataset.cookies.sites` where  state_openwpm_native_eu =2
union all
SELECT 'state_openwpm_native_usa' , count(*) ct,  count(*)/30000 , cookies.fc_getAlias('openwpm_native_usa') FROM `your-bigquery-dataset.cookies.sites` where   state_openwpm_native_usa  =2
union all
SELECT 'state_openwpm_customall_eu' , count(*) ct,  count(*)/30000 , cookies.fc_getAlias('openwpm_customall_eu') FROM `your-bigquery-dataset.cookies.sites` where   state_openwpm_customall_eu  =2
union all
SELECT 'state_openwpm_omaticno_eu' , count(*) ct,  count(*)/30000 , cookies.fc_getAlias('openwpm_omaticno_eu') FROM `your-bigquery-dataset.cookies.sites` where   state_openwpm_omaticno_eu  =2
union all
SELECT 'state_openwpm_omaticall_eu' , count(*) ct,  count(*)/30000 , cookies.fc_getAlias('openwpm_omaticall_eu') FROM `your-bigquery-dataset.cookies.sites` where   state_openwpm_omaticall_eu  =2
union all
SELECT 'state_openwpm_dontcare_eu' , count(*) ct,  count(*)/30000 , cookies.fc_getAlias('openwpm_dontcare_eu') FROM `your-bigquery-dataset.cookies.sites` where   state_openwpm_dontcare_eu  =2
union all
SELECT 'state_openwpm_ninja_eu' , count(*) ct,  count(*)/30000 , cookies.fc_getAlias('openwpm_ninja_eu') FROM `your-bigquery-dataset.cookies.sites` where   state_openwpm_ninja_eu  =2
union all
SELECT 'state_openwpm_cookieblock_eu' , count(*) ct,  count(*)/30000 , cookies.fc_getAlias('openwpm_cookieblock_eu') FROM `your-bigquery-dataset.cookies.sites` where   state_openwpm_cookieblock_eu  =2
union all
SELECT 'state_openwpm_superagent_eu' ,count(*) ct,   count(*)/30000 , cookies.fc_getAlias('openwpm_superagent_eu') FROM `your-bigquery-dataset.cookies.sites` where   state_openwpm_superagent_eu  =2
order by ct );