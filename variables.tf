variable "project_id" {
  description = "MongoDB Atlas project ID"
  type        = string
}

variable "name" {
  description = "Name of the MongoDB cluster"
  type        = string
}

variable "mongo_db_major_version" {
  description = "Version of the MongoDB cluster"
  type        = string
}

variable "endpoint_service_id" {
  description = "Unique identifier of the interface endpoint created in your VPC with the AWS, AZURE or GCP resource"
  type        = string
}

variable "mongodb_atlas_public_key" {
  description = "The public key for the MongoDB Atlas API"
  type        = string
}

variable "mongodb_atlas_private_key" {
  description = "The private key for the MongoDB Atlas API"
  type        = string
}

variable "region_code" {
  description = "The region code for the MongoDB Atlas Cluster"
  type        = string
}

variable "mongodb_version" {
  default = "8.0"
}

variable "mongodb_atlas_config" {
  description = "Configuration settings for MongoDB Atlas cluster"
  type = object({
    compute_scaling_enabled    = optional(bool, true)
    compute_scale_down_enabled = optional(bool, true)
    disk_gb_scaling_enabled    = optional(bool, true)
    instance_size              = optional(string, "M10")
  })
  default = {
    compute_scaling_enabled    = true
    compute_scale_down_enabled = true
    disk_gb_scaling_enabled    = true
    instance_size              = "M10"
  }
}

variable "provider_name" {
  description = "The cloud provider name for the MongoDB Atlas cluster (e.g., AWS, AZURE, GCP)"
  type        = string
  default     = "AWS"
}

variable "region_name" {
  description = "The region name for the MongoDB Atlas cluster (e.g., AP_SOUTH_1)"
  type        = string
  default     = "AP_SOUTH_1"
}

variable "backup_copy_region_name" {
  description = "The region name for backup copy in the MongoDB Atlas Cloud Backup Schedule (e.g., AP_SOUTHEAST_1)"
  type        = string
  default     = "AP_SOUTHEAST_1"
}

variable "enable_backup" {
  description = "Whether to enable the MongoDB Atlas Cloud Backup Schedule. If false, backup resources will not be created."
  type        = bool
  default     = true
}

variable "daily_retention_value" {
  description = "Retention value for daily backup policy item."
  type        = number
  default     = 10
}

variable "daily_retention_unit" {
  description = "Retention unit for daily backup policy item."
  type        = string
  default     = "days"
}

variable "daily_frequency_interval" {
  description = "Frequency interval for daily backup policy item."
  type        = number
  default     = 1
}

variable "hourly_retention_value" {
  description = "Retention value for hourly backup policy item."
  type        = number
  default     = 2
}

variable "hourly_retention_unit" {
  description = "Retention unit for hourly backup policy item."
  type        = string
  default     = "days"
}

variable "hourly_frequency_interval" {
  description = "Frequency interval for hourly backup policy item."
  type        = number
  default     = 12
}

variable "backup_policies" {
  description = "Map of backup policy items. Example: { daily = { retention_value = 10, retention_unit = \"days\", frequency_interval = 1 }, hourly = { retention_value = 2, retention_unit = \"days\", frequency_interval = 12 } }"
  type = map(object({
    retention_value    = number
    retention_unit     = string
    frequency_interval = number
  }))
  default = {
    daily = {
      retention_value    = 10
      retention_unit     = "days"
      frequency_interval = 1
    }
    hourly = {
      retention_value    = 2
      retention_unit     = "days"
      frequency_interval = 12
    }
  }
}

