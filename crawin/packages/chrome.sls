# Name: Google Chrome
# Website: https://www.google.com
# Description: Google Web Browser
# Category: Requirements
# Author: Google
# License: https://policies.google.com/terms
# Notes: 
# Version: 99.0.4844.82

{% set user = salt['pillar.get']('crawin_user', 'forensics') %}
{% set all_users = salt['user.list_users']() %}
{% if user in all_users %}
  {% set home = salt['user.info'](user).home %}
{% else %}
{% set home = "C:\\Users\\" + user %}
{% endif %}

include:
  - crawin.config.user

chrome:
  pkg.installed

chrome-del-shortcut:
  file.absent:
    - names:
      - 'C:\Users\Public\Desktop\Google Chrome.lnk'
      - '{{ home }}\Desktop\Google Chrome.lnk'
    - require:
      - pkg: chrome
      - user: crawin-user-{{ user }}
