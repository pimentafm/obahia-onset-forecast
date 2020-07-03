#!/bin/bash
# Script pra fazer a soma diária do arquivo
#a cada quatro timesteps do CFSv2
#de acordo com o horáio de inicialização

#LUIZ FELIPE SANT ANNA COMMAR
# 09/03/2020
#------------------
prefix="prate.01."
sufix=".daily.grb2.nc"
# fname="daily_onset_"

hora=(00 06 12 18)
meses=(07 08 09 10)
# ano=(2011 2012 2013 2014 2015 2016 2017 2018)

ano=(2019) #FALTA AUTOMATIZAR CRIACAO DE SUB DIRETORIO..... !!!!
#ano=`date +%Y`

#ano=sytem(ano)

# [ ! -d $dirDownName ] && { mkdir $dirDownName; }

diasmes=(01 27 28 29 30 31)

y=0
#while [ $y -le 7 ]
#do

	infolder="CFSv2/netcdf/"
	outfolder="CFSv2/soma/"

	mes=0
	while [ $mes -le 3 ]
	do 
		d=0
	    while [ $d -le 5 ]
	    do
	    	h=0
	    	while [ $h -le 3 ]
	    	do

	    		outname=$prefix${ano[y]}${meses[mes]}${diasmes[d]}${hora[h]}$sufix
	    		
	    		echo $infolder$prefix${ano[y]}${meses[mes]}${diasmes[d]}${hora[h]}$sufix

	    		if [ $h -eq 0 ]
    			then
	    			cdo timselsum,4 -setmissval,-9999.9 $infolder$prefix${ano[y]}${meses[mes]}${diasmes[d]}${hora[h]}$sufix $outfolder$outname
	    		
	    		elif [ $h -eq 1 ]
    			then
	    			cdo timselsum,4,3 -setmissval,-9999.9 $infolder$prefix${ano[y]}${meses[mes]}${diasmes[d]}${hora[h]}$sufix $outfolder$outname
	    		
	    		elif [ $h -eq 2 ]
    			then
	    			cdo timselsum,4,2 -setmissval,-9999.9 $infolder$prefix${ano[y]}${meses[mes]}${diasmes[d]}${hora[h]}$sufix $outfolder$outname
	    		
	    		else
	    			cdo timselsum,4,1 -setmissval,-9999.9 $infolder$prefix${ano[y]}${meses[mes]}${diasmes[d]}${hora[h]}$sufix $outfolder$outname
	    		fi
	    		
	    		h=$[h+1]
	    	done
	    	d=$[d+1]
	    done
	    mes=$[mes+1]
	done
	#y=$[y+1]
#done

