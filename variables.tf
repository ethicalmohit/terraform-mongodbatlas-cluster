variable "project_id" {
  description = "MongoDB Atlas project ID"
  type        = string
}

variable "name" {
  description = "Name of the MongoDB cluster"
  type        = string
}

variable "mongodb_version" {
  description = "Major version of MongoDB to deploy (6.0, 7.0, or 8.0)"
  type        = string
  default     = "8.0"

  validation {
    condition     = contains(["6.0", "7.0", "8.0"], var.mongodb_version)
    error_message = "Supported MongoDB versions are 6.0, 7.0, and 8.0."
  }
}

variable "provider_name" {
  description = "Cloud provider for the cluster (AWS, AZURE, or GCP)"
  type        = string
  default     = "AWS"

  validation {
    condition     = contains(["AWS", "AZURE", "GCP"], var.provider_name)
    error_message = "Supported cloud providers are AWS, AZURE, and GCP."
  }
}

variable "region_name" {
  description = "Cloud provider region name for the cluster (e.g. AP_SOUTH_1 for AWS, INDIA_CENTRAL for Azure)"
  type        = string
  default     = "AP_SOUTH_1"
}

variable "region_code" {
  description = "Region code used for the PrivateLink endpoint (e.g. AP_SOUTH_1). Required when enable_privatelink = true."
  type        = string
  default     = null
}

variable "mongodb_atlas_config" {
  description = "Configuration settings for the MongoDB Atlas cluster"
  type = object({
    compute_scaling_enabled    = optional(bool, true)
    compute_scale_down_enabled = optional(bool, true)
    compute_max_instance_size  = optional(string, "M40")
    compute_min_instance_size  = optional(string, "M10")
    disk_gb_scaling_enabled    = optional(bool, true)
    ebs_volume_type            = optional(string, null)
    instance_size              = optional(string, "M10")
    node_count                 = optional(number, 3)
    disk_iops                  = optional(number, 3000)
  })
  default = {}

  validation {
    condition     = var.mongodb_atlas_config.node_count % 2 != 0
    error_message = "Node count must be an odd number (3, 5, 7, ...) as required by MongoDB replica sets."
  }
}

# PrivateLink

variable "enable_privatelink" {
  description = "Whether to create a PrivateLink endpoint and service. Requires endpoint_service_id and region_code when true."
  type        = bool
  default     = false
}

variable "endpoint_service_id" {
  description = "VPC endpoint service ID (AWS VPC endpoint, Azure Private Endpoint, or GCP endpoint). Required when enable_privatelink = true."
  type        = string
  default     = null
}

# Backup

variable "enable_backup" {
  description = "Whether to create a Cloud Backup Schedule. When false, no backup resources are created."
  type        = bool
  default     = true
}

variable "restore_window_days" {
  description = "Number of days back in time you can restore to with Continuous Cloud Backup."
  type        = number
  default     = 2
}

variable "backup_reference_hour_of_day" {
  description = "UTC hour of day (0–23) when Atlas starts the backup snapshot window."
  type        = number
  default     = 0

  validation {
    condition     = var.backup_reference_hour_of_day >= 0 && var.backup_reference_hour_of_day <= 23
    error_message = "Backup reference hour must be between 0 and 23."
  }
}

variable "backup_reference_minute_of_hour" {
  description = "UTC minute of the hour (0–59) when Atlas starts the backup snapshot window."
  type        = number
  default     = 0

  validation {
    condition     = var.backup_reference_minute_of_hour >= 0 && var.backup_reference_minute_of_hour <= 59
    error_message = "Backup reference minute must be between 0 and 59."
  }
}

variable "enable_backup_copy" {
  description = "Whether to copy backups to a secondary region. Requires backup_copy_region_name when true."
  type        = bool
  default     = false
}

variable "backup_copy_region_name" {
  description = "Region to copy backups to. Required when enable_backup_copy = true."
  type        = string
  default     = null
}

variable "backup_policies" {
  description = <<-EOT
    Map of backup policy items by frequency type. Supported keys: hourly, daily, weekly, monthly.
    Omitting a key means that policy type will not be created.

    Example:
    {
      daily  = { retention_value = 10, retention_unit = "days", frequency_interval = 1 }
      hourly = { retention_value = 2,  retention_unit = "days", frequency_interval = 12 }
    }
  EOT
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
