# This is our main SQL file for preprocessing the entire tables. It is used to create the tables in the first place and to update them later on. It is also used to create the tables for the evaluation.
#MAKE BACKUP
CREATE OR REPLACE TABLE   backup_cookies.callstacks AS SELECT   * FROM   cookies.callstacks WHERE
 true;
CREATE OR REPLACE TABLE
  backup_cookies.cookies AS
SELECT
  *
FROM
  cookies.cookies
WHERE
 true;
CREATE OR REPLACE TABLE
  backup_cookies.dns_responses AS
SELECT
  *
FROM
  cookies.dns_responses
WHERE
 true;
CREATE OR REPLACE TABLE
  backup_cookies.http_redirects AS
SELECT
  *
FROM
  cookies.http_redirects
WHERE
 true;
CREATE OR REPLACE TABLE
  backup_cookies.incomplete_visits AS
SELECT
  *
FROM
  cookies.incomplete_visits
WHERE
 true;
CREATE OR REPLACE TABLE
  backup_cookies.javascript AS
SELECT
  *
FROM
  cookies.javascript
WHERE
 true;
CREATE OR REPLACE TABLE
  backup_cookies.localstorage AS
SELECT
  *
FROM
  cookies.localstorage
WHERE
 true;
CREATE OR REPLACE TABLE
  backup_cookies.navigations AS
SELECT
  *
FROM
  cookies.navigations
WHERE
 true;
CREATE OR REPLACE TABLE
  backup_cookies.requests AS
SELECT
  *
FROM
  cookies.requests
WHERE
 true;
CREATE OR REPLACE TABLE
  backup_cookies.responses AS
SELECT
  *
FROM
  cookies.responses
WHERE
 true;
CREATE OR REPLACE TABLE
  backup_cookies.sites AS
SELECT
  *
FROM
  cookies.sites
WHERE
   true;
CREATE OR REPLACE TABLE
  backup_cookies.visits AS
SELECT
  *
FROM
  cookies.visits
WHERE
 true;

  -- Prepare FOR export.,
  /*
CREATE TABLE
  exports_sites AS
SELECT
  id,
  rank,
  site,
  scheme,
  subpages_count,
  state_scheme,
  state_subpages,
  site_state,
  ready,
  timeout,
  state_openwpm_native_eu,
  state_openwpm_native_usa,
  state_openwpm_customall_eu,
  state_openwpm_omaticno_eu,
  state_openwpm_omaticall_eu,
  state_openwpm_dontcare_eu,
  state_openwpm_ninja_eu,
  state_openwpm_cookieblock_eu,
  state_openwpm_superagent_eu,
  log_customall,
  --REPLACE(replace(encode(CONVERT_TO(subpages,
          'UTF-8'),
        'base64'),
      '\n',
      ';'),'n',';') AS subpages,
  CAST(cardinality(string_to_array(CONCAT(state_openwpm_native_eu, state_openwpm_native_usa,state_openwpm_customall_eu, state_openwpm_omaticno_eu, state_openwpm_omaticall_eu, state_openwpm_dontcare_eu, state_openwpm_ninja_eu, state_openwpm_cookieblock_eu, state_openwpm_superagent_eu),
        '2')) AS int)-1 AS success_visits_per_profile
FROM
  sites
ORDER BY
  id */ #EXPORT & IMPORT TO BQ,
 

                                # OPS #


-- sites
ALTER TABLE
  cookies.sites ADD COLUMN
IF NOT EXISTS acceptall_logs string;

update cookies.sites set acceptall_logs=cast(log_customall as string) where true;

update cookies.sites set  acceptall_logs= replace(    replace(acceptall_logs,"FireTime': datetime","FireTime': 'datetime"),')}',")'}") where true;

update cookies.sites set  acceptall_logs= replace(    replace(acceptall_logs,"AcceptAllFired': ","AcceptAllFired': '"),", 'FoundSignature'","', 'FoundSignature'") where true;

/*,
-- cookies: fix is_third_party*/
update cookies.cookies c set is_third_party=  cast(NET.reg_domain(s.site)!=NET.reg_domain(c.host) as int) from cookies.sites s where c.site_id=s.id  ;


#LocalStorage

# localstorage: fix origin
ALTER TABLE
  cookies.localstorage ADD COLUMN IF NOT EXISTS origin_clean STRING,   ADD COLUMN IF NOT EXISTS scope_clean STRING;
UPDATE   cookies.localstorage SET   origin_clean= REVERSE(SPLIT(origin_key,'.:') [  OFFSET    (0)]),
  scope_clean= REVERSE(SPLIT(scope,'.:') [  OFFSET    (0)]) WHERE   true ;

-- localstorage: set is_third_party*/
ALTER TABLE
  cookies.localstorage ADD COLUMN
