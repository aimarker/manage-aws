variable "algorithm" {
  description = "Algorithm to generate the key-pair"
  type        = string
  default     = "RSA"
}

variable "rsa_bits" {
  description = "Key length"
  type        = number
  default     = 4096
}

variable "ecdsa_curve" {
  description = "Name of the elliptic curve to use : P224, P256, P384, P521"
  type        = string
  default     = null
}

variable "key_name" {
  description = "Name of the KEY"
  type        = string
  default     = null
}

variable "pem_file_name" {
  description = "Pem file name"
  type        = string
  default     = null
}
