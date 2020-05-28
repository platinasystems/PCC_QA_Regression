import time
import os
from fabric.connection import Connection
from fabric.transfer import Transfer
from invoke import run
from platina_sdk import pcc_api as pcc

PCC_TIMEOUT = 60*5  # 5 min

## Login
def login(**kwargs)->dict:
    """
    Login to PCC

    [Args in kwargs]
        url: URL of the PCC being tested
        username: PCC Username (default: admin)
        password: PCC Password (default: admin)
        proxy: URL for HTTPS proxy (default: none)
        insecure: Suppress warnings about bad TLS certificates (default: False)
        use_session: Use Python requests Session objects to maintain session (default: True)

    [Returns]
        conn: Dictionary containing session and token
    """
    if "proxy" not in kwargs:
        kwargs["proxy"] = None
    if "insecure" not in kwargs:
        kwargs["insecure"] = False
    if "use_session" not in kwargs:
        kwargs["use_session"] = True

    return pcc.login(
        kwargs["url"], 
        kwargs["username"], 
        kwargs["password"], 
        kwargs["proxy"], 
        kwargs["insecure"], 
        kwargs["use_session"])

## Node
def wait_until_node_deleted(conn:dict, Name:str)->int:
    """
    Wait Until Node Deleted
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Node 
    [Returns]
        (dict) Wait time 
        (dict) Error response: If Exception occured
    """
    found = True
    time_waited = 0
    timeout = time.time() + PCC_TIMEOUT
    while found:
        found = False
        node_list = pcc.get_nodes(conn)['Result']['Data']
        for node in node_list:
            if str(node['Name']) == str(Name):
                found = True
        if time.time() > timeout:
            return {"Error": "Timeout"}
        if not found:
            time.sleep(5)
            time_waited += 5
    return "OK"

def wait_until_node_ready(conn:dict, Name:str)->int:
    """
    Wait Until Node Ready
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Node 
    [Returns]
        (dict) Wait Time 
        (dict) Error response: If Exception occured
    """
    ready = False
    time_waited = 0
    timeout = time.time() + PCC_TIMEOUT
    while not ready:
        ready = False
        node_list = pcc.get_nodes(conn)['Result']['Data']
        for node in node_list:
            if str(node['Name']) == str(Name):
                if node['provisionStatus'] == 'Ready':
                    ready = True
        if time.time() > timeout:
            return {"Error": "Timeout"}
        if not ready:
            time.sleep(5)
            time_waited += 5
    return "OK"

def get_node_id_by_name(conn:dict, Name:str)->int:
    """
    Get Node Id by Name
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Node 
    [Returns]
        (int) Id: Id of the matchining Node, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    node_list = pcc.get_nodes(conn)['Result']['Data']
    try:
        for node in node_list:
            if str(node['Name']) == str(Name):
                return node['Id']
        return None
    except Exception as e:
        return {"Error": str(e)}

def check_node_exists(conn:dict, IP:str)->str:
    """
    Check if node already exists and provision status is Ready
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) IP: IP of the Node
    [Returns]
        (bool) True: if IP matches the node host in the list of nodes
            else False: if doesnot exists
        (dict) Error response: If Exception occured
    """
    node_list = pcc.get_nodes(conn)['Result']['Data']
    try:
        for node in node_list:
            if (str(node['Host']) == str(IP)) and (str(node['provisionStatus']) == 'Ready'):
                return True
        return False
    except Exception as e:
        return {"Error": str(e)}
    
## Node Group (Cluster)
def get_node_groups(**kwargs)->dict:
    """
    Get Node Groups list from PCC

    [Args in kwargs]
        (dict) conn: Connection dictionary obtained after logging in

    [Returns]
        (dict) Response: Get Node Group response (includes any errors)
    """
    return pcc.get_clusters(kwargs["conn"])

def add_node_group(**kwargs)->dict:
    """
    Add Node Group to PCC

    [Args in kwargs]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Node Group name
        (str) Description: Node 

    [Returns]
        (dict) Response: Add Cluster response (includes any errors)
    """
    if "Description" not in kwargs:
        kwargs["Description"] = None
    elif "owner" not in kwargs:
        kwargs["owner"] = 0  # default to ROOT
    try:
        data = {
            "Name": kwargs["Name"],
            "Description": kwargs["Description"],
            "owner": kwargs["owner"]
        }
        return pcc.add_cluster(kwargs["conn"], data)
    except Exception as e:
        return "Exception %s" % e

def get_node_group_id_by_name(conn:dict, Name:str)->int:
    """
    Get Node Group Id by Name
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Cluster 
    [Returns]
        (int) Id: Id of the matchining Cluster, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    cluster_list = pcc.get_clusters(conn)['Result']['Data']
    try:
        for cluster in cluster_list:
            if str(cluster['Name']) == str(Name):
                return cluster['Id']
        return None
    except Exception as e:
        return {"Error": str(e)}

