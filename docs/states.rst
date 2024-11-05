Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``tool_git``
~~~~~~~~~~~~
*Meta-state*.

Performs all operations described in this formula according to the specified configuration.


``tool_git.package``
~~~~~~~~~~~~~~~~~~~~
Installs the git package only.


``tool_git.xdg``
~~~~~~~~~~~~~~~~
Ensures git adheres to the XDG spec
as best as possible for all managed users.
Has a dependency on `tool_git.package`_.


``tool_git.config``
~~~~~~~~~~~~~~~~~~~
Manages the git package configuration by

* recursively syncing from a dotfiles repo
* setting configuration values defined in the parameters

Has a dependency on `tool_git.package`_.


``tool_git.config.file``
~~~~~~~~~~~~~~~~~~~~~~~~



``tool_git.config.sync``
~~~~~~~~~~~~~~~~~~~~~~~~
Syncs the git package configuration
with a dotfiles repo.
Has a dependency on `tool_git.package`_.


``tool_git.clean``
~~~~~~~~~~~~~~~~~~
*Meta-state*.

Undoes everything performed in the ``tool_git`` meta-state
in reverse order.


``tool_git.package.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes the git package.
Has a dependency on `tool_git.config.clean`_.


``tool_git.xdg.clean``
~~~~~~~~~~~~~~~~~~~~~~
Removes git XDG compatibility crutches for all managed users.


``tool_git.config.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~
Removes the configuration of the git package.


