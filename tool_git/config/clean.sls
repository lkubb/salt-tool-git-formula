# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as git with context %}


{%- for user in git.users %}

git config file is cleaned for user '{{ user.name }}':
  file.absent:
    - name: {{ user['_git'].conffile }}

{%-   if user.xdg %}

git config dir is absent for user '{{ user.name }}':
  file.absent:
    - name: {{ user['_git'].confdir }}
{%-   endif %}
{%- endfor %}
