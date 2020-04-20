FROM ubuntu:18.04
 
RUN apt-get -y update
RUN apt-get install -y apt-utils python3 python3-pip wget
RUN apt-get -y upgrade
RUN python3 -m pip install --user --upgrade setuptools wheel
RUN pip3 install robotframework robotframework-requests 

RUN wget -P /tmp http://172.17.3.225/platina_sdk-1.0.2.tar.gz
RUN pip3 install /tmp/platina_sdk-1.0.2.tar.gz
