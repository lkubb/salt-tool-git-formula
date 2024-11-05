# vim: ft=sls

{#-
    Manages the git package configuration by

    * recursively syncing from a dotfiles repo
    * setting configuration values defined in the parameters

    Has a dependency on `tool_git.package`_.
#}

include:
  - .sync
  - .file
