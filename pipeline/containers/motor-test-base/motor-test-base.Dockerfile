FROM ubuntu:18.04
 
RUN apt-get -y update
RUN apt-get install -y apt-utils python3 python3-pip git
RUN apt-get -y upgrade
RUN python3 -m pip install --user --upgrade setuptools wheel
RUN pip3 install robotframework robotframework-requests 
