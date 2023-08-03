resource "shoreline_notebook" "mongodb_replication_lag_incident" {
  name       = "mongodb_replication_lag_incident"
  data       = file("${path.module}/data/mongodb_replication_lag_incident.json")
  depends_on = [shoreline_action.invoke_script_name,shoreline_action.invoke_primary_node_status,shoreline_action.invoke_check_secondary_node,shoreline_action.invoke_update_write_concern,shoreline_action.invoke_increase_replication_buffer]
}

resource "shoreline_file" "script_name" {
  name             = "script_name"
  input_file       = "${path.module}/data/script_name.sh"
  md5              = filemd5("${path.module}/data/script_name.sh")
  description      = "Define the hostnames or IP addresses of the primary and secondary nodes"
  destination_path = "/agent/scripts/script_name.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "primary_node_status" {
  name             = "primary_node_status"
  input_file       = "${path.module}/data/primary_node_status.sh"
  md5              = filemd5("${path.module}/data/primary_node_status.sh")
  description      = "Check the status of the primary node"
  destination_path = "/agent/scripts/primary_node_status.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "check_secondary_node" {
  name             = "check_secondary_node"
  input_file       = "${path.module}/data/check_secondary_node.sh"
  md5              = filemd5("${path.module}/data/check_secondary_node.sh")
  description      = "Check the status of the secondary node"
  destination_path = "/agent/scripts/check_secondary_node.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_write_concern" {
  name             = "update_write_concern"
  input_file       = "${path.module}/data/update_write_concern.sh"
  md5              = filemd5("${path.module}/data/update_write_concern.sh")
  description      = "Reduce the write concern settings on the MongoDB cluster to allow for faster replication."
  destination_path = "/agent/scripts/update_write_concern.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "increase_replication_buffer" {
  name             = "increase_replication_buffer"
  input_file       = "${path.module}/data/increase_replication_buffer.sh"
  md5              = filemd5("${path.module}/data/increase_replication_buffer.sh")
  description      = "Increase the replication buffer size to allow for more data to be replicated between the primary and secondary nodes."
  destination_path = "/agent/scripts/increase_replication_buffer.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_script_name" {
  name        = "invoke_script_name"
  description = "Define the hostnames or IP addresses of the primary and secondary nodes"
  command     = "`chmod +x /agent/scripts/script_name.sh && /agent/scripts/script_name.sh`"
  params      = []
  file_deps   = ["script_name"]
  enabled     = true
  depends_on  = [shoreline_file.script_name]
}

resource "shoreline_action" "invoke_primary_node_status" {
  name        = "invoke_primary_node_status"
  description = "Check the status of the primary node"
  command     = "`chmod +x /agent/scripts/primary_node_status.sh && /agent/scripts/primary_node_status.sh`"
  params      = []
  file_deps   = ["primary_node_status"]
  enabled     = true
  depends_on  = [shoreline_file.primary_node_status]
}

resource "shoreline_action" "invoke_check_secondary_node" {
  name        = "invoke_check_secondary_node"
  description = "Check the status of the secondary node"
  command     = "`chmod +x /agent/scripts/check_secondary_node.sh && /agent/scripts/check_secondary_node.sh`"
  params      = []
  file_deps   = ["check_secondary_node"]
  enabled     = true
  depends_on  = [shoreline_file.check_secondary_node]
}

resource "shoreline_action" "invoke_update_write_concern" {
  name        = "invoke_update_write_concern"
  description = "Reduce the write concern settings on the MongoDB cluster to allow for faster replication."
  command     = "`chmod +x /agent/scripts/update_write_concern.sh && /agent/scripts/update_write_concern.sh`"
  params      = []
  file_deps   = ["update_write_concern"]
  enabled     = true
  depends_on  = [shoreline_file.update_write_concern]
}

resource "shoreline_action" "invoke_increase_replication_buffer" {
  name        = "invoke_increase_replication_buffer"
  description = "Increase the replication buffer size to allow for more data to be replicated between the primary and secondary nodes."
  command     = "`chmod +x /agent/scripts/increase_replication_buffer.sh && /agent/scripts/increase_replication_buffer.sh`"
  params      = []
  file_deps   = ["increase_replication_buffer"]
  enabled     = true
  depends_on  = [shoreline_file.increase_replication_buffer]
}

