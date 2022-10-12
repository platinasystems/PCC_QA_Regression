import time
import os
import re
from platina_sdk import pcc_api as pcc

## Node
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

## Node
def get_node_by_id(conn:dict, Id:str)->dict:
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
            if str(node['Id']) == str(Id):
                return node
        return None
    except Exception as e:
        return {"Error": str(e)}

def get_hostip_by_name(conn:dict, Name:str)->str:
    """
    Get HostIP by Name
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Node 
    [Returns]
        (str) HostIP: HostIP of the matchining Node, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    node_list = pcc.get_nodes(conn)['Result']['Data']
    try:
        for node in node_list:
            if str(node['Name']) == str(Name):
                return node['Host']
        return None
    except Exception as e:
        return {"Error": str(e)}
        
def get_host_name_by_ip(conn:dict, ip:str)->str:
    """
    Get HostName by IP
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Ip: IP of the Host Node 
    [Returns]
        (dict) Error response: If Exception occured
    """
    node_list = pcc.get_nodes(conn)['Result']['Data']
    try:
        for node in node_list:
            if str(node['Host']) == str(ip):
                return node['Name']
        return None
    except Exception as e:
        return {"Error": str(e)}
    
## Node Group (Cluster)
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
            if str(cluster['name']) == str(Name):
                return cluster['id']
        return None
    except Exception as e:
        return {"Error": str(e)}


##Roles
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
      

        return {"Error": str(e)} 
        
## Storage
def get_ceph_cluster_id_by_name(conn:dict, Name:str)->int:
    """
    Get Id of Ceph Cluster with matching Name from PCC
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of Ceph Cluster
    [Returns]
        (int) Id: Id of the matchining ceph cluster, or
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

def get_ceph_cluster_by_name(conn:dict, Name:str)->int:
    try:
        list_of_ceph_cluster = pcc.get_ceph_clusters(conn)['Result']['Data']
        for ceph_cluster in list_of_ceph_cluster:
            if str(ceph_cluster['name']) == str(Name):
                return ceph_cluster
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
        (int) Id: Id of the matchining pool, or
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
        (int) Id: Id of the matchining rbd, or
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
        (int) Id: Id of the matchining Fs, or
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

def get_ceph_rgw_id_by_name(conn:dict, Name:str, Ceph_cluster_name:str)->int:
    """
    Get Id of Ceph Rgw with matching Name from PCC
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of Ceph Rgw
    [Returns]
        (int) Id: Id of the matchining Rgw, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    try:
        ceph_cluster_id = str(get_ceph_cluster_id_by_name(conn, Name=Ceph_cluster_name))
        list_of_ceph_rgws = pcc.get_ceph_rgws(conn,ceph_cluster_id)['Result']['Data']
        for ceph_rgw in list_of_ceph_rgws:
            if str(ceph_rgw['name']).lower() == str(Name).lower():
                return ceph_rgw['ID']
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
    profile_list = pcc.get_profiles(conn)['Result']['Data']
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
def get_openssh_keys_id_by_name(conn:dict, Name:str)->int:
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
    get_openSSH_keys_list = pcc.get_keys(conn)['Result']
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
def get_os_label_by_name(conn:dict, Name:str)->str:
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
    print("Name in get_os_label_by_name: {}".format(Name))
    OS_list = pcc.get_images(conn)['Result']['Data']
    print("OS list: {}".format(OS_list))
    try:
        for OS in OS_list:
            print("OS found: {}".format(OS['name']))
            print("OS looking for : {}".format(Name))
            if str(OS['name']) == str(Name):
                return OS['label']
        return None
    except Exception as e:
        return {"Error": str(e)}
        
## Erasure code        
def get_erasure_code_profile_id_by_name(conn:dict, Name:str)->int:
    """
    Get Erasure code profile Id by Name
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Erasure code profile
    [Returns]
        (int) Id: Id of the matchining Certificate, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    erasure_code_profile_list = pcc.get_all_erasure_code_profile(conn)['Result']['Data']
    try:
        for profile in erasure_code_profile_list:
            if str(profile['name']) == str(Name):
                return profile['id']
        return None
    except Exception as e:
        return {"Error": str(e)}
        
def get_erasure_ceph_pool_id_by_name(conn:dict, Name:str)->int:
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
        list_of_erasure_ceph_pools = pcc.get_erasure_ceph_pools(conn)['Result']['Data']
        for ceph_pool in list_of_erasure_ceph_pools:
            if str(ceph_pool['name']) == str(Name):
                return ceph_pool['id']
        return None
    except Exception as e:
        return {"Error": str(e)}

