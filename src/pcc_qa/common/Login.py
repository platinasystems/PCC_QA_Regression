import sys
import distro
import time
import json
import urllib3
import requests
from pcc_qa.common.Utils import banner, trace, pretty_print

PCC_SECURITY_AUTH = "/security/auth"

## Login
def login(url:str, username:str, password:str, proxy:str=None, insecure:bool=False, use_session:bool=True)->dict:
    """
    [Args]
        url: URL of the PCC being tested
        username: PCC Username (default: admin)
        password: PCC Password (default: admin)
        proxy: URL for HTTPS proxy (default: none)
        insecure: Suppress warnings about bad TLS certificates (default: False)
        use_session: Use Python requests Session objects to maintain session (default: True)

    [Returns]
        conn: Dictionary containing session and token
    """
    session = requests.Session()
    print("Session:"+str(session))
    if sys.platform == "win32":
        raise Exception("Windows not (yet) supported")    
    elif 'linux' in sys.platform:
        distro_name = distro.linux_distribution(full_distribution_name=False)[0]
        if distro_name == "ubuntu" or distro_name == "debian":
            session.verify = False
        else:
            raise Exception("Linux distribution: %s not supported" % distro_name)
    if insecure:
        urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
    headers = {'Content-Type': 'application/json'}
    payload = {'username': username, 'password': password}

    proxies = {}
    if proxy:
        # We don't allow HTTP today, but will likely add a redirect from port
        # 80 to port 443 in the future. At that point, we'll need the proxy for
        # that to succeed too.
        proxies['http'] = proxy
        proxies['https'] = proxy

    response = session.post(url + PCC_SECURITY_AUTH, json=payload, headers=headers, proxies=proxies)
    trace("Response:"+str(response.status_code))
    if response.status_code != 200:
        return {"status_code": response.status_code}
    result = json.loads(response.text)
    token = result['token']
    
    user_session = ""
    if use_session:
        user_session = session

    return {'session': user_session, 'token': token, 'url': url, 'proxies': proxies, 'options': {'insecure': insecure, 'use_session': use_session}, 'status_code':response.status_code}
