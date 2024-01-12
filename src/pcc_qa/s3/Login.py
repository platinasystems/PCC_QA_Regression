import sys
import time
import requests
import urllib3
import json
import distro
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from pcc_qa.common.Utils import banner, trace, pretty_print
from pcc_qa.common.S3ManagerBase import S3ManagerBase
from pcc_qa.common.Login import login



class Login(S3ManagerBase):
    """
    Login
    """
    def __init__(self):
        ### Following must be defined in order for Robot Arguments to be valid ###
        self.url = None
        self.username = None
        self.password = None

    ###########################################################################
    @keyword(name="S3.Login")
    ###########################################################################
    def login(self, **kwargs):
        self._load_kwargs(kwargs)
        print("Kwargs:-"+str(kwargs))
        banner("S3.Login")
        trace(self.url)
        var = login(self.url, self.username, self.password)
        if var["status_code"] != 200:
            return {"StatusCode": var["status_code"]}
        return var