def delete_node_group_by_name(conn:dict, Name:str)->dict:
    """
    Delete Node Group by Name
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Cluster to be deleted

    [Returns]
        (dict) Response: Delete Cluster response (includes any errors)
    """
    Id = get_node_group_id_by_name(conn, Name)

    if Id is None:
        return None
    else:
        return pcc.delete_cluster_by_id(conn, Id)

def validate_node_group_by_name(conn:dict, Name:str)->str:
    """
    Validate Node Group by Name
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Cluster

    [Returns]
        "OK": If node group present in PCC
        else: "Node group not available" : If node group not present in PCC
        
    """
    cluster_list = pcc.get_clusters(conn)['Result']['Data']
    try:
        for cluster in cluster_list:
            if str(cluster['Name']) == str(Name):
                return "OK"
        return "Node group not available"
    except Exception as e:
        return {"Error": str(e)}
        
def validate_node_group_description_by_name(conn:dict, Name:str, Description:str)->str:
    """
    Validate Node Group by Name
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Cluster
        (str) Description: Description of the Cluster

    [Returns]
        "OK": If node group description matches
        else: "Description does not match" : If node group not present in PCC
        
    """
    cluster_list = pcc.get_clusters(conn)['Result']['Data']
    try:
        for cluster in cluster_list:
            if str(cluster['Name']) == str(Name):
                if str(cluster['Description']) == str(Description):
                    return "OK"
        return "Description does not match"
    except Exception as e:
        return {"Error": str(e)}

def validate_node_group_assigned_to_node(conn:dict, Name:str, Id:int)->str:
    """
    Validate Node Group assigned to Node
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Node
        (str) Id : Id of the node group

    [Returns]
        "OK": If node group assigned to Node
        else: "Not assigned" : If node group not assigned to node
        
    """
    nodes_response = pcc.get_nodes(conn)['Result']['Data']
    try:
        for node in nodes_response:
            if str(node['Name']) == str(Name):
                if node['ClusterId'] == Id:
                    return "OK"
        return "Not assigned"
    except Exception as e:
        return {"Error": str(e)}       

        
## Node Roles
def get_node_roles(**kwargs)->dict:
    """
    Get Node Roles

    [Args in kwargs]
        (dict) conn: Connection dictionary obtained after logging in

    [Returns]
        (dict) Response: Get Roles response (includes any errors)
    """
    return pcc.get_roles(kwargs["conn"])

def add_node_role(**kwargs)->dict:
    """
    Add Node Role

    [Args in kwargs]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name
        (str) Description
        (list) Applications
        (list) Tenants
    [Returns]
        (dict) Response: Add Node Roles response (includes any errors)
    """
    if "Description" not in kwargs:
        kwargs["Description"] = None

    templateIDs = []
    for application_name in kwargs["Applications"]:
        templateIDs.append(get_app_id_by_name(kwargs["conn"], application_name))

    owners = []
    for tenant_name in kwargs["Tenants"]:
        owners.append(get_tenant_id_by_name(kwargs["conn"], tenant_name))

    data = {
        "name": kwargs["Name"],
        "description": kwargs["Description"],
        "owners": owners,
        "templateIDs": templateIDs
        }
    return pcc.add_role(kwargs["conn"], data)


def modify_node_role(**kwargs)->dict:
    """
    Modify Node Role

    [Args in kwargs]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Id
        (str) Name
        (str) Description
        (list) Applications
        (list) Tenants
    [Returns]
        (dict) Response: Add Node Roles response (includes any errors)
    """
    if "Description" not in kwargs:
        kwargs["Description"] = None

    templateIDs = []
    for application_name in kwargs["Applications"]:
        templateIDs.append(get_app_id_by_name(kwargs["conn"], application_name))

    owners = []
    for tenant_name in kwargs["Tenants"]:
        owners.append(get_tenant_id_by_name(kwargs["conn"], tenant_name))

    data = {
        "name": kwargs["Name"],
        "description": kwargs["Description"],
        "owners": owners,
        "templateIDs": templateIDs
        }
    return pcc.modify_role(kwargs["conn"], kwargs["Id"], data)

