#!/bin/bash
if [ -z "$MOTOR_HOME" ]; 
  then export MOTOR_HOME="/home/jenkins/PCC_QA_Regression";
fi
echo "MOTOR_HOME=$MOTOR_HOME"
cd $MOTOR_HOME
sudo -H python3 setup.py sdist
sudo -H pip3 uninstall -y pcc_qa
sudo -H pip3 install $MOTOR_HOME/dist/PCC_QA_Regression-1.0.0.tar.gz
