module "efs" {
  source  = "terraform-aws-modules/efs/aws"
  version = "1.6.3"

  name             = local.efs.name
  creation_token   = local.efs.creation_token
  encrypted        = local.efs.encrypted
  performance_mode = local.efs.performance_mode #generalPurpose is the default value. Can also be set to maxIO

  lifecycle_policy = {
    transition_to_ia = local.efs.lifecycle_policy.transition_to_ia
  }

  attach_policy                      = true
  bypass_policy_lockout_safety_check = false

  policy_statements = [
    {
      sid     = "AllowECSTOMountEFS"
      effect  = "Allow"
      actions = ["elasticfilesystem:ClientMount", "elasticfilesystem:ClientWrite"]
      principals = [
        {
          type        = "AWS"
          identifiers = [module.ecs.services.carbone-service.task_exec_iam_role_arn]
        }
      ]
    }
  ]

  #Mount targets
  mount_targets = {
    for idx, subnet_id in local.private_subnets_id :
    idx => {
      subnet_id = subnet_id
    }
  }

  #Security Group
  security_group_vpc_id      = local.vpc_id
  security_group_name        = local.efs.security_group_name
  security_group_description = local.efs.security_group_description
  security_group_rules = {
    ecs = {
      type                     = "ingress"
      from_port                = 2049
      to_port                  = 2049
      protocol                 = "tcp"
      description              = "Allow Traffic from ECS on EFS/NFS Service port"
      source_security_group_id = module.ecs_sg.security_group_id
    }
  }

  # Access point(s)
  access_points = {
    carbone = {
      name = "carbone-access"
      posix_user = {
        gid            = 777
        uid            = 777
        secondary_gids = [888]
      }
      root_directory = {
        path = "/carbone"
        creation_info = {
          owner_gid   = 777
          owner_uid   = 777
          permissions = "755"
        }
      }
    }
  }
}