## Network Manager
def get_network_clusters_id_by_name(conn:dict, Name:str)->int:
    """
    Get Id of Network Manager with matching Name from PCC
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of Network Manager
    [Returns]
        (int) Id: Id of the matching Nework Manager, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    try:
        list_of_network_manager = pcc.get_network_clusters(conn)['Result']['Data']
        for networks in list_of_network_manager:
            if str(networks['name']) == str(Name):
                return networks['id']
        return None
    except Exception as e:
        return {"Error": str(e)}
        
## Application Credentials
def get_metadata_profile_id_by_name(conn:dict, Name:str)->int:
    """
    Get Metadata Profile Id by Name
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the Metadata profile
    [Returns]
        (int) Id: Id of the matchining Metadata profile, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    
    try:
        profiles_list = pcc.get_metadata_profiles(conn)['Result']['Data']
        for profile in profiles_list:
            if str(profile['name']) == str(Name):
                return profile['id']
        return None
    except Exception as e:
        return {"Error": str(e)} 

def get_app_credentials_profile_id_by_name(conn:dict, Name:str)->int:
    """
    Get App credentials Profile Id by Name
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the App credential profile
    [Returns]
        (int) Id: Id of the matchining App credential profile, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    profile_ids = []
    try:
        profiles_list = pcc.get_application_credential_profiles(conn)['Result']['Data']
        for profile in profiles_list:
            if str(profile['name']) == str(Name):
                profile_ids.append(profile['id'])
        return profile_ids
    except Exception as e:
        return {"Error": str(e)}

def get_app_credentials_profile_by_name(conn: dict, Name: str) -> int:
    """
    Get App credentials Profile Id by Name
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of the App credential profile
    [Returns]
        (int) Id: Id of the matchining App credential profile, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    profiles = []
    try:
        profiles_list = pcc.get_application_credential_profiles(conn)['Result']['Data']
        for profile in profiles_list:
            if str(profile['name']) == str(Name):
                profiles.append(profile)
        return profiles
    except Exception as e:
        return {"Error": str(e)}


## Alerts
def get_alert_id_by_name(conn:dict, Name:str)->int:
    """
    Get Id of Alert with matching Name from PCC
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of Alert
    [Returns]
        (int) Id: Id of the matchining alert name, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    try:
        list_of_alerts = pcc.get_alert_rules(conn)['Result']['Data']
        for alert in list_of_alerts:
            if str(alert['name']) == str(Name):
                return alert['id']
        return None
    except Exception as e:
        return {"Error": str(e)}

## IPAM
def get_subnet_id_by_name(conn:dict, Name:str)->int:
    """
    Get Id of Subnet with matching Name from PCC
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of Subnet
    [Returns]
        (int) Id: Id of the matchining subnet name, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    try:
        list_of_subnets = pcc.get_subnet_objs(conn)['Result']['Data']
        for subnet in list_of_subnets:
            if str(subnet['name']) == str(Name):
                return subnet['id']
        return None
    except Exception as e:
        return {"Error": str(e)}

## Policy driven management
def get_scope_id_by_name(conn:dict, Name:str, ParentID = None)->int:
    """
    Get Id of Scope with matching Name from PCC
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Name: Name of Scope
    [Returns]
        (int) Id: Id of the matchining scope name, or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    try:
        list_of_scopes = pcc.get_all_scopes(conn)['Result']['Data']
        a= True
        print("Name: {} and parentID: {} in easy".format(Name,ParentID))
        #### For tree structure of parent #####
        # for scopes in list_of_scopes:
        #     while a:
        #         if type(scopes['parent']) == dict:
        #             if scopes['name']== str(Name) and scopes['parentID'] == ParentID:
        #                 return scopes['id']
        #             else:
        #                 scopes = scopes['parent']
        #         elif str(scopes['name']) == str(Name):
        #             return scopes['id']
        #         else:
        #             break
        
        #### For one-one structure of parent ####
        for scopes in list_of_scopes:
            if ParentID:
                if scopes['name']== str(Name) and scopes['parentID'] == int(ParentID):
                    print("Required id is: {}".format(scopes['id']))
                    return scopes['id']
            elif scopes['name'] == str(Name):
                return scopes['id']
        return "Id not found for scope: {}".format(Name)
        
    except Exception as e:
        return {"Error": str(e)}
        
def get_policy_id(conn:dict, Desc:str, AppID:int)->int:
    """
    Get Id of Policy with matching Description and appID from PCC
    [Args]
        (dict) conn: Connection dictionary obtained after logging in
        (str) Desc: Description of Scope
    [Returns]
        (int) Id: Id of the matchining scope or
            None: if no match found, or
        (dict) Error response: If Exception occured
    """
    try:
        list_of_policies = pcc.get_all_policies(conn)['Result']['Data']
        for policy in list_of_policies:
            if str(policy['appId'])== str(AppID):
                if str(policy['description']) == str(Desc):
                    return policy['id']
        return None
    except Exception as e:
        return {"Error": str(e)} 
