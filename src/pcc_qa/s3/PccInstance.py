import time
import re
import os
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError
from platina_sdk.s3 import s3_api as s3
from pcc_qa.common import PccUtility as easy
from pcc_qa.common.Utils import banner, trace, pretty_print
from pcc_qa.common.Result import get_response_data, get_result
from pcc_qa.common.S3ManagerBase import S3ManagerBase


class PccInstance(S3ManagerBase):
    """
    PccInstances
    """

    def __init__(self):
        self.id = None
        self.name = None
        self.username = None
        self.pwd = None
        self.address = None
        self.port = None
        super().__init__()

    ###########################################################################
    @keyword(name="S3.Get PCC Instances")
    ###########################################################################
    def get_pcc_instances(self):
        banner("S3.Get PCC Instances")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        return s3.get_pccs(conn)

    ###########################################################################
    @keyword(name="S3.Get PCC Instance Id By Name")
    ###########################################################################
    def get_pcc_instance_id_by_name(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Get PCC Instance Id By Name")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        pccs = get_response_data(s3.get_pccs(conn))
        for pcc in pccs:
            if pcc["name"] == self.name:
                return pcc["id"]
        return None

    ###########################################################################
    @keyword(name="S3.Create PCC Instance")
    ###########################################################################
    def create_pcc_instance(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Create PCC Instance")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        payload = {}
        if self.name:
            payload["name"] = self.name
        if self.username:
            payload["username"] = self.username
        if self.pwd:
            payload["pwd"] = self.pwd
        if self.address:
            payload["address"] = self.address
        if self.port:
            payload["port"] = self.port
        trace(payload)
        return s3.create_pcc(conn, payload)

    ###########################################################################
    @keyword(name="S3.Update PCC Instance")
    ###########################################################################
    def update_pcc_instance(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Update PCC Instance")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        payload = {}
        if self.name:
            payload["name"] = self.name
        if self.username:
            payload["username"] = self.username
        if self.pwd:
            payload["pwd"] = self.pwd
        if self.address:
            payload["address"] = self.address
        if self.port:
            payload["port"] = self.port
        trace(payload)
        return s3.update_pcc(conn, str(self.id), payload)

    ###########################################################################
    @keyword(name="S3.Delete PCC Instance")
    ###########################################################################
    def delete_pcc_instance(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Delete PCC Instance")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        return s3.delete_pcc(conn, str(self.id))

