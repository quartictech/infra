# Terraform

This is the Terraform for all of our GCloud infrastructure.  The arrangement is summarised in the image below.

![Project layout](https://github.com/quartictech/infra/blob/feature/cleanup/diagrams/infra-layout.png)


## Project layout

There are three main projects:

- **Staging** and **Prod** each host a K8S cluster, with an associated static external IP.
- **Global** hosts DNS (with A records for the clusters, along with all the other records we need), which Namecheap's
  NS records are set to point to.  It also hosts our canonical Docker container registry, and a `circleci` service
  account intended for CircleCI builds.

There are two auxiliary projects:

- **Admin** hosts a `terraform` service account for automated Terraform deploys, and a bucket for holding Terraform state.
- **Bottom turtle** hosts only a bucket for [bootstrapping](#bootstrapping) Terraform state.


## IAM

The three main projects are owned by the `terraform` service account, but are otherwise completely locked down.

CircleCI needs to be able to push Docker images and deploy containers to the K8S clusters, so has the relevant roles.

Each K8S cluster runs as a dedicated `cluster` service account, which has permissions to read the **Global** container
registry.


## Execution

Terraform is executed on CircleCI via the `terraform` service account, and stores its state in the associated GCS
bucket.  Each of the three main projects is deployed via a separate Terraform configuration with separate state, to
avoid [issues][1] where modifying **Staging** nukes **Prod**.

The **Global** configuration is run first, as the other configurations rely on it as a [data source][2] and also
modify its DNS and IAM configurations.

[1]: https://charity.wtf/2016/03/30/terraform-vpc-and-why-you-want-a-tfstate-file-per-env/
[2]: https://www.terraform.io/docs/providers/terraform/index.html


## Bootstrapping

The configuration for the **Admin** project is bootstrapped by a separate Terraform configuration in the
`bootstrapping/`  directory.  This must be run first:

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


### Bootstrapping the bootstrapping

The bootstrapping Terraform state is stored in a bucket in the **Bottom turtle** project, which isn't Terraform-managed.
This project had to be created manually:

```
gcloud projects create quartic-bottom-turtle --name "Quartic - Bottom turtle" --organization ${ORG_ID}
gsutil mb -p quartic-bottom-turtle -c regional -l europe-west2 gs://bottom-turtle.quartic.io
gsutil versioning set on gs://bottom-turtle.quartic.io
```