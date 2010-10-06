#!/usr/bin/env bash

curl http://localhost:4567/ > index.html
curl http://localhost:4567/map.js > map.js
mkdir -p lac/
mkdir -p afr/
mkdir -p eap/
curl http://localhost:4567/lac/haiti > lac/haiti.html
curl http://localhost:4567/lac/bolivia > lac/bolivia.html
curl http://localhost:4567/afr/kenya > afr/kenya.html
curl http://localhost:4567/eap/philippines > eap/philippines.html
curl http://localhost:4567/about > about.html
