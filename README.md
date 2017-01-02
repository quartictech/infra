# Quartic infrastructure

This repo contains our infrastructure stuff - Ansible configuration for hosts, Kubernetes config, scheduled jobs.

## Ansible

Can be found in the `ansible` directory.  You can do something like this:

You can do something like this:

    cd ansible
    ansible-playbook webserver.yml -i <HOST_IP>,

**Note:** The trailing `,` is important.

### Prerequisites

You'll need a local installation of Ansible:

    brew install ansible
