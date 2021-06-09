import jwt
import time
import hashlib
import requests
import json
from datetime import datetime
import xml.etree.ElementTree as ET
from robot.api.deco import keyword


############################################# Golbal Variables #################################################
pass_dict = {}
fail_dict = {}
skip_dict = {}
zephyr_tc_id_dict={}
pass_list = []
fail_list = []
skip_list = []
zephyr_json=[]
BASE_URL="https://prod-play.zephyr4jiracloud.com/connect"
account_id="5e2a8bc92ca5600ca8c1591b"
access_key="YjMxMDQ0YjAtNDkxNC0zYzE0LWI4ZTctZTJkYmQyMDljZjhlIDVlMmE4YmM5MmNhNTYwMGNhOGMxNTkxYiBVU0VSX0RFRkFVTFRfTkFNRQ"
expire=3600
secret_key="1CcujmVbwCCeGzzFqItXkYKcx57yVUgwdPdsqNdb4Oc"
cycle_name="PCC_QA_System_Regression_Suite"
project_id="10011"
################################################################################################################

def is_json(data):
    try:
        json.loads(data)
    except ValueError:
        return False
    return True

def parse_xml():
    root = ET.parse('../output/sample2.xml').getroot()
    print(root)
    suite_name = root.find('suite')
    #print(suite_name.attrib)
    # iterate over all the nodes with tag name - suite
    for robot_file in suite_name.findall('suite'):
        #print(robot_file.attrib)
        for folder_name in robot_file.findall('suite'):
            #print("folder name {}".format(folder_name))
            for test_case in folder_name:
                test_attributes = test_case.attrib
                #print("test_attributes: {}".format(test_attributes))
                if 'id' not in test_attributes:
                    break
                status = test_case.find('status')
                status_value = status.attrib['status']
                #print(status_value)
                #print("test attribute : {}".format(test_attributes['name'].upper()))
                if 'TCP' in test_attributes['name'].upper() and status_value == 'FAIL':
                    tcp = test_attributes['name'].split(':')[-1]
                    #print("tcp: {}".format(tcp))
                    tcp_list = tcp.split(',')
                    for tcp_id in tcp_list:
                        fail_dict[tcp_id.strip().upper()] = status_value
                elif 'TCP' in test_attributes['name'].upper() and status_value == 'PASS':
                    tcp = test_attributes['name'].split(':')[-1]
                    tcp_list = tcp.split(',')
                    for tcp_id in tcp_list:
                        pass_dict[tcp_id.strip().upper()] = status_value
                elif 'TCP' in test_attributes['name'].upper() and status_value == 'SKIP':
                    tcp = test_attributes['name'].split(':')[-1]
                    tcp_list = tcp.split(',')
                    for tcp_id in tcp_list:
                        skip_dict[tcp_id.strip().upper()] = status_value

    print("PASS: {}".format(pass_dict))
    print("FAIL: {}".format(fail_dict))
    print("SKIP: {}".format(skip_dict))


def get_cycle_list():
    RELATIVE_PATH="/public/rest/api/1.0/cycles/search?versionId=-1&expand=&projectId={}".format(project_id)
    Canonical_RELATIVE_PATH ="/public/rest/api/1.0/cycles/search"+"&expand="+"&projectId=" + project_id + "&versionId=-1"


    canonical_path_get = "GET&" + Canonical_RELATIVE_PATH
    qsh = hashlib.sha256(canonical_path_get.encode('utf-8')).hexdigest()

    payload = {
        'sub': account_id,
        'qsh': qsh,
        'iss': access_key,
        'exp': time.time() + expire,
        'iat': time.time()
    }
    token = jwt.encode(payload, secret_key, algorithm='HS256')

    print("token = {}".format(token))

    headers = {
                'Authorization': 'JWT '+token,
                'Content-Type': 'text/plain',
                'zapiAccessKey': access_key
            }
    print("Headers are:{}".format(str(headers)))

    raw_result = requests.get(BASE_URL + RELATIVE_PATH, headers=headers)
    print("Raw result is: {}".format(raw_result))
    print("Raw result text is: {}".format(raw_result))

    json_result = json.loads(raw_result.text)
    return json.dumps(json_result, indent=4, sort_keys=True)


def get_cycle_id(cycle_summary_json):
    for cycle in cycle_summary_json:
        if cycle["name"] == cycle_name:
            return cycle["id"]

