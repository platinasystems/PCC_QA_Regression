from fabric.connection import Connection
import os
import sys
import json
import time
from datetime import datetime
from robot.api import logger
from robot.api.deco import keyword
from aa.common.AaBase import AaBase
from aa.common.LinuxUtils import LinuxUtils
from aa.common.Utils import banner, trace, pretty_print
from platina_sdk import pcc_api as pcc
from platina_sdk import pcc_easy_api as easy

class DockerUtils(AaBase):

    def __init__(self):

        self.hostip = "172.17.10.100"
        self.username = "pcc"
        self.password = "cals0ft"
        self.cmd_output = None
        self.container_name = None
        self.image_name = None
        self.portus_uname = None
        self.registry_url = None
        self.registryPort = None
        self.custom_name = None
        self.port = None
        self.portus_password = None
        self.cmd = None
        self.fullyQualifiedDomainName = None
        self.FQDN_availability = LinuxUtils().is_FQDN_reachable
        super().__init__()

    ###############################################################################################################
    @keyword(name="Is Docker Container Up")
    ###############################################################################################################
    
    # returns OK if Docker Container is up
    # <usage> is_docker_up(container_name=<container name>)
    
    def is_docker_up(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        print("kwargs are: {}".format(kwargs))
        try:
            process_up_status = easy.cli_run(cmd='docker ps|grep -Ew "{}"|grep -v grep | wc -l'.format(self.container_name), host_ip=self.hostip,linux_user=self.username, linux_password=self.password)
            
            serialised_process_up_status = self._serialize_response(time.time(), process_up_status)
            print("serialised_process_up_status is:{}".format(serialised_process_up_status))
            
            self.cmd_output = str(serialised_process_up_status['Result']['stdout']).replace('\n', '').strip()
            if int(self.cmd_output) >= 1:
                return "OK"
            else:
                return "Error"
        except Exception as e:
            logger.console("Error in container_up: " + str(e))
            
    ###############################################################################################################
    @keyword(name="Restart Containers")
    ###############################################################################################################
    
    # returns OK if Containers are restarted
    # <usage> restart_container(container_name=<container name>)
    
    def restart_container(self,*args,**kwargs):
        self._load_kwargs(kwargs)
        print("kwargs are: {}".format(kwargs))
        try:
            self.cmd = "docker restart {}".format(self.container_name)
            container_restart_cmd = easy.cli_run(cmd=self.cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            
            serialised_container_restart_cmd = self._serialize_response(time.time(), container_restart_cmd)
            print("serialised_container_restart_cmd is:{}".format(serialised_container_restart_cmd))
            
            self.cmd_output = str(serialised_container_restart_cmd['Result']['stdout']).replace('\n', '').strip()
            print("output of restart_container:{}".format(self.cmd_output))
            if self.container_name in self.cmd_output:
                return "OK"
            else:
                return "Error"
        except Exception as e:
            logger.console("Error in restart container: " + str(e))
    
            
    ###############################################################################################################
    @keyword(name="Check if image exists in local repo")
    ###############################################################################################################
    
    # returns OK if image exists in local repo
    # <usage> check_image_in_repo(image_name=<image_name>)
    
    def check_image_in_repo(self,**kwargs):
        
        self._load_kwargs(kwargs)
        banner("Inside check_image_in_repo function")
        print("kwargs are: {}".format(kwargs))
        try:
            self.cmd = "docker images|grep -w {}".format(self.image_name)
            check_image_cmd = easy.cli_run(cmd=self.cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            
            serialised_check_image_cmd = self._serialize_response(time.time(), check_image_cmd)
            print("serialised_check_image_cmd is:{}".format(serialised_check_image_cmd))
            
            self.cmd_output = str(serialised_check_image_cmd['Result']['stdout']).replace('\n', '').strip()
            
            print("output of check image in local repo:{}".format(self.cmd_output))
            if self.image_name in self.cmd_output:
                return "OK"
            else:
                return "Error"
        except Exception as e:
            logger.console("Error in image check in local repo: " + str(e)) 
            
    ###############################################################################################################
    @keyword(name="Delete image from local repo, if exists")
    ###############################################################################################################
    
    # returns OK if Image is deleted from local repo, if already exists
    # <usage> delete_image_if_exists(image_name=<image_name>)
    
    def delete_image_if_exists(self,**kwargs):
        banner("Delete image from local repo, if exists")
        self._load_kwargs(kwargs)
        print("kwargs are: {}".format(kwargs))
        try:

            print("Image exists in repository ")
            self.cmd = "docker rmi {}".format(self.image_name)
            deleting_image_cmd = easy.cli_run(cmd=self.cmd, host_ip=self.hostip,linux_user=self.username, linux_password=self.password)
            
            serialised_deleting_image_cmd = self._serialize_response(time.time(), deleting_image_cmd)
            print("serialised_deleting_image_cmd is:{}".format(serialised_deleting_image_cmd))
            
            self.cmd_output = str(serialised_deleting_image_cmd['Result']['stdout']).replace('\n', '').strip()
            
            print("deleting_image_cmd executed successfully: {}".format(self.cmd_output))
            if ("Deleted" in self.cmd_output) or ("Untagged" in self.cmd_output):
                return "OK"
            else:
                return "Error"
        except Exception as e:
            logger.console("Error in delete image exists in local repo: " + str(e))

    ###############################################################################################################
    @keyword(name="Pull From Docker Registry")
    ###############################################################################################################
    
    # returns OK if Image is pulled from Docker Registry
    # <usage> pull_from_docker_registry(image_name=<image_name>)
    
    def pull_from_docker_registry(self, *args, **kwargs):
        self._load_kwargs(kwargs)        
        print("kwargs are: {}".format(kwargs))
        try:
            self.cmd = "docker pull {}".format(self.image_name)
            pull_command_execution = easy.cli_run(cmd=self.cmd,host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            
            serialised_pull_command_execution = self._serialize_response(time.time(), pull_command_execution)
            print("serialised_pull_command_execution is:{}".format(serialised_pull_command_execution))
            
            self.cmd_output = str(serialised_pull_command_execution['Result']['stdout']).replace('\n', '').strip()
            
            print("pull_image_cmd executed successfully: {}".format(self.cmd_output))
            if "Downloaded newer image for {}".format(self.image_name) in self.cmd_output:
                banner("Image downloaded from docker successfully")
                return "OK"
            else:
                return "Error"
        except Exception as e:
            logger.console("Error in pull from docker registry: " + str(e))
    
    ###############################################################################################################
    @keyword(name="Pull From Registry")
    ###############################################################################################################
            
    # returns OK if Image is pulled from Registry
    # <usage> pull_from_registry(image_name=<image_name>,registry_url=<registry_url>,registryPort=<registryPort>)
    
    def pull_from_registry(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        print("kwargs are: {}".format(kwargs))        
        try:
            self.cmd = "docker pull {}:{}/{}".format(self.registry_url,self.registryPort,self.image_name)
            time.sleep(5)
            pull_command_execution = easy.cli_run(cmd= self.cmd,host_ip=self.hostip, linux_user=self.username, linux_password = self.password)
            
            serialised_pull_command_execution = self._serialize_response(time.time(), pull_command_execution)
            print("serialised_pull_command_execution is:{}".format(serialised_pull_command_execution))
            
            self.cmd_output = str(serialised_pull_command_execution['Result']['stdout']).replace('\n', '').strip()
            
            print("pull_image_cmd with registry url_executed successfully: {}".format(self.cmd_output))
            if ("Downloaded newer image for {}:{}/{}:latest".format(self.registry_url,self.registryPort,self.image_name)) or ("Status: Image is up to date") in self.cmd_output:
                banner("Image pulled from Registry successfully")
                return "OK"
            else:
                return "Error"
                
        except Exception as e:
            logger.console("Error in pull from registry: " + str(e))
            
            
            
    ###################################################################################################################
    @keyword(name="Push To Registry")
    ###################################################################################################################
    
    # returns OK if Image is pushed To Registry
    # <usage> push_to_registry(custom_name=<custom_name>,registry_url=<registry_url>,port=<port>)
    
    def push_to_registry(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        print("kwargs are: {}".format(kwargs))
        try:
            self.cmd = "docker push {}:{}/{}".format(str(self.registry_url), str(self.port), str(self.custom_name))
            push_to_registry_cmd = easy.cli_run(cmd=self.cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            
            serialised_push_to_registry_cmd = self._serialize_response(time.time(), push_to_registry_cmd)
            print("serialised_push_to_registry_cmd is:{}".format(serialised_push_to_registry_cmd))
            
            self.cmd_output = str(serialised_push_to_registry_cmd['Result']['stdout']).replace('\n', '').strip()
            
            print("push_to_registry cmd executed successfully  : {}".format(self.cmd_output))
            if "Pushed" in self.cmd_output:
                return "OK"
            else:
                return "Error"

        except Exception as e:
            logger.console("Exception in push to registry : " +str(e))
            
            
    ###################################################################################################################
    @keyword(name="Tag Image")
    ###################################################################################################################
    
    # returns OK if Image is Tagged
    # <usage> tag_image(image_name=<image_name>,registry_url=<registry_url>,port=<port>,custom_name=<custom_name>)
    
    def tag_image(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        print("kwargs are: {}".format(kwargs))
        try:
            self.cmd = "docker tag {} {}:{}/{}".format(self.image_name, self.registry_url, str(self.port),self.custom_name)
            tag_cmd_execution = easy.cli_run(cmd=self.cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            grep_after_tag_execution = easy.cli_run(cmd="docker images|grep {}".format(self.image_name),host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            
            serialised_grep_after_tag_execution = self._serialize_response(time.time(), grep_after_tag_execution)
            print("serialised_grep_after_tag_execution is:{}".format(serialised_grep_after_tag_execution))
            
            self.cmd_output = str(serialised_grep_after_tag_execution['Result']['stdout']).replace('\n', '').strip()
            print("Tag image cmd executed successfully:{}".format(self.cmd_output))
            if "{}:{}/{}".format(self.registry_url, str(self.port), self.custom_name) in self.cmd_output:
                return "OK"
            else:
                return "Error"

        except Exception as e:
            logger.console("Error in tag image execution: " + str(e))
            
    ###############################################################################################################
    @keyword(name="PCC.CR login using docker")
    ###############################################################################################################
    
    # returns OK if CR login using docker is successful
    # <usage> CR_login(fullyQualifiedDomainName=<fullyQualifiedDomainName>,registryPort=<registryPort>,portus_password=<portus_password>,portus_uname=<portus_uname>)
    
    def CR_login(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        print("kwargs are: {}".format(kwargs))
        try:
            self.cmd = "docker login {}:{} --password='{}' --username='{}'".format(self.fullyQualifiedDomainName,self.registryPort,self.portus_password,self.portus_uname)
            CR_login_cmd_execution = easy.cli_run(cmd=self.cmd, host_ip=self.hostip, linux_user=self.username,linux_password=self.password)
            
            serialised_CR_login_cmd_execution = self._serialize_response(time.time(), CR_login_cmd_execution)
            print("serialised_CR_login_cmd_execution is:{}".format(serialised_CR_login_cmd_execution))
            
            self.cmd_output = str(serialised_CR_login_cmd_execution['Result']['stdout']).replace('\n', '').strip()
            
            print("CR_login using docker cmd executed successfully :{}".format(self.cmd_output))
            
            if "Login Succeeded" in self.cmd_output:
                return "OK"
            else:
                return "Error"
        except Exception as e:
            logger.console("Error in CR login using docker: " + str(e))
           
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
