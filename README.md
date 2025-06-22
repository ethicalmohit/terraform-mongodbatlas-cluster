# MongoDB Atlas Module

This Terraform module provisions a MongoDB Atlas cluster with advanced configuration options, private endpoints, and backup policies.

## Features

- Creates a MongoDB Atlas cluster with configurable settings
- Supports AWS as the cloud provider
- Configurable cluster size and region
- Automatic backup and disk scaling enabled by default
- Configurable MongoDB version
- Configurable instance size
- PrivateLink endpoint support with configurable region
- Automated backup schedule with retention policies

## Usage

See the [example](./example/main.tf) directory for a complete usage example.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | MongoDB Atlas project ID | `string` | n/a | yes |
| name | Name of the MongoDB cluster | `string` | n/a | yes |
| mongodb_version | Version of the MongoDB cluster | `string` | `"8.0"` | no |
| region_code | The region code for the MongoDB Atlas Cluster | `string` | n/a | yes |
| endpoint_service_id | Unique identifier of the interface endpoint | `string` | n/a | yes |
| mongodb_atlas_public_key | The public key for the MongoDB Atlas API | `string` | n/a | yes |
| mongodb_atlas_private_key | The private key for the MongoDB Atlas API | `string` | n/a | yes |
| mongodb_atlas_config | Configuration settings for MongoDB Atlas cluster | `object` | See below | no |
| backup_policies | Map of backup policy items for daily/hourly backups. See below. | `map(object)` | See below | no |

### mongodb_atlas_config

| Name | Description | Type | Default |
|------|-------------|------|---------|
| compute_scaling_enabled | Enable compute auto-scaling | `bool` | `true` |
| compute_scale_down_enabled | Enable compute scale down | `bool` | `true` |
| disk_gb_scaling_enabled | Enable disk auto-scaling | `bool` | `true` |
| instance_size | Instance size (e.g., M10) | `string` | `"M10"` |

### backup_policies

The `backup_policies` variable configures backup policies. You can specify any combination of supported policy types (e.g., `daily`, `hourly`). If a policy type is omitted, it will not be created.

Example with both daily and hourly:

```hcl
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
```

Example with only daily:

```hcl
backup_policies = {
  daily = {
    retention_value    = 10
    retention_unit     = "days"
    frequency_interval = 1
  }
}
```

If you omit `hourly`, no hourly backup policy will be created.

## Outputs

The module will output the following:

- Cluster ID
- Cluster name
- Connection string
- Private endpoint information
- Backup configuration details

## Backup Configuration

The module configures automated backups with the following settings:

- Daily backups with 30-day retention
- Hourly backups with 7-day retention
- Backup window: 00:00 UTC
- Restore window: 7 days
- Cross-region backup copy to AP_SOUTH_2

## Private Endpoint

The module sets up a private endpoint with AWS with the following configuration:

- Provider: AWS
- Creation timeout: 30 minutes
- Deletion timeout: 20 minutes

## Notes

- The cluster is configured as a replica set with 3 nodes
- Default IOPS is set to 3000
- Analytics nodes are disabled by default
- The module uses AWS as the cloud provider

## Requirements

- Terraform >= 1.0.0
- MongoDB Atlas account and API keys
- AWS account (for cloud provider)
- VPC endpoint service ID for PrivateLink

## TODO
- Add resources for Users, Projects, Organization, Backups, Snapshot, Config etc.

## Notes
- To fetch private_link_id use below API. This is important to import resources.

```bash
curl --user "public-api-key:private-api-key" \
  --digest \
  --header "Accept: application/vnd.atlas.2025-03-12+json" -X GET https://cloud.mongodb.com/api/atlas/v2/groups/{PROJECT_ID}/privateEndpoint/AWS/endpointService
```

## License

This module is licensed under the Apache License, Version 2.0. See the LICENSE file for details.
