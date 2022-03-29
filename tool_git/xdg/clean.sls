# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as git with context %}

{%- for user in git.users | rejectattr('xdg', 'sameas', False) | list %}

git configuration is cluttering $HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user.home | path_join(git.lookup.config.default_conffile) }}
    - source: {{ user.xdg.config | path_join(tplroot[5:], git.lookup.config.default_xdg_conffile) }}

git does not have its config folder in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.absent:
    - name: {{ user.xdg.config | path_join(tplroot[5:]) }}
    - require:
      - git configuration is cluttering $HOME for user '{{ user.name }}'
{%- endfor %}
