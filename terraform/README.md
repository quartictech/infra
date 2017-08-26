# Terraform

This is a work in progress.

## Outside the monad

We're storing state remotely, in the `terraform.quartic.io` bucket.  This bucket has versioning enabled, so we can
debug worst-case issues.

Creation and configuration of this bucket can't be in Terraform, because one mistake could destroy our state storage.
So we configure this manually, as a one-off:

```
gsutil mb -p quartictech -c regional -l europe-west2 gs://terraform.quartic.io
gsutil versioning set on gs://terraform.quartic.io
```

See https://cloud.google.com/storage/docs/using-object-versioning for more on accessing old versions.