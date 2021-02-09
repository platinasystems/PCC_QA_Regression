FROM mplatina/motor-test-base:1.0.0
COPY tests /motor/tests
COPY pipeline /motor/pipeline
COPY src /motor/src
WORKDIR /motor
COPY setup.py /motor/setup.py
RUN python -m pip install --upgrade pip
RUN python3 setup.py sdist bdist_wheel
RUN pip3 install /motor/dist/aa-1.0.0.tar.gz
