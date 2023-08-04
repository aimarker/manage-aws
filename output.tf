# output "cloud9_url" {
#   value = "https://${local.region_name}.console.aws.amazon.com/cloud9/ide/${aws_cloud9_environment_ec2.cloud9_server.id}"
# }

# output "ec2_public_ipv4" {
#   value = "ssh -i ${local.pem_file_name} ubuntu@${module.ec2.public_dns}"
# }
