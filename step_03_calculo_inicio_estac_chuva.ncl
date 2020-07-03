;Realiza o AA (Cálculo do inicio da estação chuvosa) pra os dados de previsão CFSv2 
; sem realizar nenhum tipo de preenchimento 
; Os valores recebem uma correção de vés relativa ao 
; histórico do TRMM e do CFSv2 atravé de um valor de razão
;----------------------------------------------------------
;LUIZ FELIPE SANT ANNA COMMAR
; 06/02/20
;#######################################################
;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
;load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
;load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/calendar_decode2.ncl"
;load "~/lib_abrahao.ncl" ;You can find this on ftp.biosfera.dea.ufv.br/gabriel/lib_abrahao.ncl


begin ;SCRIPT

;ano = systemfunc("date +%Y")
ano = 2019
infolder		=	"CFSv2/soma/"

; outfolder 		=	"/home/matheus/cfsBot_v2/CFSv2/CFSv2_daily/"+ano+"/calc_inicio_chuva/"
;outfolder		=	"/home/luiz/CFSv2_daily/"+ano+"/new/"
outfolder = "CFSv2/onsetforecast/"

;infolderobs 	=	"/home/luiz/TRMM/serie_ano/"

invarname		=	"PRATE_P0_L1_GGA0"

prefix			=	"prate.01."

suffix			=	".daily.grb2.nc"

medias_nc		= "utils/"

;syear			=	1998
;eyear			=	2017	;Keep in mind that we also need the year after this one to compute the "agricultural year" 2017 means that we're using half of 2018.

baseval			=	2.5

daysyear		=	182

timeaxis		=	0	;0 time in ag year days, 1 time in actual DOY

;nyears = eyear - syear + 1
;ARRAYS PARA INSERÇÃO DOS LOOPS
hour 	= 	(/"00","06","12","18"/) ; ->loop dentro do array
diasmes = 	(/"01","27","28","29","30","31"/)
meses 	= 	(/"07","08","09","10"/)

; ----------------- arquivos e dados para correção de bias ------------------------------------
biasobs = addfile(medias_nc + "obs_long_term_mean.nc", "r")
julobs = biasobs->jul
agoobs = biasobs->ago
setobs = biasobs->set
outobs = biasobs->out
novobs = biasobs->nov
dezobs = biasobs->dez
printVarSummary(julobs)

biasfore = addfile(medias_nc + "obs_long_term_mean_cfsv2.nc", "r")
julfore = biasfore->jul
agofore = biasfore->ago
setfore = biasfore->set
outfore = biasfore->out
novfore = biasfore->nov
dezfore = biasfore->dez
printVarSummary(julfore)
print(min(julfore))
; copy_VarCoords(julobs, julfore)
dimsvar = dimsizes(julfore)
print(dimsvar)
nlat = dimsvar(0)
nlon = dimsvar(1)

