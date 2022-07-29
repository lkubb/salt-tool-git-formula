# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as git with context %}


git is installed:
  pkg.installed:
    - name: {{ git.lookup.pkg.name }}
    - version: {{ git.get('version') or 'latest' }}
    {#- do not specify alternative return value to be able to unset default version #}

git setup is completed:
  test.nop:
    - name: Hooray, git setup has finished.
    - require:
      - pkg: {{ git.lookup.pkg.name }}
