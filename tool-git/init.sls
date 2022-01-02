{%- from 'tool-git/map.jinja' import git %}

include:
  - .package
{%- if git.users | rejectattr('xdg', 'sameas', False) %}
  - .xdg
{%- endif %}
{%- if git.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') %}
  - .configsync
{%- endif %}
{%- if git.users | selectattr('git.config', 'defined') %}
  - .config
{%- endif %}
