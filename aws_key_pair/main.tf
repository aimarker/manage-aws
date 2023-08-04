# Resource to generate tls_private_key
resource "tls_private_key" "symmetric_key" {
  algorithm   = var.algorithm
  rsa_bits    = var.rsa_bits
  ecdsa_curve = var.ecdsa_curve
}

# Resource to generate public key
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.symmetric_key.public_key_openssh
}

# Resource to save the generated pair in file
resource "local_sensitive_file" "pem_file" {
  content  = tls_private_key.symmetric_key.private_key_pem
  filename = var.pem_file_name
}

