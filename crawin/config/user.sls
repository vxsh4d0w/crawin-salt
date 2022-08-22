{% set user = salt['pillar.get']('crawin_user', 'forensics') %}
{% set all_users = salt['user.list_users']() %}
{% if user in all_users %}
  {% set home = salt['user.info'](user).home %}

crawin-user-{{ user }}:
  user.present:
    - name: {{ user }}
    - home: {{ home }}
{% else %}

{% set home = "C:\\Users\\" + user %}

crawin-user-{{ user }}:
  user.present:
    - name: {{ user }}
    - fullname: {{ user }}
    - home: {{ home }}
    - password: forensics
    - groups:
      - Administrators
      - Users
{% endif %}
