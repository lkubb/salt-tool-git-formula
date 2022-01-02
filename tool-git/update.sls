{%- from 'tool-git/map.jinja' import git %}

{%- if git.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') %}
include:
  - .configsync
{%- endif %}

Git is updated to latest package:
{%- if grains['kernel'] == 'Darwin' %}
  pkg.installed: # assumes homebrew as package manager. homebrew always installs the latest version, mac_brew_pkg does not support upgrading a single package
{%- else %}
  pkg.latest:
{%- endif %}
    - name: git
