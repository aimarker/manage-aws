output "ubuntu_20_04_id" {
  description = "Ubuntu linux aws_ami id for 20.04 version"
  value       = data.aws_ami.ubuntu.id
}

output "aws_linux_id" {
  description = "Amazon linux aws_ami id"
  value       = data.aws_ami.amzlinux.id
}
