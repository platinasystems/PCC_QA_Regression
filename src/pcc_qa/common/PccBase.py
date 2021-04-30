import time
import requests
import urllib3
import json
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError
from pcc_qa.common.Utils import banner, trace, debug, pretty_print

class PccBase():
    """ 
    PccBase
    """

    def __init__(self):

        self.api_url = None
        self.api_session = None
        self.api_token = None

        self.token = None
        self.session = None
        self.headers = None
        self._execution_time = None


    def _load_kwargs(self, kwargs):
        for item_name, item_value in kwargs.items():
            if hasattr(self, item_name):
                if item_value == 'None':
                    setattr(self, item_name, None)
                else:
                    setattr(self, item_name, item_value)
            else:
                # stop execution if keyword is not defined
                raise Exception("Keyword argument not defined: %s" % item_name)

    def _serialize_response(self, start_time, response):
        self._execution_time = time.time() - start_time
        if response is None:
            return {
                'Result':None, 
                'ExecutionTime':"%.3f" % round(self._execution_time, 3)
                }
        try:
            trace("Command successful")
            return {
                # return stdout
                'Result': {'stdout': response.stdout, 'stderr': response.stderr},
                'StatusCode': response.return_code,
                'ExecutionTime':"%.3f" % round(self._execution_time, 3)
                }
        except Exception as e:
            trace("Exception: %s" % e)
            return {'Error': str(e)}

