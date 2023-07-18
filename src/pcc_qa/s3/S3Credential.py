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


TIMEOUT = 60 * 5

class S3Credential(S3ManagerBase):
    """
    S3Credential
    """

    def __init__(self):
        self.id = None
        self.endpointId = None
        self.name = None
        self.description = None
        self.active = True
        self.readPermission = True
        self.writePermission = True
        self.deletePermission = True
        self.maxBuckets = 1000
        self.maxBucketObjects = -1
        self.maxBucketSize = -1
        self.maxBucketSizeUnit = "MiB"
        self.maxUserSize = -1
        self.maxUserSizeUnit = "MiB"
        self.maxUserObjects = -1
        super().__init__()

    ###########################################################################
    @keyword(name="S3.Get S3 Credentials")
    ###########################################################################
    def get_s3_credentials(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Get S3 Credentials")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        return s3.get_s3credentials_by_endpoint(conn, str(self.endpointId))

    ###########################################################################
    @keyword(name="S3.Get S3 Credential Id By Name")
    ###########################################################################
    def get_s3_credential_id_by_name(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Get S3 Credential Id By Name")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        credentials = get_response_data(s3.get_s3credentials_by_endpoint(conn, str(self.endpointId)))
        for cred in credentials:
            if cred["name"] == self.name:
                return cred["id"]
        return None

    ###########################################################################
    @keyword(name="S3.Create S3 Credential")
    ###########################################################################
    def create_s3_credential(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Create S3 Credential")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        payload = {
            "name": self.name,
            "description": self.description,
            "active": self.active,
            "profile": {
                "readPermission": self.readPermission,
                "writePermission": self.writePermission,
                "deletePermission": self.deletePermission,
                "maxBuckets": self.maxBuckets,
                "maxBucketObjects": self.maxBucketObjects,
                "maxBucketSize": self.maxBucketSize,
                "maxBucketSizeUnit": self.maxBucketSizeUnit,
                "maxUserSize": self.maxUserSize,
                "maxUserSizeUnit": self.maxUserSizeUnit,
                "maxUserObjects": self.maxUserObjects
            }
        }
        return s3.create_s3credentials_by_endpoint(conn, str(self.endpointId), payload)

    ###########################################################################
    @keyword(name="S3.Update S3 Credential")
    ###########################################################################
    def update_s3_credential(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Update S3 Credential")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        payload = {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "active": self.active,
            "profile": {
                "readPermission": self.readPermission,
                "writePermission": self.writePermission,
                "deletePermission": self.deletePermission,
                "maxBuckets": self.maxBuckets,
                "maxBucketObjects": self.maxBucketObjects,
                "maxBucketSize": self.maxBucketSize,
                "maxBucketSizeUnit": self.maxBucketSizeUnit,
                "maxUserSize": self.maxUserSize,
                "maxUserSizeUnit": self.maxUserSizeUnit,
                "maxUserObjects": self.maxUserObjects
            }
        }
        return s3.update_s3credentials_by_endpoint(conn, str(self.endpointId), str(self.id), payload)

    ###########################################################################
    @keyword(name="S3.Delete S3 Credential")
    ###########################################################################
    def delete_s3_credential(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Delete S3 Credential")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        return s3.delete_s3credentials_by_endpoint(conn, str(self.endpointId), str(self.id))

    ###########################################################################
    @keyword(name="S3.Wait Until Credential Ready")
    ###########################################################################
    def wait_until_credential_ready(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Wait Until Credential Ready")
        conn = BuiltIn().get_variable_value("${S3_CONN}")

        timeout = time.time() + TIMEOUT
        while True:
            credentials = get_response_data(s3.get_s3credentials_by_endpoint(conn, str(self.endpointId)))
            for credential in credentials:
                if credential["name"] == self.name:
                    trace("Waiting until %s is Ready, current status: %s" % (credential['name'], credential['deployStatus']))
                    if credential['deployStatus'] == 'completed':
                        return 'OK'
                    elif credential['deployStatus'] == 'failed':
                        return 'Error'
                    break
            if time.time() > timeout:
                trace('Waiting until Endpoint Ready Timeout')
                return 'Error'
            time.sleep(5)

    ###########################################################################
    @keyword(name="S3.Wait Until Credential Deleted")
    ###########################################################################
    def wait_until_credential_deleted(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Wait Until Credential Deleted")
        conn = BuiltIn().get_variable_value("${S3_CONN}")

        timeout = time.time() + TIMEOUT

        while True:
            found = False
            credentials = get_response_data(s3.get_s3credentials_by_endpoint(conn, str(self.endpointId)))
            for credential in credentials:
                if credential["name"] == self.name:
                    trace("Waiting until %s is Deleted, current status: %s" % (credential['name'], credential['deployStatus']))
                    found = True
                    if credential['deployStatus'] == 'failed':
                        return 'Error'
            if not found:
                return "OK"
            if time.time() > timeout:
                trace('Waiting until Endpoint Ready Timeout')
                return 'Error'
            time.sleep(5)
