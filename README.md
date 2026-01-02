# OpenTofu AWS Global Accelerator Module

OpenTofu module for creating AWS Global Accelerator with listeners and endpoint groups.

## Usage

```hcl
module "global_accelerator" {
  source = "git::https://github.com/im5tu/opentofu-aws-global-accelerator.git?ref=main"

  name            = "my-accelerator"
  ip_address_type = "IPV4"
  enabled         = true

  # Optional: Enable flow logs
  flow_logs_enabled   = true
  flow_logs_s3_bucket = "my-flow-logs-bucket"
  flow_logs_s3_prefix = "global-accelerator-logs"

  listeners = {
    http = {
      protocol = "TCP"
      port_ranges = [
        { from_port = 80, to_port = 80 },
        { from_port = 443, to_port = 443 }
      ]
      client_affinity = "SOURCE_IP"
    }
  }

  endpoint_groups = {
    http_us_east_1 = {
      listener_key                  = "http"
      region                        = "us-east-1"
      health_check_port             = 80
      health_check_protocol         = "HTTP"
      health_check_path             = "/health"
      health_check_interval_seconds = 30
      threshold_count               = 3
      traffic_dial_percentage       = 100
      endpoint_configurations = [
        {
          endpoint_id                    = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/my-alb/1234567890123456"
          client_ip_preservation_enabled = true
          weight                         = 128
        }
      ]
    }
  }

  tags = {
    Environment = "production"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| opentofu | >= 1.9 |
| aws | ~> 6 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the Global Accelerator | `string` | n/a | yes |
| enabled | Whether the Global Accelerator is enabled | `bool` | `true` | no |
| ip_address_type | The type of IP addresses used by the accelerator. Valid values: IPV4, DUAL_STACK | `string` | `"IPV4"` | no |
| flow_logs_enabled | Whether flow logs are enabled | `bool` | `false` | no |
| flow_logs_s3_bucket | S3 bucket for flow logs. Required if flow_logs_enabled is true | `string` | `null` | no |
| flow_logs_s3_prefix | S3 prefix for flow logs | `string` | `"global-accelerator-logs"` | no |
| listeners | Map of listeners to create | `map(object)` | `{}` | no |
| endpoint_groups | Map of endpoint groups | `map(object)` | `{}` | no |
| tags | Tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Global Accelerator |
| arn | The ARN of the Global Accelerator |
| dns_name | The DNS name of the Global Accelerator |
| hosted_zone_id | The Global Accelerator Route53 zone ID |
| ip_sets | IP address sets associated with the Global Accelerator |
| listener_ids | Map of listener keys to listener IDs |
| endpoint_group_ids | Map of endpoint group keys to endpoint group IDs |

## Development

### Validation

This module uses GitHub Actions for validation:

- **Format check**: `tofu fmt -check -recursive`
- **Validation**: `tofu validate`
- **Security scanning**: Checkov, Trivy

### Local Development

```bash
# Format code
tofu fmt -recursive

# Validate
tofu init -backend=false
tofu validate
```

## License

MIT License - see [LICENSE](LICENSE) for details.