IF NOT EXISTS is_third_party int;

update cookies.localstorage c set is_third_party=  cast(NET.reg_domain(s.site)!=NET.reg_domain(c.origin_clean) as int) from cookies.sites s where c.site_id=s.id  ;





 /*,
 ################ SCOPE,
  - */
 
 
 #sites 
ALTER TABLE
  cookies.sites ADD COLUMN
IF NOT EXISTS in_scope int;

-- here we drop sites if crawled twice
update cookies.sites set in_scope=null where true;
update cookies.sites
set in_scope=1
where  success_visits_per_profile >=8
and id not in(SELECT  DISTINCT(cast(site_id as int)) FROM (  SELECT     COUNT(*) ct,    site_id,  browser_id   FROM     cookies.visits   GROUP BY    site_id,     browser_id  HAVING    COUNT(*)>16))
;
 


ALTER TABLE
  cookies.visits ADD COLUMN
IF NOT EXISTS in_scope int64;

#cookies
update cookies.cookies c set in_scope = null where true;
update cookies.cookies c set in_scope=1 where cast(site_id as int) in (select id from cookies.sites s where cast(c.site_id as int)=cast(s.id as int) and in_scope=1 );
#dns_responses
update cookies.dns_responses c set in_scope = null where true;
update cookies.dns_responses c set in_scope=1 where cast(cast(site_id as int) as int) in  (select id from cookies.sites s where cast(c.site_id as int)=cast(s.id as int) and in_scope=1 );
#http_redirects
update cookies.http_redirects c set in_scope = null where true;
update cookies.http_redirects c set in_scope=1 where cast(site_id as int) in  (select id from cookies.sites s where cast(c.site_id as int)=cast(s.id as int) and in_scope=1 ) ;
#incomplete_visits
update cookies.incomplete_visits c set in_scope = null where true;
update cookies.incomplete_visits c set in_scope=1 where cast(site_id as int) in  (select id from cookies.sites s where cast(c.site_id as int)=cast(s.id as int)  and in_scope=1) ;
#javascript
update cookies.javascript c set in_scope = null where true;
update cookies.javascript c set in_scope=1 where cast(site_id as int) in  (select id from cookies.sites s where cast(c.site_id as int)=cast(s.id as int) and in_scope=1 ) ;
#localstorage
update cookies.localstorage c set in_scope = null where true;
update cookies.localstorage c set in_scope=1 where cast(site_id as int) in  (select id from cookies.sites s where cast(c.site_id as int)=cast(s.id as int) and in_scope=1  ) ;
#navigations
update cookies.navigations c set in_scope = null where true;
update cookies.navigations c set in_scope=1 where cast(site_id as int) in  (select id from cookies.sites s where cast(c.site_id as int)=cast(s.id as int) and in_scope=1  ) ;
#requests
update cookies.requests c set in_scope = null where true;
update cookies.requests c set in_scope=1 where cast(site_id as int) in  (select id from cookies.sites s where cast(c.site_id as int)=cast(s.id as int) and in_scope=1  ) ;
#responses
update cookies.responses c set in_scope = null where true;
update cookies.responses c set in_scope=1 where cast(site_id as int) in  (select id from cookies.sites s where cast(c.site_id as int)=cast(s.id as int) and in_scope=1  ) ;
#cookies
update cookies.cookies c set in_scope = null where true;
update cookies.cookies c set in_scope=1 where cast(site_id as int) in  (select id from cookies.sites s where cast(c.site_id as int)=cast(s.id as int) and in_scope=1  ) ;
#visits 
update cookies.visits c set in_scope = null where true;
update cookies.visits c set in_scope=1 where cast(site_id as int) in  (select id from cookies.sites s where cast(c.site_id as int)=cast(s.id as int) and in_scope=1  ) ;


#create eval tables only with in_scope
create or replace table 
cookies.eval_cookies as
select cast(site_id as int) site_id,* except (site_id) from cookies.cookies where in_scope=1;

create or replace table 
cookies.eval_dns_responses as
select cast(site_id as int) site_id,* except (site_id)  from cookies.dns_responses where in_scope=1;

create or replace table 
cookies.eval_http_redirects as
select cast(site_id as int) site_id,* except (site_id)  from cookies.http_redirects where in_scope=1;

create or replace table 
cookies.eval_localstorage as
select cast(site_id as int) site_id,* except (site_id)  from cookies.localstorage where in_scope=1;

create or replace table 
cookies.eval_requests as
select cast(site_id as int) site_id,* except (site_id)  from cookies.requests where in_scope=1;

create or replace table 
cookies.eval_responses as
select cast(site_id as int) site_id,* except (site_id)  from cookies.requests where in_scope=1;


