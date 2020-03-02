#!/bin/bash
printf "%q" $(cat odl_movements.schema.json) | perl -pe 's/\\([\[\]{}])/$1/g' >odl_movements.schema.json.escaped
