{%- from 'tool-git/map.jinja' import git %}

include:
  - .package
{%- if git.users | rejectattr('xdg', 'sameas', False) %}
  - .xdg
{%- endif %}
{%- if git.users | selectattr('dotconfig') %}
  - .configsync
{%- endif %}
{%- if git.users | selectattr('git') %}
  - .config
{%- endif %}