year = ano
do mes = 0,3
	do dia = 0,5
		do hora = 0,3
		
		if (.not. fileexists(infolder + prefix + ano + meses(mes) + diasmes(dia) + hour(hora) + suffix)) then
			print("Arquivo faltante ...")
			; print(infolder + prefix + ano + meses(mes) + diasmes(dia) + hour(hora) + suffix)
			print(" ")
		else

			dumfile = addfile(infolder + prefix + ano + meses(mes) + diasmes(dia) + hour(hora) +suffix,"r")
			dumvar = dumfile->$invarname$
			dumvar@_FillValue = -9999.9 
			dumdims = dimsizes(dumvar)

			outoday = new(array_append_record(1,dumdims(1:2),0),typeof(dumvar),-9999.9) ;Output variable for onset day
			dumvar1=dumvar(:0,:,:);avoid copyVarCoords error 
			copy_VarCoords(dumvar1,outoday) ;You can find this function on ftp.biosfera.dea.ufv.br/gabriel/lib_abrahao.ncl
			outoday!0 = "time"
			outoday&time = 1;fspan(syear,eyear,nyears) ;WARNING: Bugs if there is only one year
			outeday = outoday ;Output variable for end day
			outslen = outoday ;OUtput variable for season length
			
			outfname = "tudo_all_years_2.5_"+ano+meses(mes)+diasmes(dia)+hour(hora)+".nc"
			system("rm " + outfolder + outfname)
			arqout = addfile(outfolder + outfname,"c")
			arqout@baseval = baseval
			arqout@daysyear = daysyear
		
			outmeanfname = "mean_2.5_"+ano+meses(mes)+diasmes(dia)+hour(hora)+".nc"
			system("rm " + outfolder + outmeanfname)	
		
			arqoutmean = addfile(outfolder + outmeanfname,"c")
			arqoutmean@baseval = baseval
			arqoutmean@daysyear = daysyear

			arqin1 = addfile(infolder + prefix + year + meses(mes) + diasmes(dia) + hour(hora) + suffix,"r") ;entrada do arquivo referente a pentada
			varin1 = arqin1->$invarname$
			ndays_forecast = dimsizes(varin1&time)


			if (ndays_forecast.lt.150) then ;don't if the number os tims in the forecast are less then 4 months
				print("poor number of forecast, should be at least four months :,(  ")
				delete(dumvar)
				delete(dumdims)
				delete(varin1)
			else
						

				mes_array = (/stringtointeger(meses(mes))/)
				dia_array = (/stringtointeger(diasmes(dia))/)
				daysyear_ajust = 0
				daysyear_ajust=day_of_year(ano, mes_array, dia_array)
				print(daysyear_ajust)
				fim_ano = day_of_year(ano, 12, 31)

				varin = varin1;(:fim_ano-daysyear_ajust-1,:,:);recebe do inicio do arquivo até o dia 31/12
				varin@_FillValue = -9999.9
				varin@missing_value= -9999.9
				printVarSummary(varin)
				varin = varin@_FillValue;recebe o arquivo de entrada a partir do dia 01/07
				varin!0 = "time"
				ndays = dimsizes(varin&time) ;define a dimensão de acordo com arquivo de entrada
				print("numero de dias "+(/ndays/))
				print("numero de dias "+(/ndays_forecast/))

				varin = varin@_FillValue

				; Criação do arquivo de chuvas-----------------------------------------
				varin = varin1;(:fim_ano-daysyear_ajust-1,:,:)
; 				-----------------------------------------------------------------------

				printVarSummary(varin)
				; delete(varin2)
				ndays1 = dimsizes(varin1&time) ;The number of days on the first year, to check for leap years
				; ndays2 = dimsizes(varin2&time) ;The number of days on the first year, to check for leap years

				isleap1 = ndays1.eq.366
				; isleap2 = ndays2.eq.366


				if (timeaxis.eq.0) then
					varin&time=ispan(0,dimsizes(varin&time)-1,1)
				end if	
				
				aaout = varin ;Anomalous accumulation
				; varin_obs = varin2(daysyear:,:,:)
				printVarSummary(aaout)

				aaout@_FillValue = -9999.9
				aaout@missing_value = -9999.9
				aaout = 0.0
				aaout(0,:,:) = varin(0,:,:) - baseval ;First day of accumulation
			 	
				daaout = aaout ;Derivative of AA
				daaout = 0.0

				mdaa = daaout(0,:,:) ;Maximum value of dAA
				mdaaday = daaout(0,:,:) ;Day of maximum value of dAA
				mdaaday = mdaaday@_FillValue 

				minaa = aaout(0,:,:) ;Minimum value of AA before the maximum of dAA
				maxaa = aaout(0,:,:) ;Maximum value of AA after the maximum of dAA

				minaaday = minaa
				maxaaday = maxaa

				minaaday = minaaday@_FillValue
				maxaaday = minaaday@_FillValue

				mdaaday = mdaaday@_FillValue
				mdaa = -99999999999999999999999.9 ;Very small number, negative
			; print(mdaa)
				;Metadata
				aaout@long_name = "Anomalous accumulation"
				daaout@long_name = "Derivative of anomalous accumulation"
				mdaa@long_name = "Maximum AA derivative"
				mdaaday@long_name = "Day of maximum AA derivative"
				minaa@long_name = "Minimum Anomalous accumulation"
				maxaa@long_name = "Maximum Anomalous accumulation"
				minaaday@long_name = "Day of minimum Anomalous accumulation"
				maxaaday@long_name = "Day of maximum Anomalous accumulation"
