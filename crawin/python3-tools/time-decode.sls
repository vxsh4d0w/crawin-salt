# Name: 
# Website: 
# Description: 
# Category: 
# Author: 
# License: 
# Notes: 

include:
  - crawin.packages.python3

time-decode:
  pip.installed:
    - bin_env: 'C:\Program Files\Python310\python.exe'
    - require:
      - sls: crawin.packages.python3