def create_folder_in_cycle(cycle_id):
    relative_path= "/public/rest/api/1.0/folder"
    Canonical_RELATIVE_PATH ="/public/rest/api/1.0/folder"
    canonical_path_post = "POST&" + Canonical_RELATIVE_PATH + '&'
    qsh = hashlib.sha256(canonical_path_post.encode('utf-8')).hexdigest()

    payload = {
        'sub': account_id,
        'qsh': qsh,
        'iss': access_key,
        'exp': time.time() + expire,
        'iat': time.time()
    }
    token = jwt.encode(payload, secret_key, algorithm='HS256')

    print("token = {}".format(token))

    headers = {
        'Authorization': 'JWT ' + token,
        'Content-Type': 'application/json',
        'zapiAccessKey': access_key
    }
    print("Headers are:{}".format(str(headers)))

    payload_folder = {"name": str(datetime.now().strftime("%d/%m/%Y-%H:%M")) + " Test cycle",
                      "description": "",
                      "cycleId": cycle_id,
                      "versionId": "-1",
                      "clearCustomFieldsFlag": "true",
                      "projectId": project_id
                      }
    print("payload folder are:{}".format(str(payload_folder)))
    print("type:{}".format(type(payload_folder)))

    raw_result = requests.post(BASE_URL + relative_path, headers=headers,json=payload_folder)
    print("Raw result for folder creation: {}".format(raw_result))

    json_result = json.loads(raw_result.text)
    print("json result : {}".format(json_result))
    return json.dumps(json_result, indent=4, sort_keys=True)


def clone_to_folder(cycle_id,folder_id):
    RELATIVE_PATH="/public/rest/api/1.0/executions/add/folder/{}".format(folder_id)
    Canonical_RELATIVE_PATH="/public/rest/api/1.0/executions/add/folder/{}".format(folder_id)
    canonical_path_post = "POST&" + Canonical_RELATIVE_PATH + '&'
    qsh = hashlib.sha256(canonical_path_post.encode('utf-8')).hexdigest()

    payload = {
        'sub': account_id,
        'qsh': qsh,
        'iss': access_key,
        'exp': time.time() + expire,
        'iat': time.time()
    }
    token = jwt.encode(payload, secret_key, algorithm='HS256')

    print("token = {}".format(token))

    headers = {
        'Authorization': 'JWT ' + token,
        'Content-Type': 'application/json',
        'zapiAccessKey': access_key
    }
    print("Headers are:{}".format(str(headers)))

    clone_folder = {"fromVersionId":"-1",
                    "fromCycleId":cycle_id,
                    "labels":"",
                    "hasDefects":"false",
                    "clearCustomFieldsFlag":"false",
                    "withStatuses":"",
                    "method":"3",
                    "versionId":"-1",
                    "projectId":project_id,
                    "cycleId":cycle_id
                    }
    print("clone folder are:{}".format(str(clone_folder)))
    print("type:{}".format(type(clone_folder)))

    raw_result = requests.post(BASE_URL + RELATIVE_PATH, headers=headers, json=clone_folder)
    print("Raw result for cloning: {}".format(raw_result))
    return raw_result.text


def get_testcase_zephyr_id(folder_id,cycle_id,offset):
    RELATIVE_PATH = "/public/rest/api/2.0/executions/search/folder/{}?projectId={}&versionId=-1&cycleId={}".format(folder_id,project_id,cycle_id)
    Canonical_RELATIVE_PATH = "/public/rest/api/2.0/executions/search/folder/"+folder_id+"&cycleId="+cycle_id+"&offset="+str(offset)+"&projectId="+project_id+"&versionId=-1"


    canonical_path_get = "GET&" + Canonical_RELATIVE_PATH
    print('cNONICAL PATH = ',canonical_path_get)
    qsh = hashlib.sha256(canonical_path_get.encode('utf-8')).hexdigest()
    print('qsh= ',qsh)

    payload = {
        'sub': account_id,
        'qsh': qsh,
        'iss': access_key,
        'exp': time.time() + expire,
        'iat': time.time()
    }
    token = jwt.encode(payload, secret_key, algorithm='HS256').strip()

    print("token = {}".format(token))

    headers = {
        'Authorization': 'JWT ' + token,
        'Content-Type': 'text/plain',
        'zapiAccessKey': access_key
    }
    print("Headers are:{}".format(str(headers)))

    response = requests.get(BASE_URL + RELATIVE_PATH +'&offset=' + str(offset), headers=headers)
    print("response {}".format(response))
    print("response text is: {}".format(response.text))
    data = json.loads(response.text)
    print("data= {}".format(data["searchResult"]["searchObjectList"]))
    zephyr_json.extend(data["searchResult"]["searchObjectList"])
    if offset < data["searchResult"]["totalCount"]:
        offset += 50
        return get_testcase_zephyr_id(folder_id, cycle_id, offset)
    else:
        return zephyr_json


def create_dict_for_zephyr_tc(list_of_zephyr_search_result):
    for data in list_of_zephyr_search_result:
        zephyr_tc_id_dict[data["issueKey"]] = data["execution"]["id"]
    print("zephyr tc's with ids : {}".format(zephyr_tc_id_dict))
    print("Total zephyr id = {}".format(len(zephyr_tc_id_dict)))

