module "mongodb" {
  source = "<ORG>/<NAME>/mongodbatlas"

  project_id                  = "your-project-id"
  name                        = "your-cluster-name"
  mongodb_version             = "8.0"
  region_code                 = "AP_SOUTH_1"
  endpoint_service_id         = "your-endpoint-service-id"
  mongodb_atlas_public_key    = "your-public-key"
  mongodb_atlas_private_key   = "your-private-key"
  provider_name               = "AWS"
  region_name                 = "AP_SOUTH_1"
  backup_copy_region_name     = "AP_SOUTHEAST_1"

  mongodb_atlas_config = {
    compute_scaling_enabled    = true
    compute_scale_down_enabled = true
    disk_gb_scaling_enabled    = true
    instance_size              = "M10"
  }

  backup_policies = {
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

# Note: Replace <ORG> and <NAME> with your Terraform Registry namespace and module name. 