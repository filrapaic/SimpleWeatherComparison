#!bin/bash


echo Comparison temperature for desired City from services : Accuweather and DarkSky.
echo To use this you have to have Location and API keys for both services which are free.
echo Koristeni su: 

echo jq and bc are required for usage and will be installed
echo ---------------------------------------------------------------------

# Installation of required pipes

sudo apt-get install jq -y
sudo apt install bc -y


echo ---------------------------------------------------------------------
echo jq installed
echo bc installed
echo Getting data

# getting json data from web

curl "http://dataservice.accuweather.com/forecasts/v1/daily/5day/[YOUR CITY ID HERE WITHOUT BRACKETS]?apikey=[YOUR API KEY HERE WITHOUT BRACKETS]&metric=true" > AW.json
curl "https://api.darksky.net/forecast/[YOUR API KEY HERE WITHOUT BRACKETS]/[YOUR CITY LOCATION (lan&lon) WITHOUT BRACKETS[]?&units=si&exclude=hourly,currently,minutely,alerts,flags" > DS.json

# Extracting required data from both json files

jq -r '.DailyForecasts[] | .Temperature.Maximum.Value' AW.json > AW.txt
jq -r '.daily.data[] | .temperatureMax' DS.json > DS.txt
jq -r '.DailyForecasts[] | .Date' AW.json > Datum.txt

# saving data to arrays

readarray awArray < AW.txt
#echo "${awArray[@]}" | sed 's/^[ \t]*//'

readarray dsArray < DS.txt
#echo "${dsArray[@]}" | sed 's/^[ \t]*//'

readarray datArray < Datum.txt

# difference in temperature

echo
echo difference of temperature in comparison of DarkSky on Accuweather:
	paste <(printf %s "Datum") <(printf %s "Dark Sky") <(printf %s "Accuweather") <(printf %s "Razlika u temperaturi") 
echo
for i in 0 1 2 3 4
do	
	echo --------------------------------------------------------------------------------
	dat=${datArray[i]}
	val1=${dsArray[i]}
	val2=${awArray[i]} 
	rez=$( echo $val1 - $val2 | bc -l) 
	paste <(printf %s "$dat") <(printf %s "$val1") <(printf %s "$val2") <(printf %s "$rez") 
done
