{%- from 'tool-git/map.jinja' import git %}

{%- macro gitset(user, conf_name, conf_value) %}
git configuration value '{{ conf_name  }}' is set for user '{{ user }}':
  git.config_set:
    - name: {{ conf_name }}
  {%- if conf_value is iterable and conf_value is not string %}
    - multivar: {{ conf_value | json }}
  {%- else %}
    - value: {{ conf_value | json }}
  {%- endif %}
    - user: {{ user }}
    - global: true
    - require:
      - pkg: git
{%- endmacro %}

include:
  - .package

{%- for user in git.users %}
  {%- for conf_name, conf_value in user.git.items() %}
{{ gitset(user.name, conf_name, conf_value) }}
  {%- endfor %}
{%- endfor %}
