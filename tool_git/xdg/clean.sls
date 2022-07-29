# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as git with context %}


{%- for user in git.users | rejectattr('xdg', 'sameas', false) %}

{%-   set user_default_conf = user.home | path_join(git.lookup.paths.confdir, git.lookup.paths.conffile) %}
{%-   set user_xdg_confdir = user.xdg.config | path_join(git.lookup.paths.xdg_dirname) %}
{%-   set user_xdg_conffile = user_xdg_confdir | path_join(git.lookup.paths.xdg_conffile) %}

git configuration is cluttering $HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user_default_conf }}
    - source: {{ user_xdg_conffile }}

git does not have its config folder in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.absent:
    - name: {{ user_xdg_confdir }}
    - require:
      - git configuration is cluttering $HOME for user '{{ user.name }}'
{%- endfor %}
