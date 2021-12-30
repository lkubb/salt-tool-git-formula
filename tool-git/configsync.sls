{%- from 'tool-git/map.jinja' import git %}

{%- for user in git.users | selectattr('dotconfig') %}
Git configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user._git.confdir }}
    - source:
      - salt://user/{{ user.name }}/dotfiles/git
      - salt://user/dotfiles/git
    - context:
        user: {{ user }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
    - file_mode: keep
    - dir_mode: '0700'
    - makedirs: True
{%- endfor %}
