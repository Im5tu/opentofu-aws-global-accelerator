output "id" {
  description = "The ID of the Global Accelerator"
  value       = aws_globalaccelerator_accelerator.this.id
}

output "arn" {
  description = "The ARN of the Global Accelerator"
  value       = aws_globalaccelerator_accelerator.this.arn
}

output "dns_name" {
  description = "The DNS name of the Global Accelerator"
  value       = aws_globalaccelerator_accelerator.this.dns_name
}

output "hosted_zone_id" {
  description = "The Global Accelerator Route53 zone ID"
  value       = aws_globalaccelerator_accelerator.this.hosted_zone_id
}

output "ip_sets" {
  description = "IP address sets associated with the Global Accelerator"
  value       = aws_globalaccelerator_accelerator.this.ip_sets
}

output "listener_ids" {
  description = "Map of listener keys to listener IDs"
  value       = { for k, v in aws_globalaccelerator_listener.this : k => v.id }
}

output "endpoint_group_ids" {
  description = "Map of endpoint group keys to endpoint group IDs"
  value       = { for k, v in aws_globalaccelerator_endpoint_group.this : k => v.id }
}
