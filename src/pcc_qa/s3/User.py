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


class User(S3ManagerBase):
    """
    User
    """

    def __init__(self):
        self.id = None
        self.username = None
        self.password = None
        self.firstName = None
        self.lastName = None
        self.email = None
        self.active = True
        self.roleID = None
        self.tenant = 1  #ROOT ORGANIZATION

        super().__init__()

    ###########################################################################
    @keyword(name="S3.Get Users")
    ###########################################################################
    def get_users(self):
        banner("S3.Get Users")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        return s3.get_users(conn)

    ###########################################################################
    @keyword(name="S3.Get User Id By Username")
    ###########################################################################
    def get_user_id_by_username(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Get Users Id By Username")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        users = s3.get_users(conn)["Result"]
        for usr in users:
            if usr["username"] == self.username:
                return usr["id"]
        return None

    ###########################################################################
    @keyword(name="S3.Create User")
    ###########################################################################
    def create_user(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Create User")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        payload = {"active": self.active,
                   "tenant": self.tenant}
        if self.username:
            payload["username"] = self.username
        if self.password:
            payload["password"] = self.password
        if self.firstName:
            payload["firstname"] = self.firstName
        if self.lastName:
            payload["lastname"] = self.lastName
        if self.email:
            payload["email"] = self.email
        if self.roleID:
            payload["roleID"] = self.roleID
        trace(payload)
        return s3.create_user(conn, payload)

    ###########################################################################
    @keyword(name="S3.Update User")
    ###########################################################################
    def update_user(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Update User")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        payload = {
            "id": self.id,
            "active": self.active,
            "tenant": self.tenant}
        if self.username:
            payload["username"] = self.username
        if self.password:
            payload["password"] = self.password
        if self.firstName:
            payload["firstname"] = self.firstName
        if self.lastName:
            payload["lastname"] = self.lastName
        if self.email:
            payload["email"] = self.email
        if self.roleID:
            payload["roleID"] = self.roleID
        trace(payload)
        return s3.update_user(conn, payload)

    ###########################################################################
    @keyword(name="S3.Delete User By Username")
    ###########################################################################
    def delete_user(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Delete User By Username")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        payload = {
            "username": self.username
        }
        return s3.delete_user(conn, payload)
