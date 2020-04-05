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
    