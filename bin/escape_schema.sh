#!/bin/bash
printf "%q" $(cat odl_movements.schema.json) >odl_movements.schema.json.escaped
