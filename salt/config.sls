{%- macro gitset(user, conf_name, conf_value) %}
tool-git-config-for-{{ user }}-{{ conf_name | replace('.', '-') }}-set:
  git.config_set:
    - name: {{ conf_name }}
    - value: {{ conf_value }}
    - user: {{ user }}
    - global: true
    - require:
      - pkg: git
{%- endmacro %}

include:
  - ..git

{%- set default = gitdefaults if gitdefaults is defined else salt['pillar.get']('tool:git:defaults', {}) -%}

{%- for user in salt['pillar.get']('tool:git:users', []) | selectattr("config") %}
  {#- @TODO understand defaults.update and use it -#}
  {%- set user_conf = salt['defaults.merge'](defaults, user['config'], in_place=False) -%}
  {%- for conf_name, conf_value in user_conf.items() %}
{{ gitset(user.username, conf_name, conf_value) }}
  {%- endfor %}
{%- endfor %}