def get_node_role_id_by_name(conn:dict, Name:str)->dict:
    """
    Get Node Role Id with matching Name 
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Application
    [Returns]
        (int) Id: Id of the matchining Node Role, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    node_role_list = pcc.get_roles(conn)['Result']['Data']
    try:
        for node_role in node_role_list:
            if str(node_role['name'].lower()) == str(Name).lower():
                return node_role['id']
        return None
    except Exception as e:
        return {"Error": str(e)}

def delete_node_role_by_name(conn:dict, Name:str)->dict:
    """
    Delete Node Role by Name

    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name

    [Returns]
        (dict) Response: Delete Roles response (includes any errors)
    """
    Id = get_node_role_id_by_name(conn, Name)
    return pcc.delete_role_by_id(conn, Id=str(Id))
    
def validate_node_role_by_name(conn:dict, Name:str)->str:
    """
    Validate Node Role by Name
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Node Role

    [Returns]
        "OK": If node role present in PCC
        else: "Node role not available" : If node role not present in PCC
        
    """
    noderoles_list = pcc.get_roles(conn)['Result']['Data']
    try:
        for noderole in noderoles_list:
            if str(noderole['name']) == str(Name):
                return "OK"
        return "Node role not available"
    except Exception as e:
        return {"Error": str(e)}
        
def validate_node_role_description_by_name(conn:dict, Name:str, Description:str)->str:
    """
    Validate Node Role by Name
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Node Role
        (str) Description: Description of the Node role

    [Returns]
        "OK": If node role description matches
        else: "Description does not match" 
        
    """
    noderoles_list = pcc.get_roles(conn)['Result']['Data']
    try:
        for noderole in noderoles_list:
            if str(noderole['name']) == str(Name):
                if str(noderole['description']) == str(Description):
                    return "OK"
        return "Description does not match"
    except Exception as e:
        return {"Error": str(e)}

## Sites
def add_site(**kwargs)->dict:
    """
    Add Site

    [Args in kwargs]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name
        (str) Description
    [Returns]
        (dict) Response: Add Site response (includes any errors)
    """
    if "Description" not in kwargs:
        kwargs["Description"] = None
    data = {
        "Name": kwargs["Name"],
        "Description": kwargs["Description"]
        }
    return pcc.add_site(kwargs["conn"], data)

def modify_site(**kwargs)->dict:
    """
    Modify Site

    [Args in kwargs]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Id
        (str) Name
        (str) Description
    [Returns]
        (dict) Response: Add Site response (includes any errors)
    """
    if "Description" not in kwargs:
        kwargs["Description"] = None
    if "Name" not in kwargs:
        kwargs["Description"] = None 

    data = {
        "Id": kwargs["Id"],
        "Name": kwargs["Name"],
        "Description": kwargs["Description"]
    }

    return pcc.add_site(kwargs["conn"], data)

def get_site_id_by_name(conn:dict, Name:str)->dict:
    """
    Get Id of Site with matching Name 
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of Site
    [Returns]
        (int) Id: Id of the matchining Site, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    site_list = pcc.get_sites(conn)['Result']['Data']
    try:
        for site in site_list:
            if str(site['Name'].lower()) == str(Name).lower():
                return site['Id']
        return None
    except Exception as e:
        return {"Error": str(e)}

def delete_site_by_name(conn:dict, Name:str)->dict:
    """
    Delete Site with matching Name 
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of Site
    [Returns]
        (dict) Delete Site response
    """
    Id = get_site_id_by_name(conn, Name)
    return pcc.delete_sites(conn, [Id])

## Applications
def get_app_id_by_name(conn:dict, Name:str)->dict:
    """
    Get Id of Application with matching Name 
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Application
    [Returns]
        (int) Id: Id of the matchining Application, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    app_list = pcc.get_apps(conn)['Result']['Data']
    try:
        for app in app_list:
            if str(app['name'].lower()) == str(Name).lower():
                return app['id']
        return None
    except Exception as e:
        return {"Error": str(e)}

## Tenant
def get_tenant_id_by_name(conn:dict, Name:str)->dict:
    """
    Get Id of tenant with matching Name from PCC
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of tenant
    [Returns]
        (int) Id: Id of the matchining tenant, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    list_of_tenants = pcc.get_tenant_list(conn)['Result']
    try:
        for tenant in list_of_tenants:
            if str(tenant['name']) == str(Name):
                return tenant['id']
        return None
    except Exception as e:
        return {"Error": str(e)}


