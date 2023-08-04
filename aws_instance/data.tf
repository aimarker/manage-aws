
################################################################################
# Instance
################################################################################
data "aws_ssm_parameter" "this" {
  count = local.create ? 1 : 0

  name = var.ami_ssm_parameter
}

data "aws_partition" "current" {}

################################################################################
# IAM Role / Instance Profile
################################################################################

data "aws_iam_policy_document" "assume_role_policy" {
  count = var.create && var.create_iam_instance_profile ? 1 : 0

  statement {
    sid     = "EC2AssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
    }
  }
}