def create_list_for_zephyr_bulk_post():
    non_executed_list=[]
    for tcp_id in zephyr_tc_id_dict:
        if tcp_id in pass_dict:
            pass_list.append(zephyr_tc_id_dict[tcp_id])
        elif tcp_id in fail_dict:
            fail_list.append(zephyr_tc_id_dict[tcp_id])
        elif tcp_id in skip_dict:
            skip_list.append(zephyr_tc_id_dict[tcp_id])
        else:
            non_executed_list.append(zephyr_tc_id_dict[tcp_id])
    print("Pass list : {}".format(pass_list))
    print("fail list : {}".format(fail_list))
    print("skip list : {}".format(skip_list))
    print("not executed list : {}".format(non_executed_list))

def tc_status_bulk_update(status_list,status,qsh=None):
    relative_path= "/public/rest/api/1.0/executions"
    Canonical_RELATIVE_PATH="/public/rest/api/1.0/executions"
    canonical_path_post = "POST&" + Canonical_RELATIVE_PATH + '&'
    qsh = hashlib.sha256(canonical_path_post.encode('utf-8')).hexdigest()

    payload = {
        'sub': account_id,
        'qsh': qsh,
        'iss': access_key,
        'exp': time.time() + expire,
        'iat': time.time()
    }
    token = jwt.encode(payload, secret_key, algorithm='HS256')

    print("token = {}".format(token))

    headers = {
        'Authorization': 'JWT ' + token,
        'Content-Type': 'application/json',
        'zapiAccessKey': access_key
    }
    print("Headers are:{}".format(str(headers)))
    payload_list=list(set(status_list))
    status_update_payload = {"status":status,
                             "clearDefectMappingFlag":"false",
                             "testStepStatusChangeFlag":"false",
                             "stepStatus":"null",
                             "executions":payload_list
                             }
    print("status_update_payload are:{}".format(str(status_update_payload)))
    print("type:{}".format(type(status_update_payload)))

    raw_result = requests.post(BASE_URL + relative_path, headers=headers,json=status_update_payload)
    print("Raw result for status updation: {}".format(raw_result))

    return raw_result.text

####################################################################################################################
@keyword(name="PCC.Zephyr Integration")
##################################################################################################################
def zephyr_integration():
    print("\n\n########################################## List of PASS, FAIL, SKIP test cases with status ###########################################\n\n")
    parse_xml()

    print("\n\n########################################## List of cycle summary - JSON Response ###########################################\n\n")
    cycle_summary_json = get_cycle_list()
    print("cycle summary json = {}".format(cycle_summary_json))

    print("\n\n########################################## cycle Summary ID ###########################################\n\n")
    cycle_id = get_cycle_id(json.loads(cycle_summary_json))
    print("cycle id = {}".format(cycle_id))

    print("\n\n########################################## Folder creation - JSON Response ###########################################\n\n")
    create_folder_json=create_folder_in_cycle(cycle_id)
    print("create folder json = {}".format(create_folder_json))

    print("\n\n########################################## Fetching Folder ID ###########################################\n\n")
    folder_id=json.loads(create_folder_json)["id"]
    print("folder id = {}".format(folder_id))

    print("\n\n########################################## Cloning Test Cases on New Folder ###########################################\n\n")
    clone_response=clone_to_folder(cycle_id,folder_id)
    print("clone response= {}".format(clone_response))

    print("\n\n########################################## Getting Testcases Zephyr ID ###########################################\n\n")
    zephyr_tc_response=get_testcase_zephyr_id(folder_id,cycle_id,0)
    print("zephyr_tc_response= {}".format(zephyr_tc_response))

    print("\n\n########################################## List of Zephyr Search Result ###########################################\n\n")
    list_of_zephyr_search_result = zephyr_tc_response
    print("zephyr_search_result : {}".format(list_of_zephyr_search_result))

    create_dict_for_zephyr_tc(list_of_zephyr_search_result)
    create_list_for_zephyr_bulk_post()

    print("\n\n########################################## Bulk status updation ###########################################\n\n")
    #For pass
    if pass_list:
        pass_tc_json=tc_status_bulk_update(pass_list,status=1)
        print("pass tc json : {}".format(pass_tc_json))
    #For skip
    if skip_list:
        skip_tc_json=tc_status_bulk_update(skip_list,status=-1)
        print("skip tc json : {}".format(skip_tc_json))
    #For fail
    if fail_list:
        fail_tc_json=tc_status_bulk_update(fail_list,status=2)
        print("fail tc json : {}".format(fail_tc_json))

    return "OK"

