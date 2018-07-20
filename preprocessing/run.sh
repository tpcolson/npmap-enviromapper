#!/bin/bash

# This script (in the near future) will include the list of tasks needed from start
# to finish to run the whole preprocessing steps for Enviromapper

./extract_subcategory.sh layers/cat_type_disturbance.geojson cat_type_disturbance FCSUBTYPE
./merge_disturbance_subcategory.sh

