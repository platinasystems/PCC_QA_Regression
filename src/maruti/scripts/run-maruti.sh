#!/bin/bash
if [ -z "$MOTOR_HOME" ]; 
  then export MOTOR_HOME="/motor";
fi
echo "MOTOR_HOME=$MOTOR_HOME"
cd $MOTOR_HOME
sudo -H python3 setup.py sdist
sudo -H pip3 uninstall -y maruti
sudo -H pip3 install $MOTOR_HOME/dist/maruti-1.0.0.tar.gz 
