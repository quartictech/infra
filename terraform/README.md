# Terraform

This is a work in progress.

![Project layout](../diagrams/project-layout.png)

## Execution

Terraform runs as a dedicated `terraform` service account under a dedicated `Quartic - Admin` project.
This account has permissions to create other projects, etc.  It stores its state on a dedicated GCS
`administration.quartic.io` bucket, with versioning enabled.

See https://cloud.google.com/storage/docs/using-object-versioning for more on accessing old versions.


## Bootstrapping

The configuration for `Quartic - Admin` is bootstrapped by a separate Terraform project in the `bootstrapping/`
directory.  This must be run first:

```
cd bootstrapping
terraform apply
```

Then we run the finaliser script, in order to do a couple of things that Terraform isn't capable of, as well as to
configure CircleCI with service-account credentials:

```
./finalise-bootstrapping.sh ${CIRCLECI_API_TOKEN}
```

where `${CIRCLECI_API_TOKEN}` is your API token that can be acquired from the CircleCI web UI.


## Outside the monad

There are some things that can't be under Terraform control, for varying reasons.


### GCloud billing

In order to associate dynamically-created projects with the Quartic billing account, the billing account had to first
be associated with the Quartic organisation.

For more information:
- https://cloud.google.com/resource-manager/docs/migrating-projects-billing#migrating_existing_billing_accounts


### Nameserver records

Our domain registrar is currently Namecheap.  Terraform currently doesn't support Namecheap configuration (although
[apparently it may one day be merged in](https://github.com/hashicorp/terraform/pull/5846)), so we have to configure
its NS records manually (everything else is handled by GCloud DNS).

We can get the Google nameservers with:

```
gcloud dns managed-zones describe ${ZONE_NAME}
```

These are then configured via the Namecheap UI, under **Domain** -> **Nameservers** -> **Custom DNS**.

For more information:

- https://cloud.google.com/dns/update-name-servers
- https://www.namecheap.com/support/knowledgebase/article.aspx/767/10/how-can-i-change-the-nameservers-for-my-domain


### Terraform bootstrapping state

The bootstrapping Terraform state is also stored in a dedicated GCS bucket under a dedicated project, neither of which
can be Terraform-managed.  Thus these had to be created manually:

```
gcloud projects create quartic-bottom-turtle --name "Quartic - Bottom turtle" --organization ${ORG_ID}
gsutil mb -p quartic-bottom-turtle -c regional -l europe-west2 gs://bottom-turtle.quartic.io
gsutil versioning set on gs://bottom-turtle.quartic.io
```