variable "key_name" {
  description = "The name of the existing EC2 Key Pair to access the instances"
  type        = string
  default     = "Virginia"
}

variable "subnet_id" {
  description = "The Subnet ID where EC2 instances will be launched"
  type        = string
  default     = "subnet-03edc94baf3c761fe"
}
