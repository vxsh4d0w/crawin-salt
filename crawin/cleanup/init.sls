# Restart explorer to get rid of graphical anomalies after debloat
# Delete the C:\salt directory which contains the tempdownloads
{% set user = salt['pillar.get']('crawin_user', 'forensics') %}
{% set all_users = salt['user.list_users']() %}
{% if user in all_users %}
  {% set home = salt['user.info'](user).home %}
{% else %}
{% set home = "C:\\Users\\" + user %}
{% endif %}

include:
  - crawin.config.user

cleanup-restart-explorer:
  cmd.run:
    - name: 'Stop-Process -ProcessName "explorer"'
    - shell: powershell

cleanup-delete-salt-temp-files:
  file.absent:
    - name: 'C:\salt'

desktop-cleanup:
  file.absent:
    - names:
      - 'C:\Users\Public\Desktop\desktop.ini'
      - '{{ home }}\Desktop\desktop.ini'
    - require:
      - user: crawin-user-{{ user }}
      - cmd: cleanup-restart-explorer

disk-cleanup:
  cmd.run:
    - name: 'C:\Windows\System32\cleanmgr.exe /d C: /autoclean'
    - shell: cmd
