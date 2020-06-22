#!/bin/bash
if [ -z "$MOTOR_HOME" ]; 
  then export MOTOR_HOME="/home/pcc/aa";
fi
echo "MOTOR_HOME=$MOTOR_HOME"
cd $MOTOR_HOME
sudo -H python3 setup.py sdist
sudo -H pip3 uninstall -y aa
sudo -H pip3 install $MOTOR_HOME/dist/aa-1.0.0.tar.gz 
