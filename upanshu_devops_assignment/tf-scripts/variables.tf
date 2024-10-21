variable "project_id" {
  description = "The project ID"
  default        = "atlys-assignment-439100"
}

variable "region" {
  description = "The region to deploy resources"
  default     = "europe-west3"
}

variable "zone" {
  description = "The zone to deploy resources"
  default     = "europe-west3-a"
}

variable "db_user" {
  description = "Database username"
  type        = string
  sensitive   = true  # Mark the variable as sensitive
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true  # Mark the variable as sensitive
}
