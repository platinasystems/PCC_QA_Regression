import json
import os
from robot.api.deco import keyword
from aa.common.Utils import banner, trace

TESTDATA_FILE_DIRECTORY = "./tests/test-data/"

###########################################################################
@keyword(name="TESTDATA.Get")
###########################################################################
def get(testdata_file, testdata_key):
    banner("TESTDATA.Get  file=%s  key=%s" % (testdata_file, testdata_key))
    try:
        with open(TESTDATA_FILE_DIRECTORY + testdata_file) as json_file:
            test_data = json.load(json_file)
        return test_data[testdata_key]
    except Exception as e:
        trace("ERROR: %s" % str(e))
        return {"Error": str(e)}
