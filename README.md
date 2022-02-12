# `git` Formula
Sets up, configures and updates `git` client.

## Usage
Applying `tool-git` will make sure `git` is configured as specified. Existing configuration will not be replaced. If you want to make sure everything is up to date, run `tool-git.update`. This will sync dotconfig and install the latest `git`.

## Configuration
### Pillar
#### General `tool` architecture
Since installing user environments is not the primary use case for saltstack, the architecture is currently a bit awkward. All `tool` formulas assume running as root. There are three scopes of configuration:
1. per-user `tool`-specific
  > e.g. generally force usage of XDG dirs in `tool` formulas for this user
2. per-user formula-specific
  > e.g. setup this tool with the following configuration values for this user
3. global formula-specific (All formulas will accept `defaults` for `users:username:formula` default values in this scope as well.)
  > e.g. setup system-wide configuration files like this

**3** goes into `tool:formula` (e.g. `tool:git`). Both user scopes (**1**+**2**) are mixed per user in `users`. `users` can be defined in `tool:users` and/or `tool:formula:users`, the latter taking precedence. (**1**) is namespaced directly under `username`, (**2**) is namespaced under `username: {formula: {}}`.

```yaml
tool:
######### user-scope 1+2 #########
  users:                         #
    username:                    #
      xdg: true                  #
      dotconfig: true            #
      formula:                   #
        config: value            #
####### user-scope 1+2 end #######
  formula:
    formulaspecificstuff:
      conf: val
    defaults:
      yetanotherconfig: somevalue
######### user-scope 1+2 #########
    users:                       #
      username:                  #
        xdg: false               #
        formula:                 #
          otherconfig: otherval  #
####### user-scope 1+2 end #######
```


#### User-specific
The following shows an example of `tool-git` pillar configuration. Namespace it to `tool:users` and/or `tool:git:users`.
```yaml
user:
  xdg: true   # force $XDG_CONF_HOME/git/config instead of ~/.gitconfig
  # sync this user's config from a dotfiles repo available as
  # salt://dotconfig/<user>/git or salt://dotconfig/git
  dotconfig:              # can be bool or mapping
    file_mode: '0600'     # default: keep destination or salt umask (new)
    dir_mode: '0700'      # default: 0700
    clean: false          # delete files in target. default: false
  git:        # global git config
    user.name: Mister Robot
    user.email: elliotalderson@protonmail.ch
    user.signingkey: 0xB178523B9C2FA3D1
    credential.helper: cache --timeout=900 # 15m is default. osxkeychain on macos, manager on windows, many more to discover
    core.editor: vim
    gpg.sign: false
```

#### Formula-specific
```yaml
tool:
  git:
    system:       # system-wide gitconfig file @TODO
      gpg.sign: true
    defaults:     # default git config values for users go here
      gpg.sign: false
```

### Dotfiles
`tool-git.configsync` will recursively apply templates from 

- `salt://dotconfig/<user>/git` or
- `salt://dotconfig/git`

to the user's config dir for every user that has it enabled (see `user.dotconfig`). The target folder will not be cleaned by default (ie files in the target that are absent from the user's dotconfig will stay).

## Reference
* https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration
* `man git-config` (exhaustive)
