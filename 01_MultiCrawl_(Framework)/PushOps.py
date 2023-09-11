from base64 import encode
from re import A
from Ops import chunkList, visitLog_CookieLocalStorage, visitLog_ReqRes
from setup import getConfig, getMode
from DBOps import DBOps
from google.cloud import bigquery
import os
db = DBOps()


def execBQRows(p_tableID, p_rows, p_timeout=45):
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = os.getcwd() + \
        '/resources/google.json'
    client = bigquery.Client()
    table_id = p_tableID

    try:
        errors = client.insert_rows_json(table_id, p_rows, timeout=p_timeout)
        if errors == []:
            print('pushed rows to BigQuery:' +
                  p_tableID + ': ' + str(len(p_rows)))
        else:
            raise Exception(
                p_tableID + ": Encountered errors while inserting rows: {}".format(errors))
    except:
        print('error while pushing.. retry..')
        errors = client.insert_rows_json(table_id, p_rows, timeout=15)
        if errors == []:
            print('pushed rows to BigQuery:' +
                  p_tableID + ': ' + str(len(p_rows)))
        else:
            raise Exception(
                p_tableID + ": Encountered errors while inserting rows: {}".format(errors))


def stream2BQ(p_siteData):
    try:
        siteData = p_siteData

        max_row = getConfig('bigquery_insert_rows')

        push_cookie = 0
        push_localstorage = 0 

        # push cookies
        if siteData.cookies:
            cookies = chunkList(siteData.cookies, max_row)
            if cookies is not None:
                for item in cookies:
                    push_cookie = push_cookie + len(item)
                    try:
                        print(siteData.site_id, ': pushing cookies: ', len(item))
                        execBQRows('your-bigquery-dataset.cookies.cookies', item, 25)
                    except Exception as e:
                        pushError(siteData.site_id,
                                  'push_cookie', backup_json=item)
                        push_cookie = -1 * push_cookie
                        pass

        # push localStorage
        if siteData.localStorage:
            localStorage = chunkList(siteData.localStorage, max_row)
            if localStorage is not None:
                for item in localStorage:
                    push_localstorage = push_localstorage + len(item)
                    try:
                        print(siteData.site_id,
                              ': pushing localStorage:', len(item))
                        execBQRows(
                            'your-bigquery-dataset.cookies.localstorage', item, 25)
                    except Exception as e:
                        pushError(siteData.site_id,
                                  ': bq_localStorage', backup_json=item)
                        push_localstorage = -1 * push_localstorage
                        pass

        visitLog_CookieLocalStorage(
            siteData.site_id, push_cookie, push_localstorage)

 

        # first try to push all
        all_requests = []
        all_response = []

        all_callstacks = []
        all_dns_responses = []
        all_incomplete_visit = []
        all_http_redirects = []
        all_navigations = [] 

        stats_req_resp = {}
        for visit in siteData.visitData:
            len_req = 0
            len_res = 0
            if visit.requests is not None:
                for item in visit.requests:
                    all_requests.append(item)
                len_req = len(visit.requests)
            if visit.responses is not None:
                for item in visit.responses:
                    all_response.append(item)
                len_res = len(visit.responses)

            if visit.callstacks is not None:
                for item in visit.callstacks:
                    all_callstacks.append(item)
                
            if visit.dns_responses is not None:
                for item in visit.dns_responses:
                    all_dns_responses.append(item)

            if visit.incomplete_visit is not None:
                for item in visit.incomplete_visit:
                    all_incomplete_visit.append(item)

            if visit.navigations is not None:
                for item in visit.navigations:
                    all_navigations.append(item)

            if visit.http_redirects is not None:
                for item in visit.http_redirects:
                    all_http_redirects.append(item)
             
            

            # .append[[visit.visit_id, len(item.requests), len(item.responses)]]
            stats_req_resp[visit.visit_id] = [len_req, len_res]

        # BEGIN REQUESTS
        all_pushed_req = False
        try:
            execBQRows('your-bigquery-dataset.cookies.requests', all_requests, 45)
            all_pushed_req = True
        except:
            all_pushed_req = False
            pushError(siteData.site_id, 'push_bulk_req')
            #push_request = -1 * push_request

        if all_pushed_req:
            str()  # update stats
        else:
            str()  # push one-by-one
            for visit in siteData.visitData:
                push_request = 0
                # push requests
                requests = chunkList(visit.requests, max_row)
                if requests is not None:
                    for item in requests:
                        print(siteData.site_id,
                              ': pushing chunked req: ', str(len(item)))
                        push_request = push_request + len(item)

                        try:
                            execBQRows(
                                'your-bigquery-dataset.cookies.requests', item, 15)
                        except:
                            stats_req_resp[visit.visit_id] = -1 * push_request
                            pushError(siteData.site_id,
                                      ': push_request', backup_json=item)
        # END REQUESTS

        # BEGIN RESPONSES

        all_pushed_res = False
        try:
            execBQRows('your-bigquery-dataset.cookies.responses', all_response, 45)
            all_pushed_res = True
        except:
            all_pushed_res = False
            pushError(siteData.site_id, 'push_bulk_resp')
            #push_request = -1 * push_request
        if all_pushed_res:
            str()  # update stats
        else:
            for visit in siteData.visitData:
                push_response = 0
                # push requests
                # push responses
                responses = chunkList(visit.responses, max_row)
                if responses is not None:
                    for item in responses:
                        push_response = push_response + len(item)
                        print(siteData.site_id,
                              ': pushing chunked res: ', str(len(item)))
                        try:
                            execBQRows(
                                'your-bigquery-dataset.cookies.responses', item, 15)
                        except:
                            stats_req_resp[visit.visit_id] = -1 * push_response
                            pushError(siteData.site_id,
                                      'push_response', backup_json=item)
        for item in stats_req_resp:
            try:
                visitLog_ReqRes(
                    item, stats_req_resp[item][0], stats_req_resp[item][1])
            except:
                pushError(siteData.site_id, 'update_stats-' + item)

        # END RESPONSES



        # BEGIN callstacks 
        if all_callstacks:
            all_pushed_callstacks = False
            try:
                execBQRows('your-bigquery-dataset.cookies.callstacks', all_callstacks, 45)
                all_pushed_callstacks = True
            except:
                all_pushed_callstacks = False
                pushError(siteData.site_id, 'push_bulk_callstacks')
                #push_request = -1 * push_request
            if all_pushed_callstacks:
                str()  # update stats
            else:
                for visit in siteData.visitData:
                    # push requests
                    # push responses
                    callstacks = chunkList(visit.callstacks, max_row)
                    if callstacks is not None:
                        for item in callstacks:
                            print(siteData.site_id,
                                ': pushing chunked callstacks: ', str(len(item)))
                            try:
                                execBQRows(
                                    'your-bigquery-dataset.cookies.callstacks', item, 15)
                            except:
                                pushError(siteData.site_id,
                                        'push_callstacks', backup_json=item)  
            # END callstacks


        # BEGIN DNS RESPONSES 
        if all_dns_responses:
            all_pushed_dns_responses = False
            try:
                execBQRows('your-bigquery-dataset.cookies.dns_responses', all_dns_responses, 45)
                all_pushed_dns_responses = True
            except:
                all_pushed_dns_responses = False
                pushError(siteData.site_id, 'push_bulk_dns')
                #push_request = -1 * push_request
            if all_pushed_dns_responses:
                str()  # update stats
            else:
                for visit in siteData.visitData:
                    # push requests
                    # push responses
                    dns_responses = chunkList(visit.dns_responses, max_row)
                    if dns_responses is not None:
                        for item in dns_responses:
                            print(siteData.site_id,
                                ': pushing chunked dns: ', str(len(item)))
                            try:
                                execBQRows(
                                    'your-bigquery-dataset.cookies.dns_responses', item, 15)
                            except:
                                pushError(siteData.site_id,
                                        'push_dns_responses', backup_json=item) 
            # END DNS_RESPONSES



 
        
        # BEGIN incomplete_visit  
        if all_incomplete_visit: 
            all_pushed_incomplete_visit = False
            try:
                execBQRows('your-bigquery-dataset.cookies.incomplete_visits', all_incomplete_visit, 45)
                all_pushed_incomplete_visit = True
            except:
                all_pushed_incomplete_visit = False
                pushError(siteData.site_id, 'push_bulk_in_visits')
                #push_request = -1 * push_request
            if all_pushed_incomplete_visit:
                str()  # update stats
            else:
                for visit in siteData.visitData:
                    # push requests
                    # push responses
                    incomplete_visit = chunkList(visit.incomplete_visit, max_row)
                    if incomplete_visit is not None:
                        for item in incomplete_visit:
                            print(siteData.site_id,
                                ': pushing chunked incomplete_visit: ', str(len(item)))
                            try:
                                execBQRows(
                                    'your-bigquery-dataset.cookies.incomplete_visits', item, 15)
                            except:
                                pushError(siteData.site_id,
                                        'push_incomplete_visits', backup_json=item)  
        # END incomplete_visit

 

        # BEGIN http_redirects 
        if all_http_redirects:
            all_pushed_http_redirects = False
            try:
                execBQRows('your-bigquery-dataset.cookies.http_redirects', all_http_redirects, 45)
                all_pushed_http_redirects = True
            except:
                all_pushed_http_redirects = False
                pushError(siteData.site_id, 'push_bulk_http_redirects')
                #push_request = -1 * push_request
            if all_pushed_http_redirects:
                str()  # update stats
            else:
                for visit in siteData.visitData:
                    # push requests
                    # push responses
                    http_redirects = chunkList(visit.http_redirects, max_row)
                    if http_redirects is not None:
                        for item in http_redirects:
                            print(siteData.site_id,
                                ': pushing chunked http_redirects: ', str(len(item)))
                            try:
                                execBQRows(
                                    'your-bigquery-dataset.cookies.http_redirects', item, 15)
                            except:
                                pushError(siteData.site_id,
                                        'push_http_redirects', backup_json=item)  
            # END http_redirects



        # BEGIN navigations 
        if all_navigations:
            all_pushed_navigations = False
            try:
                execBQRows('your-bigquery-dataset.cookies.navigations', all_navigations, 45)
                all_pushed_navigations = True
            except:
                all_pushed_navigations = False
                pushError(siteData.site_id, 'push_bulk_navigations')
                #push_request = -1 * push_request
            if all_pushed_navigations:
                str()  # update stats
            else:
                for visit in siteData.visitData:
                    # push requests
                    # push responses
                    navigations = chunkList(visit.navigations, max_row)
                    if navigations is not None:
                        for item in navigations:
                            print(siteData.site_id,
                                ': pushing chunked navigations: ', str(len(item)))
                            try:
                                execBQRows(
                                    'your-bigquery-dataset.cookies.navigations', item, 15)
                            except:
                                pushError(siteData.site_id,
                                        'push_navigations', backup_json=item)  
            # END navigations
  



        """"
        for visit in siteData.visitData:  
            push_request = 0
            push_response = 0
            # push requests 
            requests = chunkList(visit.requests, max_row)
            if requests is not None:  
                for item in requests:
                    print('pushing chunked req: ', str(len(item)))
                    push_request = push_request + len(item)
                    try:
                        execBQRows('your-bigquery-dataset.cookies.requests', item) 
                    except:
                        pushError(siteData.site_id, 'push_request', backup_json=item)
                        push_request = -1 * push_request
                        print(item) 
                
            
            # push responses
            if responses is not None:
                responses = chunkList(visit.responses, max_row)    
                for item in responses:
                    push_response = push_response + len(item)
                    print('pushing chunked res: ', str(len(item)))
                    try:
                        execBQRows('your-bigquery-dataset.cookies.responses', item) 
                    except:
                        print(item)
                        push_response = -1 * push_response
                        pushError(siteData.site_id, 'push_response', backup_json=item)     
            visitLog_ReqRes(visit.visit_id, push_request, push_response) 
        """

    except:
        pushError(siteData.site_id, 'pushBQ')

    # Deprecated, delete if any test is successful.
    """
        # push localStorage


    ##

    if siteData.crawlData != None:
        # stream root & subpages
        allReq = []
        allRes = []
        for site in siteData.crawlData:
            allReq = allReq + site.requests
            allRes = allRes + site.responses

        print('total requests: ', len(allReq))
        print('total responses: ', len(allRes))

        allReq = chunkList(allReq, getConfig('bigquery_insert_rows'))
        allRes = chunkList(allRes, getConfig('bigquery_insert_rows'))

        for item in allReq:
            print('pushing chunked req: ', str(len(item)))
            try:
                execBQRows('your-bigquery-dataset.cookies.http_request',
                           item)
                push_request=1
            except:
                pushError(siteData.site_id, 'bq_request')
                push_request=-1
                print(item)

        for item in allRes:
            print('pushing chunked res: ', str(len(item)))
            try:
                execBQRows('your-bigquery-dataset.cookies.http_response',
                       item)
                push_response=1
            except:
                print(item)
                push_response=-1
                pushError(siteData.site_id, 'bq_response')
        
        if siteData.cookies:
            try:
                print('pushing cookies: ', len(siteData.cookies))
                execBQRows('your-bigquery-dataset.cookies.cookies', siteData.cookies)
                push_cookie=1
            except Exception as e:
                pushError(siteData.site_id, 'bq_cookie')
                print(item)
                push_cookie=-1
                pass

        if siteData.localStorage:
            try:
                print('pushing localStorage:', len(siteData.localStorage))
                execBQRows('your-bigquery-dataset.cookies.localstorage',
                            siteData.localStorage)
                push_localstorage=1
            except Exception as e:
                pushError(siteData.site_id, 'bq_localStorage') 
                push_localstorage=-1
                pass
    """

    return True


