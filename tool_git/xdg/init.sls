# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as git with context %}


include:
  - {{ tplroot }}.package

{%- for user in git.users | rejectattr('xdg', 'sameas', False) | list %}

git has its config dir in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.directory:
    - name: {{ user.xdg.config | path_join(tplroot[5:]) }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0700'
    - makedirs: true
    - onlyif:
      - test -e '{{ user.home | path_join(git.lookup.config.default_conffile) }}'

Existing git configuration is migrated for user '{{ user.name }}':
  file.rename:
    - name: {{ user.xdg.config | path_join(tplroot[5:], git.lookup.config.default_xdg_conffile) }}
    - source: {{ user.home | path_join(git.lookup.config.default_conffile) }}
    - require:
      - git has its config dir in XDG_CONFIG_HOME for user '{{ user.name }}'
    - require_in:
      - git setup is completed

git has its config file in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.managed:
    - name: {{ user.xdg.config | path_join(tplroot[5:], git.lookup.config.default_xdg_conffile) }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: False
    - makedirs: True
    - mode: '0600'
    - dir_mode: '0700'
    - require_in:
      - git setup is completed
{%- endfor %}
