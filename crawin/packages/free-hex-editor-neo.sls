# Name: Hex Editor Neo (Free)
# Website: https://www.hhdsoftware.com
# Description: Hex Editor
# Category: Raw Parsers / Decoders
# Author: HHD Software
# License: EULA (https://www.hhdsoftware.com/company/terms-of-use)
# Version: 7.09.01.8132
# Notes: 

{% set user = salt['pillar.get']('crawin_user', 'forensics') %}
{% set all_users = salt['user.list_users']() %}
{% if user in all_users %}
  {% set home = salt['user.info'](user).home %}
{% else %}
{% set home = "C:\\Users\\" + user %}
{% endif %}

include:
  - crawin.config.user

free-hex-editor-neo:
  pkg.installed

free-hex-editor-icon:
  file.absent:
    - names:
      - '{{ home }}\Desktop\Hex Editor Neo.lnk'
      - 'C:\Users\Public\Desktop\Hex Editor Neo.lnk'
    - require:
      - user: crawin-user-{{ user }}
      - pkg: free-hex-editor-neo
