resource "mongodbatlas_advanced_cluster" "this" {
  project_id             = var.project_id
  name                   = var.name
  cluster_type           = "REPLICASET"
  mongo_db_major_version = var.mongodb_version

  replication_specs {
    zone_name = "Zone 1"
    region_configs {
      priority      = 7
      provider_name = var.provider_name
      region_name   = var.region_name

      auto_scaling {
        compute_enabled            = var.mongodb_atlas_config["compute_scaling_enabled"]
        compute_max_instance_size  = null
        compute_min_instance_size  = null
        compute_scale_down_enabled = var.mongodb_atlas_config["compute_scale_down_enabled"]
        disk_gb_enabled            = var.mongodb_atlas_config["disk_gb_scaling_enabled"]
      }

      electable_specs {
        disk_iops       = 3000
        ebs_volume_type = null
        instance_size   = var.mongodb_atlas_config["instance_size"]
        node_count      = 3
      }

      analytics_specs {
        disk_iops       = 3000
        ebs_volume_type = null
        instance_size   = var.mongodb_atlas_config["instance_size"]
        node_count      = 0
      }
    }
  }
}

resource "mongodbatlas_privatelink_endpoint" "this" {
  project_id    = var.project_id
  provider_name = "AWS"
  region        = var.region_code

  timeouts {
    create = "30m"
    delete = "20m"
  }
}

resource "mongodbatlas_privatelink_endpoint_service" "this" {
  project_id          = var.project_id
  private_link_id     = mongodbatlas_privatelink_endpoint.this.private_link_id
  endpoint_service_id = var.endpoint_service_id
  provider_name       = "AWS"
}

# Backup policy as per compliance.
resource "mongodbatlas_cloud_backup_schedule" "this" {
  count        = var.enable_backup ? 1 : 0
  project_id   = mongodbatlas_advanced_cluster.this.project_id
  cluster_name = mongodbatlas_advanced_cluster.this.name

  reference_hour_of_day    = 0
  reference_minute_of_hour = 0
  restore_window_days      = 2

  copy_settings {
    cloud_provider = var.provider_name
    frequencies = [
      "WEEKLY",
    ]
    region_name        = var.backup_copy_region_name
    should_copy_oplogs = false
    zone_id            = mongodbatlas_advanced_cluster.this.replication_specs.*.zone_id[0]
  }

  dynamic "policy_item_daily" {
    for_each = contains(keys(var.backup_policies), "daily") ? [var.backup_policies["daily"]] : []
    content {
      retention_value    = policy_item_daily.value.retention_value
      retention_unit     = policy_item_daily.value.retention_unit
      frequency_interval = policy_item_daily.value.frequency_interval
    }
  }

  dynamic "policy_item_hourly" {
    for_each = contains(keys(var.backup_policies), "hourly") ? [var.backup_policies["hourly"]] : []
    content {
      retention_value    = try(policy_item_hourly.value.retention_value, null)
      retention_unit     = try(policy_item_hourly.value.retention_unit, null)
      frequency_interval = try(policy_item_hourly.value.frequency_interval, null)
    }
  }
}

