variable "schedule_interval" {
    description = "The interval at which the CloudWatch Event Rule should trigger the Lambda function"
    type        = number
    default     = 60
}

variable "phone_number" {
    description = "A list of phone numbers to subscribe to the SNS topic"
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
  description = "value"
  type        = string
  default     = "UK"
}

variable "pi_model" {
  description = "value"
  type        = string
  default     = "PI5"
}