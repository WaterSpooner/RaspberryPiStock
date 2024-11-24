variable "schedule_interval" {
    description = "The interval at which the CloudWatch Event Rule should trigger the Lambda function"
    type        = number
    default     = 60
}

variable "email" {
    description = "An email address to send notifications to"
    type        = string
}

variable "access_key" {
    description = "The AWS access key"
    type        = string
}

variable "secret_key" {
    description = "The AWS secret key"
    type        = string
}

variable "shop_region" {
  description = "Country code for the shop"
  type        = string
  default     = "UK"
}

variable "pi_model" {
  description = "The model of the Raspberry Pi"
  type        = string
  default     = "PI5"
}