; ------------------- BIAS REMOVAL ------------------------------
				avgrain = dim_avg_n_Wrap(varin,0)
				; prec_mean=avgrain
				; prec_mean_obs=dim_avg_n_Wrap(varin_obs,0)
				; prec_mean = where(prec_mean .eq.0, 1, prec_mean)
				; ajuste_bias = prec_mean_obs/prec_mean
				prec = varin
				prec_ajustada = varin
				prec_ajustada = varin@_FillValue
				printVarSummary(prec_ajustada)
				copy_VarCoords(varin, prec_ajustada)

				do day = 0,ndays-1
				
					if (day+daysyear_ajust-daysyear .le.30) then 
											; LINEAR SCALING (LSC)
						prec_ajustada(day,:,:) = where(julfore(:,:) .ne. 0., varin(day,:,:)*(julobs(:,:)/julfore(:,:)), varin(day,:,:))
					end if
					if (day+daysyear_ajust-daysyear.ge.31 .and. day+daysyear_ajust-daysyear.le.61) then 
											; LINEAR SCALING (LSC)
						prec_ajustada(day,:,:) = where(agofore(:,:) .ne. 0., varin(day,:,:)*(agoobs(:,:)/agofore(:,:)), varin(day,:,:))
					end if
					if (day+daysyear_ajust-daysyear.ge.62 .and. day+daysyear_ajust-daysyear.le.91) then 
											; LINEAR SCALING (LSC)
						prec_ajustada(day,:,:) = where(setfore(:,:) .ne. 0., varin(day,:,:)*(setobs(:,:)/setfore(:,:)), varin(day,:,:))
					end if
					if (day+daysyear_ajust-daysyear.ge.92 .and. day+daysyear_ajust-daysyear.le.122) then 
											; LINEAR SCALING (LSC)
						prec_ajustada(day,:,:) = where(outfore(:,:) .ne. 0., varin(day,:,:)*(outobs(:,:)/outfore(:,:)), varin(day,:,:))
					end if
					if (day+daysyear_ajust-daysyear.ge.123 .and. day+daysyear_ajust-daysyear.le.153) then 
											; LINEAR SCALING (LSC)
						prec_ajustada(day,:,:) = where(novfore(:,:) .ne. 0., varin(day,:,:)*(novobs(:,:)/novfore(:,:)), varin(day,:,:))
					end if
					if (day+daysyear_ajust-daysyear.ge.154) then 
											; LINEAR SCALING (LSC)
						prec_ajustada(day,:,:) = where(dezfore(:,:) .ne. 0., varin(day,:,:)*(dezobs(:,:)/dezfore(:,:)), varin(day,:,:))
					end if
				end do 

				do day = 1,ndays-1
					aaout(day,:,:) = aaout(day-1,:,:) + prec_ajustada(day,:,:) - baseval
					daaout(day,:,:) = aaout(day,:,:) - aaout(day-1,:,:)
					

					dummdaa = where(daaout(day,:,:).gt.mdaa,daaout(day,:,:),mdaa)
					mdaaday = where(daaout(day,:,:).gt.mdaa,day+daysyear_ajust-daysyear,mdaaday)
					mdaa = (/dummdaa/)

				end do ;DAY
					
				;Average daily rainfall and mask if is more than baseval

				; prec_ajustada = prec*ajuste_bias
				 ; printVarSummary(avgrain)
				 ; print(avgrain)
				basemsk = where(avgrain.lt.baseval,False,True)
				; print(basemsk)

				;This is the method for avgrain.lt.basval
				;FIXME: We have to loop again because we need the min(max) aa before(after) 
				;the maximum daa, and we don't know the max daa before finishing the loop,
				;but there might be a workaround
				do day = 1,ndays-1
					dumminaa = where((aaout(day,:,:).lt.minaa).and.(day+daysyear_ajust-daysyear.lt.mdaaday),aaout(day,:,:),minaa)
					dummaxaa = where((aaout(day,:,:).gt.maxaa).and.(day+daysyear_ajust-daysyear.gt.mdaaday),aaout(day,:,:),maxaa)

					minaaday = where((aaout(day,:,:).lt.minaa).and.(day.lt.mdaaday),day+daysyear_ajust-daysyear,minaaday)
					maxaaday = where((aaout(day,:,:).lt.maxaa).and.(day.lt.mdaaday),day+daysyear_ajust-daysyear,maxaaday)

					minaa =(/dumminaa/)
					maxaa =(/dummaxaa/)
				end do ;DAY
				; print(minaaday)
				;Override values from the method above if its more than baseval
				minaa = where(basemsk,dim_min_n_Wrap(aaout,0),minaa)
				maxaa = where(basemsk,dim_max_n_Wrap(aaout,0),maxaa)

			 	;print(minaa)
				do day = 1,ndays-1
					minaaday = where(aaout(day,:,:).eq.minaa,day+daysyear_ajust-daysyear,minaaday)
					maxaaday = where(aaout(day,:,:).eq.maxaa,day+daysyear_ajust-daysyear,maxaaday)

				end do
				;print(minaaday)
			 	minaaday@units = "days since"+ano+"-07-01"
			 	printVarSummary(outoday)
			 	printVarSummary(minaaday)
			 	printVarSummary(outeday)
			 	printVarSummary(maxaaday)
				outoday(0,:,:) = (/minaaday/)
				outeday(0,:,:) = (/maxaaday/) 
				outslen(0,:,:) = outeday(0,:,:) - outoday(0,:,:)

				printVarSummary(outoday)
				;print(outeday)

				arqout->outoday=outoday
				arqout->outeday=outeday
				arqout->outslen=outslen

				arqoutmean->outoday=dim_avg_n_Wrap(outoday,0)
				arqoutmean->outeday=dim_avg_n_Wrap(outeday,0)
				arqoutmean->outslen=dim_avg_n_Wrap(outslen,0)

				system("rm " + outfolder + "anac-" + year + meses(mes) + diasmes(dia) + hour(hora) + ".nc")
				dumarq = addfile(outfolder + "anac-" + year + meses(mes) + diasmes(dia) + hour(hora) + ".nc","c")

				print(outfolder + "anac-" + year + meses(mes) + diasmes(dia) + hour(hora)+"-------")

				dumarq@year = year
				dumarq@baseval = baseval
				dumarq@daysyear = daysyear
				dumarq->aaout = aaout
				dumarq->daaout = daaout
				dumarq->mdaa = mdaa
				dumarq->mdaaday = mdaaday
				dumarq->minaaday = minaaday
				dumarq->maxaaday = maxaaday
				dumarq->minaa = minaa
				dumarq->maxaa = maxaa


				system("rm " + outfolder + "estc-" + year + meses(mes) + diasmes(dia) + hour(hora) + ".nc")
				dumarq = addfile(outfolder + "estc-" + year + meses(mes) + diasmes(dia) + hour(hora) + ".nc","c")
				dumarq@year = year
				dumarq@ybaseval = baseval
				dumarq->prec = varin
				; dumarq->prec_mean = avgrain
				; dumarq->prec_mean_obs = prec_mean_obs
				; dumarq->ajuste_bias = ajuste_bias
				; dumarq->prec_ajustada = prec_ajustada
				dumarq->mdaa = mdaa
				dumarq->mdaaday = mdaaday
				dumarq->minaaday = minaaday
				dumarq->maxaaday = maxaaday
				dumarq->minaa = minaa
				dumarq->maxaa = maxaa

				delete(varin1)
				; delete(varin2)
				; delete(varin3)
				delete(varin)
				delete(aaout)
				delete(prec)
				delete(daaout)
				delete(mdaa)
				delete(mdaaday)
				delete(dumfile)
				delete(dumvar)
				delete(dumvar1)
				delete(ndays)
				delete(ndays_forecast)
				; delete(varin_obs)
				; delete(prec_mean_obs)
				; delete(ajuste_bias)
				delete(prec_ajustada)
			end if ;lesst then 150 times

		end if ;fileexists(file_path)
		
		end do 
	end do
end do
end

