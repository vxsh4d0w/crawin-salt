# Name: Rufus
# Website: https://rufus.ie
# Description: USB ISO Creator
# Category: Utilities
# Author: Pete Batard
# License: GNU General Public License v3 - https://github.com/pbatard/rufus/blob/master/LICENSE.txt
# Version: 3.21
# Notes:

{% set inpath = salt['pillar.get']('inpath', 'C:\standalone') %}
{% set version = '3.21' %}
{% set hash = 'D0554F1FC47407D678A4D8EACE607272013C475033B636BFB1824ED6B1A22E36' %}
{% set PROGRAMDATA = salt['environ.get']('PROGRAMDATA') %}

rufus-download:
  file.managed:
    - name: '{{ inpath }}\rufus\rufus-{{ version }}.exe'
    - source: 'https://github.com/pbatard/rufus/releases/download/v{{ version }}/rufus-{{ version }}.exe'
    - source_hash: sha256={{ hash }}
    - makedirs: True

crawin-standalones-rufus-shortcut:
  file.shortcut:
    - name: '{{ PROGRAMDATA }}\Microsoft\Windows\Start Menu\Programs\Rufus.lnk'
    - target: '{{ inpath }}\rufus\rufus-{{ version }}.exe'
    - force: True
    - working_dir: '{{ inpath }}\rufus\'
    - makedirs: True
    - require:
      - file: rufus-download
