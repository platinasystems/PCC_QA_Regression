import json
import time
import re

from pcc_qa.common.PccBase import PccBase
from robot.api.deco import keyword
from pcc_qa.common.Utils import banner, trace
from robot.libraries.BuiltIn import BuiltIn
from platina_sdk import pcc_api as pcc

PCCSERVER_TIMEOUT = 60*8
TRUST_CAUGHT_UP_MSG = "syncing (caught up)"


class CephMultisite(PccBase):

    """
    Ceph Trust
    """

    def __init__(self):

        # Robot arguments definitions
        self.id = None
        self.status = ""
        self.deployStatus = ""
        self.progressPercentage = None
        self.remoteID = None
        self.trustFileLink = ""
        self.appType = "rgw"
        self.masterAppID = None
        self.masterAppID = ""
        self.side = ""
        self.slaveAppID = None
        self.slaveParams = None
        self.clusterID = None
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Ceph Primary Start Trust")
    ###########################################################################
    def primary_start_trust(self, *args, **kwargs):
        banner("PCC.Ceph Primary Start Trust")
        self._load_kwargs(kwargs)

        payload = {
            "side": "master",
            "masterAppID": self.masterAppID,
            "appType": self.appType
        }

        trace(payload)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.start_trust_creation(conn, payload)

    ###########################################################################
    @keyword(name="PCC.Ceph Secondary Start Trust")
    ###########################################################################
    def secondary_start_trust(self, *args, **kwargs):
        banner("PCC.Ceph Secondary Start Trust")
        self._load_kwargs(kwargs)

        payload = {
            "side": "slave",
            "appType": self.appType,
            "slaveParams": {"clusterID": self.clusterID, "targetNodes": []}
        }

        trace(payload)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.start_trust_creation(conn, payload)

    ###########################################################################
    @keyword(name="PCC.Ceph Download Trust File")
    ###########################################################################
    def download_trust_file(self, *args, **kwargs):
        banner("PCC.Ceph Download Trust File")
        self._load_kwargs(kwargs)

        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        response = pcc.get_trust_file(conn, str(self.id))
        file_name = "trust-{}.json".format(self.id)
        with open(file_name, "w") as trust_file:
            json.dump(response["Result"], trust_file)
        return response["StatusCode"]

    ###########################################################################
    @keyword(name="PCC.Ceph Secondary End Trust")
    ###########################################################################
    def secondary_end_trust(self, *args, **kwargs):
        banner("PCC.Ceph Secondary End Trust")
        self._load_kwargs(kwargs)

        file_name = "trust-{}.json".format(self.id)
        slave_params = {"clusterID" : self.clusterID, "targetNodes":[]}
        multipart_data = {"trustFile": open(file_name, 'rb'),
                          "side": (None, "slave"),
                          "appType": (None, self.appType),
                          "slaveParams": (None, json.dumps(slave_params))
                          }

        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.end_trust_creation(conn, multipart_data)

    ###########################################################################
    @keyword(name="PCC.Ceph Primary End Trust")
    ###########################################################################
    def primary_end_trust(self, *args, **kwargs):
        banner("PCC.Ceph Primary End Trust")
        self._load_kwargs(kwargs)

        file_name = "trust-{}.json".format(self.id)
        multipart_data = {"trustFile": open(file_name, 'rb'),
                          "side": (None, "master"),
                          "appType": (None, self.appType),
                          "masterAppID": (None, self.masterAppID)
                          }

        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.end_trust_creation(conn, multipart_data)

    ###########################################################################
    @keyword(name="PCC.Ceph Edit Trust")
    ###########################################################################
    def edit_trust(self, *args, **kwargs):
        banner("PCC.Ceph Edit Trust")
        self._load_kwargs(kwargs)

        payload = {
            "id": self.id,
            "slaveAppID": self.slaveAppID,
            "slaveParams": {"targetNodes": []}
        }

        trace(payload)
        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.select_trust_target(conn, str(self.id), payload)

    ###########################################################################
    @keyword(name="PCC.Ceph Wait Until Trust Established")
    ###########################################################################
    def wait_until_trust_established(self, *args, **kwargs):
        banner("PCC.Ceph Wait Until Trust Established")
        self._load_kwargs(kwargs)
        print("Kwargs"+str(kwargs))

        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        timeout = time.time() + PCCSERVER_TIMEOUT
        while True:
            response = pcc.get_trust_by_id(conn, str(self.id))
            data = response["Result"]["Data"]
            trace("Response To Look :-"+str(response))
            trace("Progress: {}%, current deploy status: {}".format(data.get("progressPercentage"), data.get("deploy_status")))
            if data.get('deploy_status') == "completed":
                return "OK"
            elif re.search("failed", str(data.get('deploy_status'))):
                return "Error"
            else:
                if time.time() > timeout:
                    return "Timeout Error"
            time.sleep(10)

    ###########################################################################
    @keyword(name="PCC.Ceph Wait Until Replica Status Caught Up")
    ###########################################################################
    def wait_until_trust_caught_up(self, *args, **kwargs):
        banner("PCC.Ceph Wait Until Replica Status Caught Up")
        self._load_kwargs(kwargs)
        print("Kwargs"+str(kwargs))

        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        timeout = time.time() + PCCSERVER_TIMEOUT
        while True:
            response = pcc.get_trust_by_id(conn, str(self.id))
            data = response["Result"]["Data"]
            app_status = data["appStatus"]
            trace("AppStatus: {}".format(app_status))
            if app_status.get("data") == TRUST_CAUGHT_UP_MSG and app_status.get("meta") == TRUST_CAUGHT_UP_MSG:
                return "OK"
            else:
                if time.time() > timeout:
                    return "Timeout Error"
            time.sleep(10)


    ###########################################################################
    @keyword(name="PCC.Ceph Trust Delete")
    ###########################################################################
    def delete_trust_by_id(self, *args, **kwargs):
        banner("PCC.Ceph Trust Delete")
        self._load_kwargs(kwargs)

        conn = BuiltIn().get_variable_value("${PCC_CONN}")
        return pcc.delete_trust_by_id(conn, str(self.id))

    ###########################################################################
    @keyword(name="PCC.Ceph Wait Until Trust Deleted")
    ###########################################################################
    def wait_until_trust_delete(self, *args, **kwargs):
        banner("PCC.Ceph Wait Until Trust Deleted")
        self._load_kwargs(kwargs)
        print("Kwargs"+str(kwargs))

        conn = BuiltIn().get_variable_value("${PCC_CONN}")

        timeout = time.time() + PCCSERVER_TIMEOUT
        found = True
        while found:
            response = pcc.get_trusts(conn)
            data = response["Result"]["Data"]
            trace("Response To Look :-"+str(data))
            if not data:
                return "OK"
            found = False
            for trust in data:
                if trust["id"] == self.id:
                    found = True
                else:
                    if time.time() > timeout:
                        return "Timeout Error"
            time.sleep(10)
        return "OK"

