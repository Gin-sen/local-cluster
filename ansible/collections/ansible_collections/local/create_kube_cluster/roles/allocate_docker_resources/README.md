Local.Create_kube_cluster Allocate Docker Resources Role
========================

A brief description of the role is here.

Requirements
------------

Any prerequisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. host vars, group vars, etc.) should be mentioned here as well.

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```yaml
- name: Execute tasks on servers
  hosts: servers
  roles:
    - role: local.create_kube_cluster.allocate_docker_resources
      ram: 12Go
      cpu: 8
```

Another way to consume this role would be:

```yaml
- name: Initialize the allocate_docker_resources role from local.create_kube_cluster
  hosts: servers
  gather_facts: false
  tasks:
    - name: Trigger invocation of allocate_docker_resources role
      ansible.builtin.include_role:
        name: local.create_kube_cluster.allocate_docker_resources
      vars:
        ram: 12Go
        cpu: 8
```

License
-------

# TO-DO: Update the license to the one you want to use (delete this line after setting the license)
BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