def validate_tenant_by_name(conn:dict, Name:str)->str:
    """
    Validate Tenant by Name
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Tenant

    [Returns]
        "OK": If Tenant present in PCC
        else: "Tenant not available" : If Tenant not present in PCC
        
    """
    tenant_list = pcc.get_tenant_list(conn)['Result']
    print("tenant_list: ",tenant_list)
    try:
        for tenant in tenant_list:
            if str(tenant['name']) == str(Name):
                return "OK"
        return "Tenant not available"
    except Exception as e:
        return {"Error": str(e)}
    
        
def validate_tenant_description_by_name(conn:dict, Name:str, Description:str)->str:
    """
    Validate Tenant Desciption by Name
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Tenant
        (str) Description: Description of the Tenant

    [Returns]
        "OK": If Tenant description matches
        else: "Description does not match" 
        
    """
    tenant_list = pcc.get_tenant_list(conn)['Result']
    try:
        for tenant in tenant_list:
            if str(tenant['name']) == str(Name):
                if str(tenant['description']) == str(Description):
                    return "OK"
        return "Description does not match"
    except Exception as e:
        return {"Error": str(e)}

def validate_tenant_assigned_to_node(conn:dict, Name:str, Tenant_Name:str)->str:
    """
    Validate tenant assigned to Node
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Node
        (str) Tenant_Name : Name of the tenant

    [Returns]
        "OK": If tenant assigned to Node
        else: "Not assigned" : If tenant not assigned to node
        
    """
    nodes_response = pcc.get_nodes(conn)['Result']['Data']
    try:
        for node in nodes_response:
            if str(node['Name']) == str(Name):
                if node['tenant'] == str(Tenant_Name):
                    return "OK"
        return "Not assigned"
    except Exception as e:
        return {"Error": str(e)} 
## CLI
def cli_run(host_ip:str, linux_user:str, linux_password:str, cmd:str)->dict:
    """
    CLI Run - Run a Linux command 
    [Args]
        (str) host_ip: 
        (str) linux_user: 
        (str) linux_password: 
        (str) cmd: 
    [Returns]
        (dict) CLI Run response
    """
    try:
        c = Connection(linux_user + "@" + host_ip, connect_kwargs={'password':linux_password})
        return c.run(cmd, warn=True)
    except Exception as e:
        return {"Error": str(e)}

def cli_copy_from_remote_to_local(host_ip:str, linux_user:str, linux_password:str, remote_source:str, local_destination:str)->dict:
    """
    CLI Run - Run a Linux command 
    [Args]
        (str) host_ip: 
        (str) linux_user: 
        (str) linux_password: 
        (str) cmd: 
    [Returns]
        (dict) CLI Run response
    """
    try:
        c = Connection(linux_user + "@" + host_ip, connect_kwargs={'password':linux_password})
        t = Transfer(c)
        return t.get(remote=remote_source, local=local_destination, preserve_mode=True)
        
    except Exception as e:
        return {"Error": str(e)}
        
def cli_copy_folder_from_remote_to_local(host_ip:str, linux_user:str, linux_password:str, remote_source:str, local_destination:str)->dict:
    """
    CLI Run - Run a Linux command 
    [Args]
        (str) host_ip: 
        (str) linux_user: 
        (str) linux_password: 
        (str) cmd: 
    [Returns]
        (dict) CLI Run response
    """
    try:
        cmd='sshpass -p "{}" scp -r {}@{}:{} {}'.format(linux_password,linux_user,host_ip,remote_source,local_destination)
        return os.system(cmd)
    except Exception as e:
        return {"Error": str(e)}

