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


class Organization(S3ManagerBase):
    """
    Organization
    """

    def __init__(self):
        self.id = None
        self.name = None
        self.description = None
        self.reservedCapacityTB = 0
        self.priceUsageGB = 0.015
        self.priceTrafficGB = 0.00015
        self.priceOps = 0.0000015
        self.username = None
        self.password = None
        self.firstName = None
        self.lastName = None
        self.email = None
        self.active = True

        super().__init__()

    ###########################################################################
    @keyword(name="S3.Get Organizations")
    ###########################################################################
    def get_organizations(self):
        banner("S3.Get Organizations")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        return s3.get_organizations(conn)

    ###########################################################################
    @keyword(name="S3.Get Organization Id By Name")
    ###########################################################################
    def get_organization_id_by_name(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Get Organization Id By Name")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        orgs = get_response_data(s3.get_organizations(conn))
        for org in orgs:
            if org["name"] == self.name:
                return org["id"]
        return None

    ###########################################################################
    @keyword(name="S3.Create Organization")
    ###########################################################################
    def create_organization(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Create Organization")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        payload = {
            "reservedCapacityTB": self.reservedCapacityTB,
            "priceUsageGB": self.priceUsageGB,
            "priceTrafficGB": self.priceTrafficGB,
            "priceOps": self.priceOps,
            "active": self.active
        }
        if self.name:
            payload["name"] = self.name
        if self.description:
            payload["description"] = self.description
        if self.username:
            payload["username"] = self.username
        if self.email:
            payload["email"] = self.email
        if self.password:
            payload["password"] = self.password
        if self.firstName:
            payload["firstName"] = self.firstName
        if self.lastName:
            payload["lastName"] = self.lastName
        trace(payload)
        return s3.create_organization(conn, payload)

    ###########################################################################
    @keyword(name="S3.Update Organization")
    ###########################################################################
    def update_organization(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Update Organization")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        payload = {
            "id": self.id,
            "reservedCapacityTB": self.reservedCapacityTB,
            "priceUsageGB": self.priceUsageGB,
            "priceTrafficGB": self.priceTrafficGB,
            "priceOps": self.priceOps,
        }
        if self.name:
            payload["name"] = self.name
        if self.description:
            payload["description"] = self.description
        trace(payload)
        return s3.update_organization(conn, str(self.id), payload)

    ###########################################################################
    @keyword(name="S3.Delete Organization")
    ###########################################################################
    def delete_organization(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Delete Organization")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        return s3.delete_organization(conn, str(self.id))
