#!/bin/bash
./make_comma.pl ../data/in/ODL_MOVEMENTS_CONFLUENT_POC-2018-12-01-sample1000.csv | kafka-console-producer --broker-list localhost:9092 --topic ODL_MOVEMENTS_RAW

