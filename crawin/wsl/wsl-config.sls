{% set PROGRAMDATA = salt['environ.get']('PROGRAMDATA') %}
{% set START_MENU = PROGRAMDATA + '\Microsoft\Windows\Start Menu\Programs' %}
{% set inpath = salt['pillar.get']('inpath', 'C:\standalone') %}
{% set hash = '4ed521a6f727c2a5352b2d28e28cfd8639e9c8cbc1b7a35aa7e003464c4fc139' %}
{% set castver = '0.14.0' %}

include:
  - crawin.wsl.wsl2-update
  - crawin.config.user

wsl-config-version:
  cmd.run:
    - name: 'wsl --set-default-version 2'
    - shell: cmd
    - require:
      - sls: crawin.wsl.wsl2-update

{% if salt['file.file_exists']('C:\\salt\\tempdownload\\CRA-WIN-20.04.tar') and salt['file.check_hash']('C:\\salt\\tempdownload\\CRA-WIN-20.04.tar', hash)%}

wsl-template-already-downloaded:
  test.nop

{% else %}

wsl-get-template:
  file.managed:
    - name: 'C:\salt\tempdownload\CRA-WIN-20.04.tar'
    - source: https://sourceforge.net/projects/winfor/files/wsl/WIN-FOR-20.04.tar/download
    - source_hash: sha256={{ hash }}
    - makedirs: True

{% endif %}

wsl-make-install-directory:
  file.directory:
    - name: '{{ inpath }}\wsl\'
    - win_inheritance: True
    - makedirs: True

wsl-import-template:
  cmd.run:
    - name: 'wsl --import CRA-WIN {{ inpath }}\wsl\ C:\salt\tempdownload\CRA-WIN-20.04.tar'
    - shell: cmd
    - require:
      - file: wsl-make-install-directory

wsl-get-cast:
  cmd.run:
    - name: 'wsl echo forensics | wsl sudo -S wget -O /tmp/cast_v{{ castver }}_linux_amd64.deb https://github.com/ekristen/cast/releases/download/v{{ castver }}/cast_v{{ castver }}_linux_amd64.deb'
    - shell: cmd
    - require:
      - cmd: wsl-import-template

wsl-install-cast:
  cmd.run:
    - name: 'wsl echo forensics | wsl sudo -S apt-get install -y /tmp/cast_v{{ castver }}_linux_amd64.deb'
    - shell: cmd
    - require:
      - cmd: wsl-get-cast

wsl-install-sift:
  cmd.run:
    - name: 'wsl echo forensics | wsl sudo -S cast install --mode server --user forensics sift'
    - shell: cmd
    - require:
      - cmd: wsl-install-cast

wsl-install-remnux:
  cmd.run:
    - name: 'wsl echo forensics | wsl sudo -S cast install --mode addon --user forensics remnux'
    - shell: cmd
    - require:
      - cmd: wsl-install-sift

wsl-shortcut:
  file.shortcut:
    - name: '{{ PROGRAMDATA }}\Microsoft\Windows\Start Menu\Programs\WSL.lnk'
    - target: 'C:\Windows\System32\wsl.exe'
    - force: True
    - working_dir: 'C:\Windows\System32\'
    - makedirs: True
    - require:
      - cmd: wsl-config-version
      - file: wsl-make-install-directory
      - cmd: wsl-import-template

wsl-portals-shortcut:
  file.copy:
    - name: '{{ inpath }}\Portals\Terminals\'
    - source: '{{ START_MENU }}\WSL.lnk'
    - preserve: True
    - subdir: True
    - require:
      - cmd: wsl-config-version
      - file: wsl-make-install-directory
      - cmd: wsl-import-template

wsl-delete-template:
  file.absent:
    - name: 'C:\salt'
    - require:
      - cmd: wsl-config-version
      - file: wsl-make-install-directory
      - cmd: wsl-import-template
