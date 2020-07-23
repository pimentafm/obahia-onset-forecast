import os
import re 
import numpy as np
import xarray as xr
import rioxarray

infolder = 'CFSv2/onsetforecast/'
outfolder = "CFSv2/geotiff/"

files = [f for f in os.listdir(infolder) if re.match('mes_20ensemble_(\d+)\.nc$', f)]

for filename in files:
    dataset = xr.open_dataset(infolder + filename)

    for i in range(len(dataset.outoday.lat)):
        for j in range(len(dataset.outoday.lon)):
            dataset.outoday[: ,i,j] = dataset.outoday[: ,i,j].where(dataset.outoday[: ,i,j] != dataset.outoday[: ,i,j].min())
            dataset.outoday[: ,i,j] = dataset.outoday[: ,i,j].where(dataset.outoday[: ,i,j] != dataset.outoday[: ,i,j].max())

    mean = dataset.mean(dim = 'time', skipna = True, keep_attrs = True)
    
    outoday_mean = mean.outoday.rio.set_spatial_dims('lon', 'lat')
    #outoday_mean.rio.to_raster(outfolder+filename+'.tif')

    mask_lon = (outoday_mean.lon >= -83.9066156125536082) & (outoday_mean.lon <= -35.1566778444776276)
    mask_lat = (outoday_mean.lat >= -17.9526924946241913) & (outoday_mean.lat <= -0.0000000438756413)

    # mask_lon = (outoday_mean.lon >= -49.2188960804658393) & (outoday_mean.lon <= -40.7814055050120032)
    # mask_lat = (outoday_mean.lat >= -17.0078089375000019) & (outoday_mean.lat <= -8.5039080625000008)

    croped_outoday_mean = outoday_mean.where(mask_lon & mask_lat, drop=True)

    new_lon = np.linspace(croped_outoday_mean.lon[0], croped_outoday_mean.lon[-1], 1000)
    new_lat = np.linspace(croped_outoday_mean.lat[0], croped_outoday_mean.lat[-1], 1000)

    interpolation = croped_outoday_mean.interp({'lat':new_lat, 'lon':new_lon})
    interpolation = interpolation.rio.set_spatial_dims('lon', 'lat')
    interpolation.rio.to_raster(outfolder+filename+'.tif')





