#!/bin/bash
kafka-console-producer --broker-list localhost:9092 --topic ODL_MOVEMENTS < data/in/ODL_MOVEMENTS_CONFLUENT_POC-2018-12-01-sample1000.csv

