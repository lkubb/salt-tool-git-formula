# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as git with context %}

include:
  - {{ tplroot }}.package


{%- for user in git.users | rejectattr('xdg', 'sameas', false) %}

{%-   set user_default_conf = user.home | path_join(git.lookup.paths.confdir, git.lookup.paths.conffile) %}
{%-   set user_xdg_confdir = user.xdg.config | path_join(git.lookup.paths.xdg_dirname) %}
{%-   set user_xdg_conffile = user_xdg_confdir | path_join(git.lookup.paths.xdg_conffile) %}

# workaround for file.rename not supporting user/group/mode for makedirs
git has its config dir in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.directory:
    - name: {{ user_xdg_confdir }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0700'
    - makedirs: true

Existing git configuration is migrated for user '{{ user.name }}':
  file.rename:
    - name: {{ user_xdg_conffile }}
    - source: {{ user_default_conf }}
    - require:
      - git has its config dir in XDG_CONFIG_HOME for user '{{ user.name }}'
    - require_in:
      - git setup is completed

git has its config file in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.managed:
    - name: {{ user_xdg_conffile }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: false
    - makedirs: true
    - mode: '0600'
    - dir_mode: '0700'
    - require:
      - Existing git configuration is migrated for user '{{ user.name }}'
    - require_in:
      - git setup is completed
{%- endfor %}
