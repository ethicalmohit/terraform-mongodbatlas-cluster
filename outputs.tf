output "cluster_id" {
  description = "The ID of the MongoDB Atlas cluster"
  value       = mongodbatlas_advanced_cluster.this.id
}

output "connection_strings" {
  description = "The connection strings for the MongoDB Atlas cluster"
  value       = mongodbatlas_advanced_cluster.this.connection_strings
}

output "cluster_name" {
  description = "The name of the MongoDB Atlas cluster"
  value       = mongodbatlas_advanced_cluster.this.name
}

output "mongo_uri" {
  description = "The MongoDB connection URI"
  value       = mongodbatlas_advanced_cluster.this.connection_strings[0].standard_srv
  sensitive   = true
}

output "privatelink_endpoint_id" {
  description = "The ID of the MongoDB Atlas PrivateLink endpoint"
  value       = mongodbatlas_privatelink_endpoint.this.id
}

output "privatelink_endpoint_private_link_id" {
  description = "The PrivateLink ID for the MongoDB Atlas PrivateLink endpoint"
  value       = mongodbatlas_privatelink_endpoint.this.private_link_id
}

output "privatelink_endpoint_service_id" {
  description = "The ID of the MongoDB Atlas PrivateLink endpoint service"
  value       = mongodbatlas_privatelink_endpoint_service.this.id
}

output "backup_schedule_id" {
  description = "The ID of the MongoDB Atlas Cloud Backup Schedule"
  value       = length(mongodbatlas_cloud_backup_schedule.this) > 0 ? mongodbatlas_cloud_backup_schedule.this[0].id : null
}

output "backup_schedule_details" {
  description = "The details of the MongoDB Atlas Cloud Backup Schedule"
  value       = length(mongodbatlas_cloud_backup_schedule.this) > 0 ? mongodbatlas_cloud_backup_schedule.this[0] : null
}
