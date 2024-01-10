
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError
from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy
from pcc_qa.common.Utils import banner, trace, pretty_print
from pcc_qa.common.Result import get_response_data, get_result
from pcc_qa.common.PccBase import PccBase


class Baremetal(PccBase):
    """
    Baremetal
    """

    def __init__(self):
        self.Node = ""
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Verify Baremetal Provisioner Role")
    ###########################################################################
    def verify_baremetal_provisioner_role(self, *args, **kwargs):
        banner("PCC.Verify Baremetal Provisioner Role")
        self._load_kwargs(kwargs)

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            node_id = easy.get_node_id_by_name(conn, self.Node)
            trace("node id is : {}".format(node_id))
            response = pcc.get_node_audit_status(conn, str(node_id))
            container_names = ["compose-boots", "compose-hegel", "compose-tink-cli", "compose-tink-server", "compose-web-assets-server", "compose-registry", "compose-db"]
            for apps in response["Result"]["Data"]:
                if apps["AppName"] == "bare-metal":
                    if not apps["OK"]:
                        return "Error"
                    containers = apps["MetaData"]["Detail"]["Containers"].replace(" ", "")
                    trace("containers: {}".format(containers))
                    for c in container_names:
                        if f"{c}-1Up" not in containers:
                            trace(f"{c} not present/Up")
                            return "Error"
            return "OK"
        except Exception as e:
            raise e

    ###########################################################################
    @keyword(name="PCC.Verify Bootstrap Services Role")
    ###########################################################################
    def verify_boostrap_services_role(self, *args, **kwargs):
        banner("PCC.Verify Bootstrap Services Role")
        self._load_kwargs(kwargs)

        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            node_id = easy.get_node_id_by_name(conn, self.Node)
            trace("node id is : {}".format(node_id))
            response = pcc.get_node_audit_status(conn, str(node_id))

            for apps in response["Result"]["Data"]:
                if apps["AppName"] == "dnsmasq":
                    if not apps["OK"]:
                        return "Error"
                    dnsmasq_state = apps["MetaData"]["DnsmasqState"]
                    if dnsmasq_state != "active":
                        return "Error"
            return "OK"
        except Exception as e:
            raise e
