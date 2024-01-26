FROM mplatina/motor-test-base:1.0.0
COPY tests /motor/tests
COPY pipeline /motor/pipeline
COPY src /motor/src
WORKDIR /motor
COPY setup.py /motor/setup.py
RUN python3 -m pip install --upgrade pip
RUN python3 setup.py sdist bdist_wheel
RUN pip3 install /motor/dist/PCC_QA_Regression-1.0.0.tar.gz
RUN pip3 install python-imap
RUN pip3 install PyJWT
RUN pip3 install decorator
RUN pip3 install pyotp
