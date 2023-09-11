# This SQL contains SQL functions used in Bigquery.

CREATE OR REPLACE FUNCTION `your-bigquery-dataset.cookies.fc_sim_array`(arr STRING) RETURNS NUMERIC LANGUAGE js AS R"""
all = arr.split('|')
        arrList = []

        for (let i = 0; i < all.length; i++) {
            val1 = all[i]
            if (val1 == null) { val1 = ""; }
            val1 = val1.split(',')
            val1 = val1.filter(function (value, index, array) {
                return array.indexOf(value) === index;
            });
            arrList.push(val1)
        } 

        maxLength = -1;
        for (let i = 0; i < arrList.length; i++) {
            if (maxLength < arrList[i].length) {
                maxLength = arrList[i].length;
            }
        }

        var arrLength = Object.keys(arrList).length;
        var index = {};
        for (var i in arrList) {
            for (var j in arrList[i]) {
                var v = arrList[i][j];
                if (index[v] === undefined) index[v] = 0;
                index[v]++;
            };
        };
        var retv = [];
        for (var i in index) {
            if (index[i] == arrLength) retv.push(i);
        };

        commonItem = retv.length 
        return (parseInt(commonItem) / parseInt(maxLength)).toFixed(2)
""";


CREATE OR REPLACE FUNCTION `your-bigquery-dataset.cookies.fc_getAlias`(browser_id STRING) RETURNS STRING LANGUAGE js AS R"""
alias=''

 if (browser_id == 'openwpm_dontcare_eu') {
  alias = "#1";
} else if (browser_id == 'openwpm_omaticno_eu') {
  alias = "#2";
}else if (browser_id == 'openwpm_omaticall_eu') {
  alias = "#3";
}else if (browser_id == 'openwpm_ninja_eu') {
  alias = "#4";
}else if (browser_id == 'openwpm_cookieblock_eu') {
  alias = "#5";
}else if (browser_id == 'openwpm_superagent_eu') {
  alias = "#6";
}else if (browser_id == 'openwpm_customall_eu') {
  alias = "#7";
}else if (browser_id == 'openwpm_native_eu') {
  alias = "#8";
}else if (browser_id == 'openwpm_native_usa') {
  alias = "#9";
} 

return alias
""";


CREATE OR REPLACE FUNCTION `your-bigquery-dataset.cookies.fc_getAliasGroup`(browser_id STRING) RETURNS STRING LANGUAGE js AS R"""
alias=''

 if (browser_id == 'openwpm_dontcare_eu') {
  alias = "AcceptAll";
} else if (browser_id == 'openwpm_omaticno_eu') {
  alias = "RejectAll";
}else if (browser_id == 'openwpm_omaticall_eu') {
  alias = "AcceptAll";
}else if (browser_id == 'openwpm_ninja_eu') {
  alias = "RejectAll";
}else if (browser_id == 'openwpm_cookieblock_eu') {
  alias = "AcceptFunc";
}else if (browser_id == 'openwpm_superagent_eu') {
  alias = "AcceptFunc";
}else if (browser_id == 'openwpm_customall_eu') {
  alias = "AcceptAll";
}else if (browser_id == 'openwpm_native_eu') {
  alias = "Baseline_DE";
}else if (browser_id == 'openwpm_native_usa') {
  alias = "Baseline_US";
} 

return alias
""";


CREATE OR REPLACE FUNCTION `your-bigquery-dataset.cookies.fc_contains`(p1 STRING, p2 STRING) RETURNS BOOL LANGUAGE js AS R"""
if(p1.includes(p2))
{
return true;}
else
{
return false}
""";
