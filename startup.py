#!/usr/bin/python
import configparser
import os
HOT_DEPLOYMENT_DIR = '/hot-deploy/'

config = configparser.ConfigParser()
config.read('/env/prod1/server1/config/repo/pickup.conf')
if not config.has_section('hot-deploy.user.hot_service'):
    config.add_section('hot-deploy.user.hot_service')

config.set('hot-deploy.user.hot_service', 'pickup_from', HOT_DEPLOYMENT_DIR)

with open("/env/prod1/server1/config/repo/pickup.conf", 'w') as configration:
   config.write(configration)