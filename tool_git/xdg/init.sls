# vim: ft=sls

{#-
    Ensures git adheres to the XDG spec
    as best as possible for all managed users.
    Has a dependency on `tool_git.package`_.
#}

include:
  - .migrated
