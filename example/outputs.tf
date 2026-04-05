output "cluster_id" {
  description = "The ID of the MongoDB Atlas cluster"
  value       = module.mongodb.cluster_id
}

output "cluster_name" {
  description = "The name of the MongoDB Atlas cluster"
  value       = module.mongodb.cluster_name
}

output "cluster_state" {
  description = "The current state of the MongoDB Atlas cluster"
  value       = module.mongodb.cluster_state
}

output "cluster_configuration" {
  description = "Summary of the cluster configuration"
  value       = module.mongodb.cluster_configuration
}

output "connection_strings" {
  description = "The connection strings for the MongoDB Atlas cluster"
  value       = module.mongodb.connection_strings
  sensitive   = true
}

output "mongo_uri" {
  description = "The standard SRV connection URI"
  value       = module.mongodb.mongo_uri
  sensitive   = true
}

output "privatelink_endpoint_id" {
  description = "The ID of the PrivateLink endpoint (null if disabled)"
  value       = module.mongodb.privatelink_endpoint_id
}

output "privatelink_endpoint_private_link_id" {
  description = "The PrivateLink service ID (null if disabled)"
  value       = module.mongodb.privatelink_endpoint_private_link_id
}

output "privatelink_endpoint_service_id" {
  description = "The ID of the PrivateLink endpoint service (null if disabled)"
  value       = module.mongodb.privatelink_endpoint_service_id
}

output "backup_schedule_id" {
  description = "The ID of the Cloud Backup Schedule (null if disabled)"
  value       = module.mongodb.backup_schedule_id
}

output "backup_schedule_details" {
  description = "Full details of the Cloud Backup Schedule"
  value       = module.mongodb.backup_schedule_details
  sensitive   = true
}
