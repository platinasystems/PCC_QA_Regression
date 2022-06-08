import imaplib
import email
import time
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError

from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy

from pcc_qa.common.Utils import banner, trace, pretty_print
from pcc_qa.common.Result import get_response_data, get_result
from pcc_qa.common.PccBase import PccBase

class Gmail(PccBase):
    """
    Gmail
    """

    def __init__(self):
        self.Email = None
        self.Password = None
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Get Link From Gmail")
    ###########################################################################
    def get_link_from_gmail(self, *args, **kwargs):

        self._load_kwargs(kwargs)
        print("Kwargs are:{}".format(kwargs))
        banner("PCC.Add User [email=%s]" % self.Email)

        mail = imaplib.IMAP4_SSL('imap.gmail.com')
        #mail.login('calsoftplatina@gmail.com', 'plat1n@!')
        mail.login(self.Email, self.Password)
        mail.list()
        # Out: list of "folders" aka labels in gmail.
        mail.select("inbox")  # connect to inbox.

        result, data = mail.search(None, '(from "pcc_notifications@platinasystems.com")')
        ids = data[0]  # data is a list.
        id_list = ids.split()  # ids is a space separated string
        latest_email_id = id_list[-1]  # get the latest

        result, data = mail.fetch(latest_email_id, "(RFC822)")  # fetch the email body (RFC822) for the given ID

        raw_email = data[0][1]  # here's the body, which is raw text of the whole email
        # including headers and alternate payloads
        raw_email = str(raw_email)
        raw_email = raw_email.split(str(chr(34)))

        print(raw_email)

        for line in raw_email[::-1]:
            if line.startswith('https:'):
                print(line)
                token = line.split('token=')[-1]
                print(token)
                return token

    ###########################################################################
    @keyword(name="PCC.Get Body From Last Mail")
    ###########################################################################
    def get_body_from_last_mail(self, *args, **kwargs):

        self._load_kwargs(kwargs)
        print("Kwargs are:{}".format(kwargs))
        banner("PCC.Get Body From Last Mail")

        mail = imaplib.IMAP4_SSL('imap.gmail.com')
        # mail.login('calsoftplatina@gmail.com', 'plat1n@!')
        mail.login(self.Email, self.Password)
        mail.list()
        # Out: list of "folders" aka labels in gmail.
        mail.select("inbox")  # connect to inbox.

        result, data = mail.search(None, '(from "pcc_notifications@platinasystems.com")')
        ids = data[0]  # data is a list.
        id_list = ids.split()  # ids is a space separated string
        latest_email_id = id_list[-1]  # get the latest

        result, data = mail.fetch(latest_email_id, "(RFC822)")  # fetch the email body (RFC822) for the given ID

        raw_email = data[0][1]  # here's the body, which is raw text of the whole email
        # including headers and alternate payloads
        raw_email = str(raw_email)
        return raw_email

