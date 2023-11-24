# aws-s3-state terraform module

## Overview

The `aws-s3-state` terraform module has been created to easily configure [Terraform Backend](https://developer.hashicorp.com/terraform/language/settings/backends/configuration), i.e. to create resources for remote state store of terraform code - AWS S3 bucket for keeping state in the `terraform.tfstate` file and DynamoDB table for locking this state and consistency checking. Full description of the solution with explanation available [here](https://angelo-malatacca83.medium.com/aws-terraform-s3-and-dynamodb-backend-3b28431a76c1).

The remote state configuration should be done at the environment bootstrap step. It is recommended to use `aws-s3-state` terraform module per project environment. If several terraform stages exist in a given environment (e.g. `dev`) then their state should be stored within the same AWS S3 bucket (but a separate object, e.g. `terraform-${STAGE}.tfstate`) using a single DynamoDB table (but a separate item, e.g. `cosmos-dev-state/terraform-${STAGE}.tfstate-md5`). Terraform state for `aws-s3-state` terraform module is not kept anywhere except your local machine (chicken and egg problem).

As mentioned earlier this module is created only 2 resources:
- aws_s3_bucket.terraform,
- aws_dynamodb_table.terraoform.

In addition, 1 output has been created, which could be used for example for logging configuration (example of use in the `Usage` tab):

```hcl
output "tfstate_s3_bucket" {
  value = aws_s3_bucket.terraform.id
}
```

## Usage

Required vars:
- env,
- s3_bucket,
- s3_bucket_name,
- dynamodb_table.

```hcl
module "tfstate" {
    source = "github.com/Airnauts/terraform-s3-state.git?ref=v0.0.1"

    env            = "cosmos-dev"
    s3_bucket      = "cosmos-dev-state"
    s3_bucket_name = "cosmos-dev Terraform State "
    dynamodb_table = "cosmos-dev-state"
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "${module.tfstate.tfstate_s3_bucket}-log-bucket"
}
```