def pushError(site_id, source, params=None, backup_json=None):

    if backup_json == None:
        backup_json = "null"
    else:
        import json
        import base64
        encoded = base64.b64encode(
            str(json.dumps(backup_json)).encode('utf-8')).decode('utf-8')
        # encoded=str(backup_json).encode('utf-8')
        backup_json = "'" + str(encoded) + "'"
        #backup_json = str(encoded)[1:]

    try:
        import sys
        import os
        exc_type, exc_obj, exc_tb = sys.exc_info()
        fname = os.path.split(exc_tb.tb_frame.f_code.co_filename)[1]
        err = str(fname) + ':' + str(exc_tb.tb_lineno) + ' - ' + \
            str(exc_obj) + ' - ' + str(exc_type)  # str(exc_type)
    except:
        err = 'UNKNOWN!'
    try:
        query = "INSERT into errors (source, site_id, message, browser_id, backup) values ( '" + source + "', '" + str(
            site_id) + "', '" + err.replace("'", "") + "', '" + getMode() + "'," + backup_json + ")"

        db.exec(query)
    except Exception as e:
        print(e)
        import time
        time.sleep(2)
        try:
            query = "INSERT into errors (source, site_id, message, browser_id) values ( '" + source + "', '" + str(
                site_id) + "', '" + err.replace("'", "") + "', '" + getMode() + "' )"
            db.exec(query)
        except Exception as e:
            print(e)
            print('cant connect DB')


