variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region for sandbox"
}

variable "enable_apply" {
  type        = bool
  default     = false
  description = "Guard: create resources only when true (sandbox)."
}

variable "lambda_name" {
  type        = string
  default     = "controls-demo-remediator"
  description = "Name of the corrective Lambda"
}

variable "block_public_acls" {
  type        = bool
  default     = true
  description = "Temporarily set false to allow a test of ACL remediation."
}
variable "block_public_policy" {
  type        = bool
  default     = true
  description = "Temporarily set false to allow a bucket-policy remediation test."
}