def cli_truncate_pcc_logs(host_ip:str, linux_user:str, linux_password:str)->dict:
    """
    CLI Truncate PCC Logs
    Linux user must sudo without password

    [Args]
        (str) host_ip: 
        (str) linux_user: 
        (str) linux_password: 
    [Returns]
        (dict) CLI Run response
    """
    try:
        
        cmd_remove_logs = "sudo docker exec pccserver sh -c 'rm logs/*.log*';sudo docker exec platina-executor sh -c 'rm logs/*.log*'"
        cli_run(host_ip, linux_user, linux_password, cmd_remove_logs)

        cmd_remove_archive = "sudo docker exec pccserver sh -c 'rm -rf logs/archive';sudo docker exec platina-executor sh -c 'rm -rf logs/archive'"
        cli_run(host_ip, linux_user, linux_password, cmd_remove_archive)

        cmd_remove_ansible_backup = "sudo docker exec pccserver sh -c 'rm -rf logs/ansible-backup-logs';sudo docker exec platina-executor sh -c 'rm -rf logs/ansible-backup-logs'"
        cli_run(host_ip, linux_user, linux_password, cmd_remove_ansible_backup)

        cmd_remove_k8s_logs="sudo docker exec platina-executor sh -c 'rm -r /home/jobs/kubernetes/cluster/*'"
        cli_run(host_ip, linux_user, linux_password, cmd_remove_k8s_logs)
        
        cmd_remove_ceph_logs="sudo docker exec pccserver sh -c 'rm -r /home/jobs/ceph/cluster/*'"
        cli_run(host_ip, linux_user, linux_password, cmd_remove_ceph_logs)

        cmd_truncate_logs = "sudo docker exec pccserver sh -c 'truncate -s 0 logs/*.log';sudo docker exec platina-executor sh -c 'truncate -s 0 logs/*.log'"
        return cli_run(host_ip, linux_user, linux_password, cmd_truncate_logs)        
                
    except Exception as e:
        return {"Error": str(e)}

def cli_copy_pcc_logs(host_ip:str, linux_user:str, linux_password:str)->dict:
    """
    CLI Copy PCC Logs
    Linux user must sudo without password

    [Args]
        (str) host_ip: 
        (str) linux_user: 
        (str) linux_password: 
    [Returns]
        (dict) CLI Run response
    """
    try:
        cmd = "sudo rm -rf /tmp/logs; sudo docker cp pccserver:/home/logs/ /tmp"
        cli_run(host_ip, linux_user, linux_password, cmd)
        os.makedirs("output/pccserver_logs", exist_ok=True)
        cli_copy_from_remote_to_local(host_ip, linux_user, linux_password, "/tmp/logs/ansible.log", "output/pccserver_logs/ansible.log")
        cli_copy_from_remote_to_local(host_ip, linux_user, linux_password, "/tmp/logs/default.log", "output/pccserver_logs/default.log")
        cli_copy_from_remote_to_local(host_ip, linux_user, linux_password, "/tmp/logs/detailed.log", "output/pccserver_logs/detailed.log")
        cli_copy_from_remote_to_local(host_ip, linux_user, linux_password, "/tmp/logs/error.log", "output/pccserver_logs/error.log")
        cmd = "sudo rm -rf /home/ceph/; sudo docker cp pccserver:/home/jobs/ceph /tmp"
        cli_run(host_ip, linux_user, linux_password, cmd) 
        os.makedirs("output/pccserver_logs/ceph", exist_ok=True)
        cli_copy_folder_from_remote_to_local(host_ip, linux_user, linux_password, "/tmp/ceph/cluster/","output/pccserver_logs/ceph/")
                
        cmd = "sudo rm -rf /tmp/logs; sudo docker cp platina-executor:/home/logs/ /tmp"
        cli_run(host_ip, linux_user, linux_password, cmd)
        os.makedirs("output/platina_executor_logs", exist_ok=True)
        cli_copy_from_remote_to_local(host_ip, linux_user, linux_password, "/tmp/logs/ansible.log", "output/platina_executor_logs/ansible.log")
        cli_copy_from_remote_to_local(host_ip, linux_user, linux_password, "/tmp/logs/default.log", "output/platina_executor_logs/default.log")
        cli_copy_from_remote_to_local(host_ip, linux_user, linux_password, "/tmp/logs/detailed.log", "output/platina_executor_logs/detailed.log")
        cli_copy_from_remote_to_local(host_ip, linux_user, linux_password, "/tmp/logs/error.log", "output/platina_executor_logs/error.log")
        cmd = "sudo rm -rf /home/kubernetes/; sudo docker cp platina-executor:/home/jobs/kubernetes /tmp"
        cli_run(host_ip, linux_user, linux_password, cmd) 
        os.makedirs("output/platina_executor_logs/kubernetes", exist_ok=True)
        cli_copy_folder_from_remote_to_local(host_ip, linux_user, linux_password, "/tmp/kubernetes/cluster/","output/platina_executor_logs/kubernetes/")
        
        cmd = "sudo rm -rf /output/logs"
        os.system(cmd)       
        
        return "OK"
    except Exception as e:
        return {"Error": str(e)}