create or replace table 
cookies.eval_sites as
select cast(id as int) site_id,* except (id)  from cookies.sites where in_scope=1;


create or replace table 
cookies.eval_visits as
select cast(site_id as int) site_id,* except (site_id)  from cookies.visits where in_scope=1;


/*,

COOKIPEDIA & TRACKER: mark cookie cats & trackers

*/

ALTER TABLE
  cookies.eval_cookies ADD COLUMN
IF NOT EXISTS category string;

update cookies.eval_cookies ec set category = (select distinct(cat) from cookies.cookies_cat_processed cc where ec.name=cc.name) where true;

update cookies.eval_cookies ec set category = 'Unknown' where category='' or category is null;


ALTER TABLE
  cookies.eval_localstorage ADD COLUMN
IF NOT EXISTS category string;

update cookies.eval_localstorage ec set category = (select distinct(cat) from cookies.cookies_cat_processed cc where ec.key=cc.name) where true;

update cookies.eval_localstorage ec set category = 'Unknown' where category='' or category is null;


update cookies.eval_requests ec set is_tracker = (select distinct(is_tracker) from cookies.tmp_requests_tracker_processed cc where ec.url=cc.url) where true;


/*,

LocalStorag tracking keys

*/


  -- tracking localstorage
ALTER TABLE
  cookies.eval_localstorage ADD COLUMN
IF NOT EXISTS tracking_ls int;
UPDATE
  cookies.eval_localstorage l
SET
  tracking_ls=1
WHERE
  BYTE_LENGTH(l.value)>7
  AND l.key IN ( -- value IS different 1ength diff up TO 25%
  SELECT
    l2.key
  FROM
    cookies.eval_localstorage l2
  WHERE
    l.browser_id!=l2.browser_id
    AND l.site_id=l2.site_id
    AND l.value!=l2.value
    AND l.key=l2.key
    AND ABS(BYTE_LENGTH(l.value)/BYTE_LENGTH(l2.value))<=0.25 
    and BYTE_LENGTH(l2.value)>7
    );



/*,-
,-
,- determine first last requests depending to get distribution of cookie ops
,-*/



ALTER TABLE
  cookies.eval_cookies ADD COLUMN
IF NOT EXISTS requests STRUCT< FIRST datetime,
  LAST datetime,
  duration int,
  diff int>;
UPDATE
  cookies.eval_cookies t
SET
  requests.first = (
  SELECT
    MIN(time_stamp)
  FROM
    cookies.eval_requests r
  WHERE
    browser_id=t.browser_id
    AND visit_id=t.visit_id),
  requests.last=(
  SELECT
    MAX(time_stamp)
  FROM
    cookies.eval_requests r
  WHERE
    browser_id=t.browser_id
    AND visit_id=t.visit_id)
WHERE
  TRUE;
UPDATE
  cookies.eval_cookies t
SET
  requests.duration = TIMESTAMP_DIFF( CAST(requests.Last AS timestamp), CAST(requests.first AS timestamp), second),
  requests.diff = TIMESTAMP_DIFF( CAST(time_stamp AS timestamp), CAST(requests.first AS timestamp), second)
WHERE
  TRUE;

-- cookies ops

ALTER TABLE
  cookies.eval_cookies ADD COLUMN
IF NOT EXISTS record_type_all string;
UPDATE
  cookies.eval_cookies c1
SET
  record_type_all="added"
WHERE
  c1.name NOT IN (
  SELECT
    c2.name
  FROM
    cookies.eval_cookies c2
  WHERE
    c1.browser_id=c2.browser_id
    AND c1.visit_id=c2.visit_id
    AND c1.time_stamp>c2.time_stamp );

UPDATE
  cookies.eval_cookies c1
SET
  record_type_all=replace(record_type,'added-or-changed','changed')
WHERE
 record_type_all is null;


-- sites bucket





  ALTER TABLE
  `cookies.sites` ADD COLUMN
IF NOT EXISTS rank_bucket int;
UPDATE
  cookies.sites
SET
  rank_bucket=0
WHERE
  rank<=5000;


UPDATE
  cookies.sites
SET
  rank_bucket=5
WHERE
 rank>5000
  AND rank<=10000;


UPDATE
  cookies.sites
SET
  rank_bucket=50
WHERE
 rank>10000
  AND rank<=50000;


UPDATE
  cookies.sites
SET
  rank_bucket=250
WHERE
  rank>50000
  AND rank<=250000;
UPDATE
  cookies.sites
SET
  rank_bucket=500
WHERE
  rank>250000
  AND rank<=500000;
UPDATE
  cookies.sites
SET
  rank_bucket=500
WHERE
  rank>250000
  AND rank<=500000;
UPDATE
  cookies.sites
SET
  rank_bucket=1000
WHERE
  rank>500000
  AND rank<=1000000;




