resource "aws_globalaccelerator_accelerator" "this" {
  name            = var.name
  ip_address_type = var.ip_address_type
  enabled         = var.enabled

  dynamic "attributes" {
    for_each = var.flow_logs_enabled ? [1] : []
    content {
      flow_logs_enabled   = true
      flow_logs_s3_bucket = var.flow_logs_s3_bucket
      flow_logs_s3_prefix = var.flow_logs_s3_prefix
    }
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_globalaccelerator_listener" "this" {
  for_each = var.listeners

  accelerator_arn = aws_globalaccelerator_accelerator.this.arn
  protocol        = each.value.protocol
  client_affinity = each.value.client_affinity

  dynamic "port_range" {
    for_each = each.value.port_ranges
    content {
      from_port = port_range.value.from_port
      to_port   = port_range.value.to_port
    }
  }
}

resource "aws_globalaccelerator_endpoint_group" "this" {
  for_each = var.endpoint_groups

  listener_arn                  = aws_globalaccelerator_listener.this[each.value.listener_key].id
  endpoint_group_region         = each.value.region
  health_check_port             = each.value.health_check_port
  health_check_protocol         = each.value.health_check_protocol
  health_check_path             = each.value.health_check_path
  health_check_interval_seconds = each.value.health_check_interval_seconds
  threshold_count               = each.value.threshold_count
  traffic_dial_percentage       = each.value.traffic_dial_percentage

  dynamic "endpoint_configuration" {
    for_each = each.value.endpoint_configurations
    content {
      endpoint_id                    = endpoint_configuration.value.endpoint_id
      client_ip_preservation_enabled = endpoint_configuration.value.client_ip_preservation_enabled
      weight                         = endpoint_configuration.value.weight
    }
  }
}
