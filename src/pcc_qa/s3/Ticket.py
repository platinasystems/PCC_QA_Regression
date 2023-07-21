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


class Ticket(S3ManagerBase):
    """
    Ticket
    """

    def __init__(self):
        self.id = None
        self.status = None  #new,assigned,closed
        self.object = None
        self.message = None
        self.priority = None #low,medium,high
        self.endpointId = None
        super().__init__()

    ###########################################################################
    @keyword(name="S3.Get Tickets")
    ###########################################################################
    def get_tickets(self):
        banner("S3.Get Tickets")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        return s3.get_tickets(conn)

    ###########################################################################
    @keyword(name="S3.Get Tickets Id By Object")
    ###########################################################################
    def get_tickets_id_by_obj(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Get Tickets Id By Object")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        tickets = get_response_data(s3.get_tickets(conn))
        for ticket in tickets:
            if ticket["object"] == self.object:
                return ticket["id"]
        return None

    ###########################################################################
    @keyword(name="S3.Create Ticket")
    ###########################################################################
    def create_ticket(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Create Ticket")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        payload = {}
        if self.endpointId:
            payload["endpointID"] = self.endpointId
        if self.object:
            payload["object"] = self.object
        if self.message:
            payload["message"] = self.message
        if self.priority:
            payload["priority"] = self.priority
        return s3.create_ticket(conn, payload)

    ###########################################################################
    @keyword(name="S3.Update Ticket")
    ###########################################################################
    def update_ticket(self, **kwargs):
        self._load_kwargs(kwargs)
        banner("S3.Update Ticket")
        conn = BuiltIn().get_variable_value("${S3_CONN}")
        payload = {
            "id": self.id
        }
        if self.endpointId:
            payload["endpointID"] = self.endpointId
        if self.object:
            payload["object"] = self.object
        if self.message:
            payload["message"] = self.message
        if self.priority:
            payload["priority"] = self.priority
        if self.status:
            payload["status"] = self.status
        return s3.update_ticket(conn, str(self.id), payload)
