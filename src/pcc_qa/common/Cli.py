import time
import os
from fabric.connection import Connection
from fabric.transfer import Transfer
from invoke import run
from platina_sdk import pcc_api as pcc

#def cli_run(host_ip:str, cmd:str, linux_user:str, linux_password:str=None, linux_key_path:str=None)->dict:
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
        #if linux_key_path:
        #    c = Connection(linux_user + "@" + host_ip, connect_kwargs={'key_filename': linux_key_path})
        #else:
        c = Connection(linux_user + "@" + host_ip, connect_kwargs={'password': linux_password})
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
        cli_run(host_ip=host_ip, linux_user=linlinux_user, linux_password=linux_password, cmd=cmd_remove_logs)

        cmd_remove_archive = "sudo docker exec pccserver sh -c 'rm -rf logs/archive';sudo docker exec platina-executor sh -c 'rm -rf logs/archive'"
        cli_run(host_ip=host_ip, linux_user=linux_user, linux_password=linux_password, cmd=cmd_remove_archive)

        cmd_remove_ansible_backup = "sudo docker exec pccserver sh -c 'rm -rf logs/ansible-backup-logs';sudo docker exec platina-executor sh -c 'rm -rf logs/ansible-backup-logs'"
        cli_run(host_ip=host_ip, linux_user=linux_user, linux_password=linux_password, cmd=cmd_remove_ansible_backup)

        cmd_remove_k8s_logs="sudo docker exec platina-executor sh -c 'rm -r /home/jobs/kubernetes/cluster/*'"
        cli_run(host_ip=host_ip, linux_user=linux_user, linux_password=linux_password, cmd=cmd_remove_k8s_logs)
        
        cmd_remove_ceph_logs="sudo docker exec pccserver sh -c 'rm -r /home/jobs/ceph/cluster/*'"
        cli_run(host_ip=host_ip, linux_user=linux_user, linux_password=linux_password, cmd=cmd_remove_ceph_logs)

        cmd_truncate_logs = "sudo docker exec pccserver sh -c 'truncate -s 0 logs/*.log';sudo docker exec platina-executor sh -c 'truncate -s 0 logs/*.log'"
        return cli_run(host_ip=host_ip, linux_user=linux_user, linux_password=linux_password, cmd=cmd_truncate_logs)
                
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
        cli_run(host_ip=host_ip, linux_user=linux_user, linux_password=linux_password, cmd=cmd)
        os.makedirs("output/pccserver_logs", exist_ok=True)
        cli_copy_from_remote_to_local(host_ip, linux_user, linux_password, "/tmp/logs/ansible.log", "output/pccserver_logs/ansible.log")
        cli_copy_from_remote_to_local(host_ip, linux_user, linux_password, "/tmp/logs/default.log", "output/pccserver_logs/default.log")
        cli_copy_from_remote_to_local(host_ip, linux_user, linux_password, "/tmp/logs/detailed.log", "output/pccserver_logs/detailed.log")
        cli_copy_from_remote_to_local(host_ip, linux_user, linux_password, "/tmp/logs/error.log", "output/pccserver_logs/error.log")
        cmd = "sudo rm -rf /home/ceph/; sudo docker cp pccserver:/home/jobs/ceph /tmp"
        cli_run(host_ip=host_ip, linux_user=linux_user, linux_password=linux_password, cmd=cmd)
        os.makedirs("output/pccserver_logs/ceph", exist_ok=True)
        cli_copy_folder_from_remote_to_local(host_ip, linux_user, linux_password, "/tmp/ceph/cluster/","output/pccserver_logs/ceph/")
                
        cmd = "sudo rm -rf /tmp/logs; sudo docker cp platina-executor:/home/logs/ /tmp"
        cli_run(host_ip=host_ip, linux_user=linux_user, linux_password=linux_password, cmd=cmd)
        os.makedirs("output/platina_executor_logs", exist_ok=True)
        cli_copy_from_remote_to_local(host_ip, linux_user, linux_password, "/tmp/logs/ansible.log", "output/platina_executor_logs/ansible.log")
        cli_copy_from_remote_to_local(host_ip, linux_user, linux_password, "/tmp/logs/default.log", "output/platina_executor_logs/default.log")
        cli_copy_from_remote_to_local(host_ip, linux_user, linux_password, "/tmp/logs/detailed.log", "output/platina_executor_logs/detailed.log")
        cli_copy_from_remote_to_local(host_ip, linux_user, linux_password, "/tmp/logs/error.log", "output/platina_executor_logs/error.log")
        cmd = "sudo rm -rf /home/kubernetes/; sudo docker cp platina-executor:/home/jobs/kubernetes /tmp"
        cli_run(host_ip=host_ip, linux_user=linux_user, linux_password=linux_password, cmd=cmd)
        os.makedirs("output/platina_executor_logs/kubernetes", exist_ok=True)
        cli_copy_folder_from_remote_to_local(host_ip, linux_user, linux_password, "/tmp/kubernetes/cluster/","output/platina_executor_logs/kubernetes/")
        
        cmd = "sudo rm -rf /output/logs"
        os.system(cmd)       
        
        return "OK"
    except Exception as e:
        return {"Error": str(e)}
