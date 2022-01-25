import os
import sys
import json
from datetime import datetime 
from robot.api import logger
from robot.api.deco import keyword

# windows console colors
if os.name == 'nt':
    from ctypes import windll, Structure, c_short, c_ushort, byref
    yellow = ""
    default = ""
elif os.name == "posix":
    yellow = "\u001b[33m"
    magenta = "\u001b[35m"
    default = "\u001b[39m"
else:
    yellow = ""
    default = ""

log_level = 5
DONT_TRUNCATE_OVER_1k = False

def error(msg):
    if log_level > 0:
        logger.console(format_message(msg, 'ERROR'))

def warn(msg):
    if log_level > 1:
        now = datetime.now().strftime("%d-%b-%y %H-%M-%S")      
        logger.console(format_message(msg, '     [%s]' % now))

def info(msg):
    if log_level > 2:
        now = datetime.now().strftime("%d-%b-%y %H-%M-%S")      
        logger.console(format_message(msg, '     [%s]' % now))

def debug(msg):
    if log_level > 3:
        message = str(msg)
        if len(message) < 1024 or DONT_TRUNCATE_OVER_1k:
            logger.console(format_message(message + default, magenta ))
        else:
            logger.console(format_message(message[0:1024] + default + " |TRUNCATED", magenta ))

def trace(msg):
    if log_level > 4:
        now = datetime.now().strftime("%d-%b-%y %H-%M-%S")      
        logger.console(format_message(str(msg), '     [%s]' % now))

@keyword(name="Pretty Print")
def pretty_print(msg):
    try:
        logger.console(json.dumps(msg, indent=4, sort_keys=True))
    except Exception as e:
        logger.console(e)

def banner(msg):
    logger.console("\n" + yellow)
    logger.console("***********************************************************")
    logger.console(str(msg))
    logger.console("***********************************************************" + default)

def format_message(msg, level):
    return level + ": " + str(msg)

def cmp_json(data1,data2):
    data1, data2 = json.dumps(data1, sort_keys=True), json.dumps(data2, sort_keys=True)
    print("data1:"+str(data1))
    print("data2:"+str(data2))
    if data1 == data2: # a normal string comparison
        return "Ok"
 
def midtext(start,end,text):
    startpos = text.index(start)
    endpos= text.find(end,startpos+1)
    return(text[startpos+(len(start)+1):endpos].strip())

## Size converter function
def convert(value, size):
    converter = {'B':1 * value,
                 'KiB':10 * value,
                 'MiB':100 * value,
                 'GiB':1000 * value,
                 'TiB':10000 * value,
                 'PiB':100000 * value,
                 'EiB':1000000 * value,
                 'KB': 10 * value,
                 'MB': 100 * value,
                 'GB': 1000 * value,
                 'TB': 10000 * value,
                 'PB': 100000 * value,
                 'EB': 1000000 * value
                 }
    if size in converter:
        return converter[size]
    else:
        return "Size not found in the list"

def convertFromTo(value, startUnit, endUnit = 'B'):
    converter = {'B': 1,
                 'KiB': 2**10,
                 'MiB': 2**20,
                 'GiB': 2**30,
                 'TiB': 2**40,
                 'PiB': 2**50,
                 'EiB': 2**60,
                 'KB': 1e3,
                 'MB': 1e6,
                 'GB': 1e9,
                 'TB': 1e12,
                 'PB': 1e15,
                 'EB': 1e18
                 }
    if startUnit not in converter.keys() or endUnit not in converter.keys():
        return "Size not found in the list"

    unit = converter[startUnit] / converter[endUnit]
    return value * unit