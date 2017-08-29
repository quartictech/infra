# Terraform

This is a work in progress.


## Outside the monad

There are some things that can't be under Terraform control, for varying reasons.

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


### Terraform state

We're storing state remotely, in the `terraform.quartic.io` bucket.  This bucket has versioning enabled, so we can
debug worst-case issues.

Creation and configuration of this bucket can't be in Terraform, because one mistake could destroy our state storage.
So we configure this manually, as a one-off:

```
gsutil mb -p quartictech -c regional -l europe-west2 gs://terraform.quartic.io
gsutil versioning set on gs://terraform.quartic.io
```

See https://cloud.google.com/storage/docs/using-object-versioning for more on accessing old versions.