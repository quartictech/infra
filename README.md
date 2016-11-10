# Quartic infrastructure

This repo contains our infrastructure stuff - Ansible configuration for hosts, Docker-Compose files, Kubernetes config.

## Ansible

Can be found in the `ansible` directory.  You can do something like this:

You can do something like this:

    cd ansible
    ansible-playbook ci.yml -i <HOST_IP>,

**Note:** The trailing `,` is important.

### Prerequisites

You'll need a local installation of Ansible:

    brew install ansible

## Docker-Compose

These are the Docker-Compose stack definitions.
