<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.66.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_naming"></a> [naming](#module\_naming) | ./modules/naming | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_number_of_azs"></a> [number\_of\_azs](#input\_number\_of\_azs) | The number of AZs inside the VPC | `number` | n/a | yes |
| <a name="input_private_subnets_id"></a> [private\_subnets\_id](#input\_private\_subnets\_id) | The subnet ids of the private subnets provided statically | `list(any)` | `[]` | no |
| <a name="input_project"></a> [project](#input\_project) | The name of the project/app | `string` | n/a | yes |
| <a name="input_project_prefix"></a> [project\_prefix](#input\_project\_prefix) | The prefix for the resources name | `string` | n/a | yes |
| <a name="input_project_short"></a> [project\_short](#input\_project\_short) | Abbreviation of the project name | `string` | n/a | yes |
| <a name="input_public_subnets_id"></a> [public\_subnets\_id](#input\_public\_subnets\_id) | The subnet ids of the public subnets provided statically | `list(any)` | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | The region for the resources to be created in | `string` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The CIDR range for the vpc | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The vpc id provided statically | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_tags"></a> [default\_tags](#output\_default\_tags) | The default tags provided by the naming module based on the input values |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The Id of the VPC |
<!-- END_TF_DOCS -->
