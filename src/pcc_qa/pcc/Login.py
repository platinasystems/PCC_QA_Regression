import sys
import time
import requests
import urllib3
import json
import distro
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from pcc_qa.common.Utils import banner, trace, pretty_print
from pcc_qa.common.PccBase import PccBase
from pcc_qa.common.Login import login
class Login(PccBase):
    """ 
    Login
    """
    def __init__(self):
        ### Following must be defined in order for Robot Arguments to be valid ###
        self.url = None
        self.username = None
        self.password = None

    ###########################################################################
    @keyword(name="PCC.Login")
    ###########################################################################
    def login(self, **kwargs):
        self._load_kwargs(kwargs)
        print("Kwargs:-"+str(kwargs))
        banner("PCC.Login")
        var=login(self.url, self.username, self.password)
        print(var)
        return var
