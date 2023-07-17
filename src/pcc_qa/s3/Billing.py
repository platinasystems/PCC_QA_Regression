import time
import re
import os
from datetime import datetime, timedelta
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError
from platina_sdk.s3 import s3_api as s3
from pcc_qa.common import PccUtility as easy
from pcc_qa.common.Utils import banner, trace, pretty_print
from pcc_qa.common.Result import get_response_data, get_result
from pcc_qa.common.S3ManagerBase import S3ManagerBase


class Billing(S3ManagerBase):
    """
    Dashboard
    """

    def __init__(self):
        self.organizationId = None
        self.endpointId = None
        super().__init__()

    ###########################################################################
    @keyword(name="S3.Get Organization Billings")
    ###########################################################################
    def get_organization_billing(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Get Organization Billings")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        return s3.get_billing_by_organization(conn, str(self.organizationId))

    ###########################################################################
    @keyword(name="S3.Get Endpoint Billings")
    ###########################################################################
    def get_endpoint_billing(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Get Endpoint Billings")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        return s3.get_billing_by_endpoint(conn, str(self.endpointId))
