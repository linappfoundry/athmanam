#!/usr/bin/env python

import os
import shutil

script_path = os.path.dirname(os.path.realpath(__file__))
home_dir = os.environ['HOME']

#shutil.rmtree(home_dir + "/.linappfoundry")

if os.path.isdir(home_dir + "/.linappfoundry" ) == False:
    os.mkdir(home_dir + "/.linappfoundry")

if os.path.isdir(home_dir + "/.linappfoundry/athmanam" ) == False:
    os.mkdir(home_dir + "/.linappfoundry/athmanam")

if os.path.isdir(home_dir + "/.linappfoundry/athmanam/html" ) == True:
    shutil.rmtree(home_dir + "/.linappfoundry/athmanam/html")

shutil.copytree(script_path + "/html", home_dir + "/.linappfoundry/athmanam/html")