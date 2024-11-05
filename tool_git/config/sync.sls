# vim: ft=sls

{#-
    Syncs the git package configuration
    with a dotfiles repo.
    Has a dependency on `tool_git.package`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as git with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch %}


{%- for user in git.users | selectattr("dotconfig", "defined") | selectattr("dotconfig") %}
{%-   set dotconfig = user.dotconfig if user.dotconfig is mapping else {} %}

git configuration is synced for user '{{ user.name }}':
  file.recurse:
    - name: {{ user["_git"].confdir }}
    - source: {{ files_switch(
                ["git"],
                default_files_switch=["id", "os_family"],
                override_root="dotconfig",
                opt_prefixes=[user.name]) }}
    - context:
        user: {{ user | json }}
    - template: jinja
    - user: {{ user.name }}
    - group: {{ user.group }}
{%-   if dotconfig.get("file_mode") %}
    - file_mode: '{{ dotconfig.file_mode }}'
{%-   endif %}
    - dir_mode: '{{ dotconfig.get("dir_mode", "0700") }}'
    - clean: {{ dotconfig.get("clean", false) | to_bool }}
    - makedirs: true
{%- endfor %}
