#!/bin/bash

./step_01_grb2netcdf.sh
./step_02_soma_timestep.sh
ncl step_03_calculo_inicio_estac_chuva.ncl
./step_04_agrupa_dia.sh
./step_05_agrupa_20ensemble.sh
python3.7 step_06_mean_onset.py
./step_07_norientation.sh
grass76 --tmp-location utils/region_reference.tif --exec bash step_08_cliponset.sh
