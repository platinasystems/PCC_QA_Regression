import os
import re
import sys
from robot.api.deco import keyword
from aa.common.Utils import banner, trace

###########################################################################
@keyword(name="Get Result")
###########################################################################
def get_result(response):
    try:
        return response["Result"]
    except Exception as e:
        return {"Error": str(e)}

###########################################################################
@keyword(name="Get Response Data")
###########################################################################
def get_response_data(response):
    try:
        return response["Result"]["Data"]
    except Exception as e:
        return {"Error": str(e)}

###########################################################################
@keyword(name="Get Result Field")
###########################################################################
def get_result_field(response, field):
    try:
        return response["Result"][field]
    except Exception as e:
        return {"Error": str(e)}

###########################################################################
@keyword(name="Get Response Status Code")
###########################################################################
def get_result_field(response):
    try:
        return response["StatusCode"]
    except Exception as e:
        return {"Error": str(e)}

###########################################################################
@keyword(name="Get Stripped Result Field")
###########################################################################
def get_stripped_result_field(response, field):
    try:
        # remove newlines and whitespace
        return ' '.join(response["Result"][field].split())
    except Exception as e:
        return {"Error": str(e)}
