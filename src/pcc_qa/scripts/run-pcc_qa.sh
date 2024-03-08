#!/bin/bash
#if [ -z "$MOTOR_HOME" ];
#  then export MOTOR_HOME="/PCC_QA_Regression";
#fi
#echo "MOTOR_HOME=$MOTOR_HOME"
#cd $MOTOR_HOME
export PYTHONPATH=/usr/local/robot
#robot -x $MOTOR_HOME/output/robot.xml --outputdir $MOTOR_HOME/output $1 $2 $3 $4 $5 $6 $7 $8
robot -x output/robot.xml --outputdir output