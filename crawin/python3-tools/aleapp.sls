# Name: ALEAPP
# Website: https://github.com/abrignoni/aleapp
# Description: Android Logs Events and Protobuf Parser
# Category: Mobile Analysis
# Author: Alexis Brignoni
# License: MIT License (https://github.com/abrignoni/ALEAPP/blob/master/LICENSE)
# Version: 3.1.1
# Notes: 

{% set PROGRAMDATA = salt['environ.get']('PROGRAMDATA') %}

include:
  - crawin.packages.python3
  - crawin.packages.git

crawin-python3-aleapp-source:
  git.latest:
    - name: https://github.com/abrignoni/aleapp
    - target: 'C:\standalone\aleapp'
    - rev: master
    - force_clone: True
    - force_reset: True
    - require:
      - sls: crawin.packages.git

crawin-python3-aleapp-requirements:
  pip.installed:
    - requirements: 'C:\standalone\aleapp\requirements.txt'
    - bin_env: 'C:\Program Files\Python310\python.exe'
    - require:
      - git: crawin-python3-aleapp-source
      - sls: crawin.packages.python3

crawin-python3-aleapp-header:
  file.prepend:
    - names:
      - 'C:\standalone\aleapp\aleapp.py'
      - 'C:\standalone\aleapp\aleappGUI.py'
    - text: '#!/usr/bin/python3'
    - require:
      - git: crawin-python3-aleapp-source
      - pip: crawin-python3-aleapp-requirements

crawin-python3-aleapp-env-vars:
  win_path.exists:
    - name: 'C:\standalone\aleapp\'

crawin-python3-aleapp-icon:
  file.managed:
    - name: 'C:\standalone\abrignoni-logo.ico'
    - source: salt://crawin/files/abrignoni-logo.ico
    - source_hash: sha256=97ca171e939a3e4a3e51f4a66a46569ffc604ef9bb388f0aec7a8bceef943b98
    - makedirs: True

crawin-python3-aleapp-gui-shortcut:
  file.shortcut:
    - name: '{{ PROGRAMDATA }}\Microsoft\Windows\Start Menu\Programs\ALEAPP-GUI.lnk'
    - target: 'C:\standalone\aleapp\aleappGUI.py'
    - force: True
    - working_dir: 'C:\standalone\aleapp\'
    - icon_location: 'C:\standalone\abrignoni-logo.ico'
    - makedirs: True
    - require:
      - git: crawin-python3-aleapp-source
      - pip: crawin-python3-aleapp-requirements
      - file: crawin-python3-aleapp-header
      - win_path: crawin-python3-aleapp-env-vars
      - file: crawin-python3-aleapp-icon
