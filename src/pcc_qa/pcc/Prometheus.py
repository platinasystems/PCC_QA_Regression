import re
import time
import json

from datetime import datetime, timedelta
from pprint import pformat
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
from robot.libraries.BuiltIn import RobotNotRunningError
from robot.api import logger

from platina_sdk import pcc_api as pcc
from pcc_qa.common import PccUtility as easy

from pcc_qa.common.Utils import banner, trace, pretty_print, cmp_json
from pcc_qa.common.Result import get_response_data
from pcc_qa.common.PccBase import PccBase
from pcc_qa.common.Cli import cli_run

PCCSERVER_TIMEOUT = 60*10
START_TIME = (datetime.now() - timedelta(hours = 1)).isoformat()[:-3]+'Z'   #Start time -> Current time - 1 Hr
END_TIME = datetime.utcnow().isoformat()[:-3]+'Z'   #End time -> Current time
STEP = 60   #Step refers to interval in seconds

class Prometheus(PccBase):

    """ 
    Prometheus metrics
    """

    def __init__(self):

        # Robot arguments definitions
        self.nodes=[]
        self.pcc_prometheus_objects=[]
        super().__init__()

    ###########################################################################
    @keyword(name="PCC.Prometheus Ceph Health Metrics")
    ###########################################################################
    def check_ceph_health_metrics(self, **kwargs):
        self._load_kwargs(kwargs)
        print("Kwargs:"+str(kwargs)) #TODO:Remove
        if 'job_list' not in kwargs:
            job_list = ['ceph-metrics', 'ceph-rgw']
        else:
            job_list = kwargs['job_list']

        banner("PCC.Prometheus Ceph Health Metrics")
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            print("conn is {}".format(conn))
        except Exception as e:
            raise e

        flag = 'OK'
        try:                      
            for each_job in job_list:
                banner(f"Topic:Ceph health metrics:{each_job}")
                payload = {
                        "query": f"healthLevel{{job='{each_job}'}}&start={START_TIME}&end={END_TIME}&step={STEP}"
                    }
                data=get_response_data(pcc.query_range_metric(conn, payload))
                if each_job in data[0]['metric'].values():
                    logger.console(f"Successfully retrieved ceph-metrics for cluster:{data[0]['metric']['job']}, {pformat(data[0])}")                   
                else:
                    logger.warn(f'Failed retrieving ceph health metrics for job:{each_job}')   
                    flag = "FAIL"
            return flag 
        except Exception as err:
            logger.console(f'Retrieving ceph health metrics failed with error')
            raise err

    ###########################################################################
    @keyword(name="PCC.Prometheus Interface Carrier Metrics")
    ###########################################################################
    def check_interface_carrier_metrics(self):
        banner("PCC.Prometheus Interface Carrier Metrics")
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            print("conn is {}".format(conn))
        except Exception as e:
            raise e
        flag = 'OK'
        try:    
            payload = {
                        "query": f"carrier_status&start={START_TIME}&end={END_TIME}&step={STEP}"
                    }
            data=get_response_data(pcc.query_metric(conn, payload))
            if data:
                logger.console(f"Successfully retrieved interface carrier metrics:{pformat(data)}")
            else:
                logger.warn(f"Failed to retrieve interface carrier metrics") 
                flag = 'ERROR'
            return flag
        except Exception as err:
            logger.warn(f"Failed retrieving interface carrier metrics with an error")
            raise err


    ###########################################################################
    @keyword(name="PCC.Prometheus Admin Carrier Metrics")
    ###########################################################################
    def check_admin_carrier_metrics(self):
        banner("PCC.Prometheus Admin Carrier Metrics")
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            print("conn is {}".format(conn))
        except Exception as e:
            raise e
        flag = 'OK'
        try:    
            payload = {
                        "query": f"admin_desired_up_carrier_down&start={START_TIME}&end={END_TIME}&step={STEP}"
                    }
            data=get_response_data(pcc.query_metric(conn, payload))
            if data:
                logger.console(f"Successfully retrieved admin carrier metrics: {pformat(data)}")
            else:
                logger.warn(f"Failed to retrieve admin carrier metrics") 
                flag = 'ERROR'
            return flag
        except Exception as err:
            logger.warn(f"Failed retrieving admin carrier metrics with an error")
            raise err

    ###########################################################################
    @keyword(name="PCC.Prometheus Admin Status Metrics")
    ###########################################################################
    def check_admin_status_metrics(self):
        banner("PCC.Prometheus Admin Status Metrics")
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            print("conn is {}".format(conn))
        except Exception as e:
            raise e
        flag = 'OK'
        try:    
            payload = {
                        "query": f"admin_status_desired&start={START_TIME}&end={END_TIME}&step={STEP}"
                    }
            data=get_response_data(pcc.query_metric(conn, payload))
            if data:
                logger.console(f"Successfully retrieved admin status metrics: {pformat(data)}")
            else:
                logger.warn(f"Failed to retrieve admin status metrics") 
                flag = 'ERROR'
            return flag
        except Exception as err:
            logger.warn(f"Failed retrieving admin status metrics with an error")
            raise err


    ###########################################################################
    @keyword(name="PCC.Prometheus Connection Status Metrics")
    ###########################################################################
    def check_connection_status_metrics(self):
        banner("PCC.Prometheus Connection Status Metrics")
        try:
            conn = BuiltIn().get_variable_value("${PCC_CONN}")
            print("conn is {}".format(conn))
        except Exception as e:
            raise e
        flag = 'OK'
        try:    
            payload = {
                        "query": f"connectionStatus&start={START_TIME}&end={END_TIME}&step={STEP}"
                    }
            data=get_response_data(pcc.query_metric(conn, payload))
            if data:
                logger.console(f"Successfully retrieved connection status metrics: {pformat(data)}")
            else:
                logger.warn(f"Failed to retrieve connection status metrics") 
                flag = 'ERROR'
            return flag
        except Exception as err:
            logger.warn(f"Failed retrieving connection status metrics with an error")
            raise err
            