def generateInsertRows(p_queries, dataList, table, columns):

    if dataList is None:
        return p_queries
    if len(dataList) == 0:
        return p_queries

    max_number = getConfig('sql_insert_multiple_rows')
    queries = p_queries
    query_insert = "INSERT INTO " + table + \
        " (" + str(list(columns)
                   ).replace('[', '').replace(']', '').replace('\'', '') + ") VALUES "

    query_sub = ''
    i = 0
    for item in dataList:
        query_value = '('
        for x in columns:
            val = str(item[x])

            if item[x] == None:
                val = 'Null'
            else:
                val = "'" + val + "'"

            if query_value != '(':
                val = ',' + val

            query_value = query_value + val

        query_value = query_value + ' )'
        query_value = query_value

        if i == 0:
            query_sub = query_sub + query_value
        else:
            query_sub = query_sub + ", " + query_value

        if (i % max_number == 0 and i != 0) or i == len(dataList)-1:
            query_sub = query_insert + query_sub
            query_sub = query_sub.replace('VALUES ,', ' VALUES')
            queries.append(query_sub)
            query_sub = ''
        i = i + 1
    return queries


def execQueries(queries):
    # OLD DML BIGQUERY
    from google.cloud import bigquery
    import os
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = os.getcwd() + \
        '/resources/google.json'

    print('Import job started, total rows:' + str(len(queries)))
    client = bigquery.Client()
    for q in queries:
        results = client.query(q)
        for err in results:
            print(err)
