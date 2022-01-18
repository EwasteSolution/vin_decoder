#! /usr/bin/luajit
https=require('ssl.https')
 cjson = require "cjson"
cjson2 = cjson.new() 
cjson_safe = require "cjson.safe"
salt=require('salt')
--url base
site='https://vpic.nhtsa.dot.gov/api/'
--format
frmt='?format=json'
dvin={}
dvin.lstMakes=function(site,frmt)
    local  url=tostring(site..'vehicles/GetAllMakes'..frmt)
return url            
end
--[[gets the  models for a make must provide paral string or make nunmber lstMakes showas your choices if you include year
    you will get just the modekls from that year you can also include a type truck,car,motorcyle,etc]]
dvin.lstModels=function(site, make, frmt,year,body)
    local m=make
    local y=year
    local t=body
    if type(y)==nil then
         if type(m)==string then
            local  url=tostring(site..'vehicles/GetModelsForMake/'..m..frmt)
        elseif type(m)==number then
            local url=tostring(site..'vehicles/GetModelsForMakeId/'..m..frmt)
        else 
            print('ERROR 10 INVALID MAKE ENTRY ENTER MAKE NAME OR ID')
            exit(10)
        end
    elseif type(y)==string then
         if type(m)==string then
            local url=tostring(site..'vehicles/GetMakesForManufacturerAndYear/Make/'..m..'/modelyear/'..y)
        elseif type(m)==number then
            local url=tostring(site.. 'vehicles/GetModelsForMakeIdYear/makeId/'..m..'/modelyear/'..y)
        else
            print('ERROR 10 INVALID MAKE ENTRY ENTER MAKE NAME OR ID')
            exit(10)
        end
        if type(t)==string then
           url=tostring(url..'/vehicletype/'..t..frmt)
       else
            url=tostring(url..frmt)
        end
   end 
return url
end
--get possible var list
dvin.lstVars=function(site,frmt)
    url=tostring(site..'vehicles/GetVehicleVariableList'..frmt)
return url
end
---gets possible values for spesified var
dvin.varVal=function(site,var,fmt)
    url=tostring(site..'vehicles/GetVehicleVariableValuesList/'..var..fmt)
return url
end
--main atractionn decode vin suply vin or part whit A* in place of missing chars also add year if you can
dvin.decode=function(site,vin,frmt,year)
    url=tostring(site..'vehicles/DecodeVinValuesExtended/'..vin..frmt)
   if type(year)==string then
        url=tostring(url..'&modelyear='..year)
    end
 return url
end
--sends the url  gets info back if out file is specified it will saveb theresults there
dvin.mkCall=function(url,oufl)
    local urlt=url
   local r,c,h,s= https.request(urlt)
   if r[message]==	"Response returned successfully" or  r[message]=="Results returned successfully. NOTE: Any missing decoded values should be interpreted as NHTSA does not have data on the specific variable. Missing value should NOT be interpreted as an indication that a feature or technology is unavailable for a vehicle." then
   local R=cjson.decode(r[Results])
   if type(oufl)==string then
        salt.save(R,oufl)
    end
else
    print('ERROR14 RESPONCE NOT SUCSESFULLY RETURNED')
    exit(14)
 end
return R
end

