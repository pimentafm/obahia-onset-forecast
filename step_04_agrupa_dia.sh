#!/bin/bash

prefix="tudo_all_years_2.5_"
sufix=".nc"
fname="daily_onset_"
fnamean="mean_daily_"
hora=(00 06 12 18)
meses=(07 08 09 10)
#ano=(systema(ano)
diasmes=(01 27 28 29 30 31)

#ano=`date +%Y`

#debug...
ano=2019

infolder="CFSv2/onsetforecast/"
outfolder="CFSv2/onsetforecast/"

        mes=0
        while [ $mes -le 3 ]
        do
            d=0
            while [ $d -le 5 ]
            do
                    outname=$fname$ano${meses[mes]}${diasmes[d]}$sufix
                    outnamemean=$fnamean${meses[mes]}${diasmes[d]}$sufix
                    echo
                    echo $outfolder$outname
                    #echo $(ls $infolder$prefix$ano${meses[mes]}${diasmes[d]}*$sufix)
                    echo
                    rm  $outfolder$outname
                    cdo mergetime $infolder$prefix$ano${meses[mes]}${diasmes[d]}* $outfolder$outname

                    

                    d=$[d+1]
            done #hora
                mes=$[mes+1]
        done #mes



