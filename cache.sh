#!/usr/bin/env bash

#curl http://localhost:4567/ > index.html
#curl http://localhost:4567/404 > 404.html
#curl http://localhost:4567/500 > 500.html
curl http://localhost:4567/map.js > map.js
#mkdir -p lac/
#mkdir -p afr/
#mkdir -p eap/
#mkdir -p sar/
curl http://localhost:4567/lac/haiti > lac/haiti.html
curl http://localhost:4567/lac/bolivia > lac/bolivia.html
curl http://localhost:4567/afr/kenya > afr/kenya.html
#curl http://localhost:4567/lac > lac/index.html
#curl http://localhost:4567/afr > afr/index.html
#cp lac/index.html lac.html
#cp afr/index.html afr.html
curl http://localhost:4567/eap/philippines > eap/philippines.html
#curl http://localhost:4567/about > about.html
curl http://localhost:4567/sar/nepal > sar/nepal.html

#mkdir -p productline/PE/
#curl http://localhost:4567/productline/PE/charts > productline/PE/charts.html
#mkdir -p productline/CN/
#curl http://localhost:4567/productline/CN/charts > productline/CN/charts.html