## Storage
def get_ceph_cluster_id_by_name(conn:dict, Name:str)->int:
    """
    Get Id of Ceph Cluster with matching Name from PCC
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of Ceph Cluster
    [Returns]
        (int) Id: Id of the matchining tenant, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    try:
        list_of_ceph_cluster = pcc.get_ceph_clusters(conn)['Result']['Data']
        for ceph_cluster in list_of_ceph_cluster:
            if str(ceph_cluster['name']) == str(Name):
                return ceph_cluster['id']
        return None
    except Exception as e:
        return {"Error": str(e)}

def get_ceph_pool_id_by_name(conn:dict, Name:str)->int:
    """
    Get Id of Ceph Pool with matching Name from PCC
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of Ceph Pool
    [Returns]
        (int) Id: Id of the matchining tenant, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    try:
        list_of_ceph_pools = pcc.get_ceph_pools(conn)['Result']['Data']
        for ceph_pool in list_of_ceph_pools:
            if str(ceph_pool['name']) == str(Name):
                return ceph_pool['id']
        return None
    except Exception as e:
        return {"Error": str(e)}

def get_ceph_rbd_id_by_name(conn:dict, Name:str)->int:
    """
    Get Id of Ceph Rbd with matching Name from PCC
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of Ceph Rbd
    [Returns]
        (int) Id: Id of the matchining tenant, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    try:
        list_of_ceph_rbds = pcc.get_ceph_rbds(conn)['Result']['Data']
        for ceph_rbd in list_of_ceph_rbds:
            if str(ceph_rbd['name']) == str(Name):
                return ceph_rbd['id']
        return None
    except Exception as e:
        return {"Error": str(e)}

def get_ceph_fs_id_by_name(conn:dict, Name:str)->int:
    """
    Get Id of Ceph Fs with matching Name from PCC
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of Ceph Fs
    [Returns]
        (int) Id: Id of the matchining tenant, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    try:
        list_of_ceph_fs = pcc.get_ceph_fs(conn)['Result']['Data']
        for ceph_fs in list_of_ceph_fs:
            if str(ceph_fs['name']) == str(Name):
                return ceph_fs['id']
        return None
    except Exception as e:
        return {"Error": str(e)}
        
## Portus
def get_portus_id_by_name(conn:dict, Name:str)->int:
    """
    Get Portus Id by Name
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Container Registry 
    [Returns]
        (int) Id: Id of the matchining Container Registry, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    portus_list = pcc.get_portus(conn)['Result']['Data']
    try:
        for portus in portus_list:
            if str(portus['name']) == str(Name):
                return portus['id']
        return None
    except Exception as e:
        return {"Error": str(e)}
        
def get_server_id_used_by_portus(conn:dict, Name:str)->int:
    """
    Get Server Id used by Portus by Name
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Container Registry 
    [Returns]
        (int) Id: Id of the server used by Container Registry, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    portus_list = pcc.get_portus(conn)['Result']['Data']
    try:
        for portus in portus_list:
            if str(portus['name']) == str(Name):
                return portus['nodeID']
        return None
    except Exception as e:
        return {"Error": str(e)}        

## Profile
def get_profile_id_by_name(conn:dict, Name:str)->int:
    """
    Get Profile Id by Name
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Auth Profile 
    [Returns]
        (int) Id: Id of the matchining Auth Profile, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    profile_list = pcc.get_authentication_profiles(conn)['Result']['Data']
    try:
        for profile in profile_list:
            if str(profile['name']) == str(Name):
                return profile['id']
        return None
    except Exception as e:
        return {"Error": str(e)}

##Kubernetes
def get_k8s_cluster_id_by_name(conn:dict, Name:str)->int:
    """
    Get Id of K8s Cluster with matching Name from PCC
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of K8s Cluster
    [Returns]
        (int) Id: Id of the matchining tenant, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    try:
        list_of_k8s = pcc.get_kubernetes(conn)['Result']['Data']
        for k8s in list_of_k8s:
            if str(k8s['name']) == str(Name):
                return k8s['ID']
        return None
    except Exception as e:
        return {"Error": str(e)}

