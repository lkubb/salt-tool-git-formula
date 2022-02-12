{%- from 'tool-git/map.jinja' import git %}

{%- for user in git.users | selectattr('dotconfig', 'defined') | selectattr('dotconfig') %}
  {%- set dotconfig = user.dotconfig if dotconfig is mapping else {} %}

Git configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user._git.confdir }}
    - source:
      - salt://dotconfig/{{ user.name }}/git
      - salt://dotconfig/git
    - context:
        user: {{ user }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
  {%- if dotconfig.get('file_mode') %}
    - file_mode: '{{ dotconfig.file_mode }}'
  {%- endif %}
    - dir_mode: '{{ dotconfig.get('dir_mode', '0700') }}'
    - clean: {{ dotconfig.get('clean', False) | to_bool }}
    - makedirs: True
{%- endfor %}
