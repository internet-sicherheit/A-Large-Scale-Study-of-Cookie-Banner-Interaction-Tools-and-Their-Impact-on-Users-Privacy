# Complete Data Processing and Evaluation Pipeline

The table below provides an overview of each file in this folder, its purpose, and its categorization. 
These SQLs are used to process the data and generate the results for the paper.



| File | Category | Description |
|------|----------|-------------|
| 0 - preprocessing entire tables.sql | Data pre- and postprocessing | This is our main SQL file for preprocessing the entire tables. It is used to create the tables in the first place and to update them later on. It is also used to create the tables for the evaluation. |
| 1_calculate_cookies_similarity.sql | Data pre- and postprocessing | This SQL calculates the similarity between cookies in different profiles |
| e10_evaluation_on_own_exentsion.sql | Evaluation | This SQL is used for conducting evaluation on our own extension. |
| e11_cookie_operations_timeseries.sql | Evaluation | This SQL is used for conducting evaluation of the cookie operations per different profiles. |
| e12_simple_stats.sql | Evaluation | This SQL is used for conducting a general analysis per profile. |
| e13_unknown_cookies.sql | Evaluation | This SQL is used for conducting evaluation of the unknown cookies. |
| e1_accept_all.sql | Evaluation | This SQL is used for evaluating the accept-all (#1, #3, #7, #8) profiles |
| e2_cookies.sql | Evaluation | This SQL is used for conducting a general analysis of the cookies. |
| e3_network_traffic.sql | Evaluation | This SQL is used for conducting evaluation of the network traffic. |
| e4_localstorage.sql | Evaluation | This SQL is used for conducting evaluation of the local storage. |
| e5_acceptFunc.sql | Evaluation | This SQL is used for conducting evaluation of profiles for accepting functional cookies (#5 #6 #8). |
| e6_reject_all.sql | Evaluation | This SQL is used for conducting evaluation of profiles for accepting functional cookies (#2 #4 #8). |
| e7_sim_of_cookie_cats.sql | Evaluation | This SQL is used for calculating the similarity of the cookie by different profiles and cookie categories. |
| e8_cookie_types.sql | Evaluation | This SQL is used to conduct evaluations on cookie types. |
| e9_tracking_requests.sql | Evaluation | This SQL is used for conducting evaluation of the tracking requests. |
| Functions | Functions | This SQL contains BigQuery functions used in Bigquery.
| plots.sql | Plots | This SQL is used to generate the data for the plots used in the paper. |
| stats.sql | Statistics | This SQL is used to generate the data for the statistical calculations used in the paper. |
| tables.sql | Tables | This SQL is used to generate the data for the tables used in the paper. |

