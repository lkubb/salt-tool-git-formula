# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as git with context %}

include:
  - .package
{%- if git.users | rejectattr('xdg', 'sameas', False) | list %}
  - .xdg
{%- endif %}
{%- if git.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') | list %}
  - .configsync
{%- endif %}
{%- if git.users | selectattr('git.config', 'defined') | list %}
  - .config
{%- endif %}
