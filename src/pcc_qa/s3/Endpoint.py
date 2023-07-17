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


class Endpoint(S3ManagerBase):
    """
    Endpoint
    """

    def __init__(self):
        self.id = None
        self.pccId = None
        self.name = None
        self.description = None
        self.rgwID = None
        self.customers = [1]  #ROOT ORG
        self.poolQuota = "1"
        self.poolQuotaUnit = "TiB"
        self.poolDataChunks = 0
        self.poolCodingChunks = 0
        self.poolStripeUnit = 4096
        self.nodeID = None
        self.clusterID = None
        self.clusterName = None
        self.certificateID = None
        self.numDaemonsMap = {}

        super().__init__()

    ###########################################################################
    @keyword(name="S3.Get Endpoints")
    ###########################################################################
    def get_endpoints(self):
        banner("S3.Get Endpoints")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        return s3.get_endpoints(conn)

    ###########################################################################
    @keyword(name="S3.Get Attachable Endpoints")
    ###########################################################################
    def get_attachable_endpoints(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Get Attachable Endpoints")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        return s3.get_attachable_endpoints(conn, str(self.pccId))

    ###########################################################################
    @keyword(name="S3.Get Endpoint Id By Name")
    ###########################################################################
    def get_endpoint_id_by_name(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Get Endpoint Id By Name")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        endpoints = get_response_data(s3.get_endpoints(conn))
        for endpoint in endpoints:
            if endpoint["name"] == self.name:
                return endpoint["id"]
        return None

    ###########################################################################
    @keyword(name="S3.Get Attachable Endpoint Id By Name")
    ###########################################################################
    def get_attachable_endpoint_id_by_name(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Get Attachable Endpoint Id By Name")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        endpoints = get_response_data(s3.get_attachable_endpoints(conn, str(self.pccId)))
        for endpoint in endpoints:
            if endpoint["name"] == self.name:
                return endpoint["ID"]
        return None

    ###########################################################################
    @keyword(name="S3.Get PCC Certificates")
    ###########################################################################
    def get_pcc_certificates(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Get PCC Certificates")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        return s3.get_certificates_by_pcc(conn, str(self.pccId))

    ###########################################################################
    @keyword(name="S3.Get PCC Ceph Clusters")
    ###########################################################################
    def get_pcc_ceph_clusters(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Get PCC Clusters")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        return s3.get_ceph_clusters_by_pcc(conn, str(self.pccId))

    ###########################################################################
    @keyword(name="S3.Get PCC Ceph Cluster Id By Name")
    ###########################################################################
    def get_pcc_ceph_cluster_id_by_name(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Get PCC Ceph Cluster Id By Name")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        clusters = get_response_data(s3.get_ceph_clusters_by_pcc(conn, str(self.pccId)))
        for cluster in clusters:
            if cluster["name"] == self.clusterName:
                return cluster["id"]
        return None

    ###########################################################################
    @keyword(name="S3.Get PCC CephLB Nodes")
    ###########################################################################
    def get_pcc_cephlb_nodes(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Get PCC CephLB Nodes")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        return s3.get_lbnodes_by_pcc(conn, str(self.pccId))

    ###########################################################################
    @keyword(name="S3.Get PCC RGW Available Nodes")
    ###########################################################################
    def get_pcc_rgw_nodes(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Get PCC RGW Available Nodes")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        return s3.get_rgwnodes_by_cluster(conn, str(self.pccId), str(self.clusterID))

    ###########################################################################
    @keyword(name="S3.Create Endpoint")
    ###########################################################################
    def create_endpoint(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Create Endpoint")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        payload = {
            "name": self.name,
            "description": self.description,
            "customers": self.customers,
            "rgw": {
                "certificateID": self.certificateID,
                "numDaemonsMap": self.numDaemonsMap
            },
            "pool": {
                "erasureCodeProfile": {
                    "dataChunks": self.poolDataChunks,
                    "codingChunks": self.poolCodingChunks,
                    "stripeUnit": self.poolStripeUnit
                }
            },
            "lb": {
                "nodeId": self.nodeID
            }
        }
        return s3.create_endpoint(conn, str(self.pccId), str(self.clusterID), payload)

    ###########################################################################
    @keyword(name="S3.Attach Endpoint")
    ###########################################################################
    def attach_endpoint(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Attach Endpoint")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        payload = {
            "name": self.name,
            "description": self.description,
            "rgwID": self.rgwID,
            "customers": self.customers
        }
        return s3.attach_endpoint(conn, str(self.pccId), payload)

    ###########################################################################
    @keyword(name="S3.Update Endpoint")
    ###########################################################################
    def update_endpoint(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Update Endpoint")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        payload = {
            "name": self.name,
            "description": self.description,
            "customers": self.customers,
            "pool": {
                "quota": self.poolQuota,
                "quota_unit": self.poolQuotaUnit
            }
        }
        return s3.update_endpoint(conn, str(self.id), payload)

    ###########################################################################
    @keyword(name="S3.Delete Endpoint")
    ###########################################################################
    def delete_endpoint(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Delete Endpoint")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        return s3.delete_endpoint(conn, str(self.id))
