FROM debian:buster-20200422-slim

#MAINTAINER Matheus Lucas <paramatheuslucas@yhaoo.com.br>
LABEL versao="1.0"
LABEL descricao="teste descricao"
LABEL instituicao="Grupo de Pesquisa em Interacao Atmosfera-Biosfera - UFV <http://www.biosfera.dea.ufv.br>"
LABEL mantenedores="Matheus Lucas <paramatheuslucas@yahoo.com.br> - Fernando Pimenta <fernando.m.pimenta@ufv.br>"

RUN mkdir /onset-forecast
WORKDIR /onset-forecast

# apt install...
RUN apt-get -y update && apt-get -y install cdo nco libeccodes-tools ncl-ncarg python3.7-dev python3-pip bash grass
# pip Install...
RUN pip3 --no-cache-dir install --upgrade pip && pip3 --no-cache-dir install xarray numpy rioxarray netCDF4 julian

# clear apt cache...
#RUN rm -rf /var/lib/apt/lists/* && apt-get -y clean autoclean autoremove

ENTRYPOINT ["/onset-forecast/init.sh"]

