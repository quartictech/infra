# Quartic infrastructure

This repo contains our infrastructure stuff - Docker image definitions, Ansible
configuration for hosts, etc.

## Docker images

These are **non-sensitive** (i.e. non-product) images that we publish to Docker
Hub as public repositories.  This is done by Gitlab CI.

- `uber-builder` - Defines the environment that Gitlab CI uses to build Weyl.

## Ansible

Can be found in the `ansible` directory.  You can do something like this:

You can do something like this:

    cd ansible
    ansible-playbook ci.yml -i <HOST_IP>,

**Note:** The trailing `,` is important.

### Prerequisites

You'll need a local installation of Ansible:

    brew install ansible
