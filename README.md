sudoers Cookbook
================

This is a wrapper cookbook for upstream sudo cookbook.  It will allow setting
sudo through data bags.

Requirements
------------

Opscode sudo cookbook (https://github.com/opscode-cookbooks/sudo)

Attributes
----------

- `node['sudoers']['databag']` - name of databag to grab sudoers from (default: `sudoers`)

Usage
-----

Create a databag with the relevant contents.  Valid options match sudo cookbook LWRP:

- `user' - Username (or group if prepended with %) for sudo
- `group` - Group for sudo (automatically prepends %). `user` option trumps this if present.
- `nopasswd` - Supply a password to invoke sudo (default: false)
- `runas` - User allowed to sudo to (default: root)
- `host` - Hostname to allow sudo on
- `commands` - An array of commands allowed for sudo
- `action` - Whether to add or remove this sudo access (Default: add). Set to `remove` to delete.

#### Examples:

```json
{
  "id": "sudouser",
  "user": "sudouser",
  "nopasswd": "true",
  "commands": [ "/bin/mkdir", "/bin/rmdir", "/bin/cp" ]
}
```

```json
{
  "id": "netops",
  "group": "netops",
  "runas": "netmgr",
  "commands": "/usr/bin/snmpconf"
}
```

This will remove the sudoers file with the named `id`:
```json
{
    "id": "sudouser",
    "action": "remove"
}

Contributing
------------
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
- Author:: Scott Lampert <scott@lampert.org>

```text
Copyright 2014, Scott Lampert

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
