import time
import requests
import urllib3
import json
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError
from aa.common.Utils import banner, trace, debug, pretty_print

class AaBase():
    """ 
    AaBase
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
            res = {
                # convert Json response.text to Python dict
                'Result': json.loads(response.text),
                'StatusCode': response.status_code,
                'ExecutionTime':"%.3f" % round(self._execution_time, 3)
                }
            debug("Status Code: %s" % res["StatusCode"])
            debug(res["Result"])
            return res
        except json.JSONDecodeError:
            try:
                res = {
                    'Result': None,
                    'StatusCode': response.status_code,
                    'ExecutionTime':"%.3f" % round(self._execution_time, 3)
                }
                debug("Status Code: %s" % res["StatusCode"])
                return res
            except Exception as e:
                trace("[RestBase._serialize_response] Exception: %s" % e)
                return {'Error': str(e)}