def get_k8s_app_id_by_name(conn:dict, Name:str)->int:
    """
    Get Id of K8s App with matching Name from PCC
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of K8s App
    [Returns]
        (int) Id: Id of the matchining tenant, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    try:
        list_of_k8s_apps = pcc.get_kubernetes(conn)['Result']['Data']
        for data in list_of_k8s_apps:
            for app in data['apps']:
                if str(app['appName']) == str(Name):
                    return app['ID']
        return None
    except Exception as e:
        return {"Error": str(e)}

# Roles
def add_role(conn, Name:str, Description:str, owner:int, groupOperationsText:list)->dict:
    """
    Add Role
    [Args]
        (str) Name: Name of the Role
        (str) Description: of the Role
        (list) groupOperations: List of dictionaries containing ids of ops
        (int) owner

    [Returns]
        (dict) Response: Add Role response (includes any errors)
    """
    groupOperationIds = {
        "Telemetry_R":{"id":1},
        "Telemetry_RW":{"id":2},
        "Infrastructure_R":{"id":3}, 
        "Infrastructure_RW":{"id":4}, 
        "AppManagement_R":{"id":5}, 
        "AppManagement_RW":{"id":6}, 
        "AccountManagement_R":{"id":7}, 
        "AccountManagement_RW":{"id":8}, 
        "ServiceManagement_R":{"id":9},
        "ServiceManagement_RW":{"id":10}
    }
    try:
        groupOperations = []
        for groupOperation in groupOperationsText:
            groupOperations.append(
                groupOperationIds[groupOperation]
            )
    except Exception as e:
        raise Exception("[add_role] Invalid group operation: %s" % e)

    try:
        payload = {
                "description": Description,
                "name": Name,
                "owner": owner,
                "groupOperations": groupOperations
        }
        return pcc.add_role(conn, payload)
    except Exception as e:
        return {"Error": str(e)}

def get_role_id_by_name(conn:dict, Name:str)->int:
    """
    Get Role Id by Name
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Role 
    [Returns]
        (int) Id: Id of the matchining Role, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    role_list = pcc.get_roles(conn)['Result']['Data']
    try:
        for role in role_list:
            if str(role['Name']) == str(Name):
                return role['Id']
        return None
    except Exception as e:
        return {"Error": str(e)}
        
## Certificate        
def get_certificate_id_by_name(conn:dict, Name:str)->int:
    """
    Get Certificate Id by Name
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Certificate
    [Returns]
        (int) Id: Id of the matching Certificate, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    
    certificate_list = pcc.get_certificates(conn)['Result']
    try:
        for certificate in certificate_list:
            if str(certificate['alias']) == str(Name):
                return certificate['id']
        return None
    except Exception as e:
        return {"Error": str(e)}
        
        
## OpenSSH Keys        
def get_openSSH_keys_id_by_name(conn:dict, Name:str)->int:
    """
    Get OpenSSH Keys Id by Name
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the OpenSSH Key
    [Returns]
        (int) Id: Id of the matching OpenSSH key, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    get_openSSH_keys_list = pcc.get_openSSH_keys(conn)['Result']
    try:
        for get_openSSH_keys in get_openSSH_keys_list:
            if str(get_openSSH_keys['alias']) == str(Name):
                return get_openSSH_keys['id']
        return None
    except Exception as e:
        return {"Error": str(e)}
        
## Interface        
def get_interface_id_by_name(conn:dict, Name:str)->int:
    """
    Get Certificate Id by Name
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Certificate
    [Returns]
        (int) Id: Id of the matchining Certificate, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    interface_list = pcc.get_all_interfaces(conn)['Result']['Data']
    try:
        for interface in interface_list:
            if str(interface['name']) == str(Name):
                return interface['id']
        return None
    except Exception as e:
        return {"Error": str(e)}
        
## OS Images
def get_OS_label_by_name(conn:dict, Name:str)->str:
    """
    Get OS label by Name
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the OS
    [Returns]
        (string) Label: Label of the matchining OS, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    OS_list = pcc.get_OS_images(conn)['Result']['Data']
    try:
        for OS in OS_list:
            if str(OS['name']) == str(Name):
                return OS['label']
        return None
    except Exception as e:
        return {"Error": str(e)}
