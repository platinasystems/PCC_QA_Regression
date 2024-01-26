import sys
import time
import pyotp
import requests
import urllib3
import json
import distro
from platina_sdk import pcc_api as pcc
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from pcc_qa.common.Utils import banner, trace, pretty_print
from pcc_qa.common.PccBase import PccBase
from pcc_qa.common.Login import login
from pcc_qa.common.Result import get_result, get_status_code

class Login(PccBase):
    """ 
    Login
    """
    def __init__(self):
        ### Following must be defined in order for Robot Arguments to be valid ###
        self.url = None
        self.username = None
        self.password = None
        self.otp = None
        self.seed = None

    ###########################################################################
    @keyword(name="PCC.Login")
    ###########################################################################
    def login(self, **kwargs):
        self._load_kwargs(kwargs)
        print("Kwargs:-"+str(kwargs))
        banner("PCC.Login")
        var = login(self.url, self.username, self.password, self.otp)
        print(var)
        return var

    ###########################################################################
    @keyword(name="PCC.Enable MF Authentication")
    ###########################################################################
    def enable_mfa(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Enable MF Authentication")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            resp = pcc.enable_mfa(conn, {})
            data = get_result(resp)
            status_code = get_status_code(resp)
            if status_code == 200:
                trace(data)
                self.seed = data["secret"]
                trace(self.seed)
                totp = pyotp.TOTP(self.seed)
                resp = pcc.enable_mfa(conn, {"otp": totp.now()})
                status_code = get_status_code(resp)
                if status_code == 200:
                    return self.seed
            return None
        except Exception as e:
            raise e


    ###########################################################################
    @keyword(name="PCC.Disable MF Authentication")
    ###########################################################################
    def disable_mfa(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Disable MF Authentication")

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            resp = pcc.disable_mfa(conn, {"otp": self.otp})
            status_code = get_status_code(resp)
            if status_code == 200:
                return "OK"
            return "Error"
        except Exception as e:
            raise e

    ###########################################################################
    @keyword(name="PCC.Start Reset MF Authentication")
    ###########################################################################
    def start_disable_mfa(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Start Reset MF Authentication")
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            payload = {"username": self.username, "source": self.url + "/user-management/user/mfa/reset"}
            resp = pcc.reset_mfa(conn, payload)
            status_code = get_status_code(resp)
            if status_code == 200:
                return "OK"
            return "Error"
        except Exception as e:
            raise e

    ###########################################################################
    @keyword(name="PCC.End Reset MF Authentication")
    ###########################################################################
    def end_disable_mfa(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.End Reset MF Authentication")
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            payload = {"username": self.username, "otp": self.otp}
            resp = pcc.reset_mfa(conn, payload)
            status_code = get_status_code(resp)
            if status_code == 200:
                return "OK"
            return "Error"
        except Exception as e:
            raise e

    ###########################################################################
    @keyword(name="PCC.Generate OTP")
    ###########################################################################
    def generate_otp(self, *args, **kwargs):
        self._load_kwargs(kwargs)
        banner("PCC.Generate OTP")
        totp = pyotp.TOTP(self.seed)
        return totp.now()


