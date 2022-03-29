# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as git with context %}


{%- for user in git.users | selectattr('config', 'defined') | selectattr('config') %}

git config file is cleaned for user '{{ user.name }}':
  file.absent:
    - name: {{ user['_' ~ tplroot[5:]].confdir | path_join(user['_' ~ tplroot[5:]].conffile) }}
{%- endfor %}
