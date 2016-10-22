# Quartic infrastructure

This repo contains our infrastructure stuff - Docker image definitions, Ansible
configuration for hosts, etc.

## Docker images

These are non-product images that we publish to Google Container Registry via CircleCI.

- `data-worker` - Defines environment for processing raw datasets.

## Ansible

Can be found in the `ansible` directory.  You can do something like this:

You can do something like this:

    cd ansible
    ansible-playbook ci.yml -i <HOST_IP>,

**Note:** The trailing `,` is important.

### Prerequisites

You'll need a local installation of Ansible:

    brew install ansible
