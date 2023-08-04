locals {
  region_name = "ap-south-1"
  access_key  = "<aws access key>"
  secret_key  = "<aws secret key>"

  name = "AIMLOps"

  instance_name = "fast-api-server"
  instance_type = "t3.micro"
  use_public_ip = true
  region        = "ap-south-1"

  pem_file_name = "ec2_instance.pem"

  vpc_name = "aws_vpc"
  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 1)

  tags = {
    Name    = local.name
    Example = local.name
  }
}
