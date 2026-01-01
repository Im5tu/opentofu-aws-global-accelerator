variable "name" {
  type        = string
  description = "Name of the Global Accelerator"
}

variable "enabled" {
  type        = bool
  description = "Whether the Global Accelerator is enabled"
  default     = true
}

variable "ip_address_type" {
  type        = string
  description = "The type of IP addresses used by the accelerator. Valid values: IPV4, DUAL_STACK"
  default     = "IPV4"
}

variable "flow_logs_enabled" {
  type        = bool
  description = "Whether flow logs are enabled"
  default     = false
}

variable "flow_logs_s3_bucket" {
  type        = string
  description = "S3 bucket for flow logs. Required if flow_logs_enabled is true"
  default     = null
}

variable "flow_logs_s3_prefix" {
  type        = string
  description = "S3 prefix for flow logs"
  default     = "global-accelerator-logs"
}

variable "listeners" {
  type = map(object({
    protocol = string # TCP or UDP
    port_ranges = list(object({
      from_port = number
      to_port   = number
    }))
    client_affinity = optional(string, "NONE") # NONE or SOURCE_IP
  }))
  description = "Map of listeners to create"
  default     = {}
}

variable "endpoint_groups" {
  type = map(object({
    listener_key                  = string
    region                        = string
    health_check_port             = optional(number)
    health_check_protocol         = optional(string, "TCP")
    health_check_path             = optional(string)
    health_check_interval_seconds = optional(number, 30)
    threshold_count               = optional(number, 3)
    traffic_dial_percentage       = optional(number, 100)
    endpoint_configurations = list(object({
      endpoint_id                    = string
      client_ip_preservation_enabled = optional(bool, false)
      weight                         = optional(number, 128)
    }))
  }))
  description = "Map of endpoint groups"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all resources"
  default     = {}
}
