{%- from 'tool-git/map.jinja' import git %}
{# (blacklist model) force XDG_CONF_HOME by default, therefore only reject users that have it explicitly disabled #}

{%- for user in git.users | rejectattr('xdg', 'sameas', False) %}
Git configuration is migrated to XDG_CONFIG_HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user.xdg.config }}/git/config
    - source: {{ user.home }}/.gitconfig
    - makedirs: true

Git uses config file in XDG_CONFIG_HOME for user '{{ user.name }}':
  file.touch:
    - name: {{ user.xdg.config }}/git/config
    - makedirs: true
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
    - onfail:
      - Git configuration is migrated to XDG_CONFIG_HOME for user '{{ user.name }}'
{%- endfor %}
