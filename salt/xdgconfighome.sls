{# (blacklist model) force XDG_CONF_HOME by default, therefore only reject users that have it explicitly disabled #}

{%- for username in salt['pillar.get']('tool:git', []) | rejectattr('xdgconfig', 'sameas', false) | map(attribute='username') %}
  {%- set home = salt['user.info'](username).home -%}
  {%- set xdgconf = salt['cmd.run']('if [ ! -z "$XDG_CONFIG_HOME" ]; then echo "${XDG_CONFIG_HOME}"; else echo "${HOME}/.config"; fi', runas=username) -%}

tool-git-migrated-to-xdg-config-dir-for-user-{{ username }}:
  file.rename:
    - name: {{ xdgconf }}/git/config
    - source: {{ home }}/.gitconfig
    - makedirs: true

tool-git-force-xdg-config-dir-for-user-{{ username }}:
  file.touch:
    - name: {{ xdgconf }}/git/config
    - makedirs: true
    - user: {{ username }}
    - group: {{ username }}
    - mode: '0600'
    - onfail:
      - tool-git-migrated-to-xdg-config-dir-for-user-{{ username }}
{%- endfor %}
