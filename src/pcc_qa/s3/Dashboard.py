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


class Dashboard(S3ManagerBase):
    """
    Dashboard
    """

    def __init__(self):
        self.organizationId = None
        self.endpointId = None
        self.stat_name = None
        self.rgwId = None
        super().__init__()

    ###########################################################################
    @keyword(name="S3.Get Organization Statistics")
    ###########################################################################
    def get_organization_stats(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Get Organization Statistics")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        return s3.get_stats_by_organization(conn, str(self.organizationId))

    ###########################################################################
    @keyword(name="S3.Get Endpoint Statistics")
    ###########################################################################
    def get_endpoint_stats(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Get Endpoint Statistics")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        return s3.get_stats_by_endpoint(conn, str(self.endpointId))

    ###########################################################################
    @keyword(name="S3.Get Endpoint Prometheus Statistics")
    ###########################################################################
    def get_endpoint_prom_stats(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Get Endpoint Prometheus Statistics")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        start_time = (datetime.utcnow() - timedelta(hours=24)).isoformat()[:-3] + 'Z'  # Start time -> Current time - 24 Hr
        end_time = datetime.utcnow().isoformat()[:-3] + 'Z'  # End time -> Current time
        payload = {}
        if self.stat_name == "radosgw_usage_total_objects":
            payload["query"] = "{{job='ceph-rgw-metrics',__name__='radosgw_usage_total_objects',rgwID='{}'}}&start={}&end={}&step=3000s".format(self.rgwId, start_time, end_time)
        return s3.get_prometheus_stats_by_endpoint(conn, str(self.endpointId), payload)

