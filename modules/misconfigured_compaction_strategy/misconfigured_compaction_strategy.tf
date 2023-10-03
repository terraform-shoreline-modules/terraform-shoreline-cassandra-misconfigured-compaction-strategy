resource "shoreline_notebook" "misconfigured_compaction_strategy" {
  name       = "misconfigured_compaction_strategy"
  data       = file("${path.module}/data/misconfigured_compaction_strategy.json")
  depends_on = [shoreline_action.invoke_ping_traceroute,shoreline_action.invoke_ulimit_n_max_open_files,shoreline_action.invoke_meminfo_available,shoreline_action.invoke_config_correction]
}

resource "shoreline_file" "ping_traceroute" {
  name             = "ping_traceroute"
  input_file       = "${path.module}/data/ping_traceroute.sh"
  md5              = filemd5("${path.module}/data/ping_traceroute.sh")
  description      = "6. Check if there are any network issues"
  destination_path = "/agent/scripts/ping_traceroute.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "ulimit_n_max_open_files" {
  name             = "ulimit_n_max_open_files"
  input_file       = "${path.module}/data/ulimit_n_max_open_files.sh"
  md5              = filemd5("${path.module}/data/ulimit_n_max_open_files.sh")
  description      = "15. Check if there are any file descriptor limits reached"
  destination_path = "/agent/scripts/ulimit_n_max_open_files.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "meminfo_available" {
  name             = "meminfo_available"
  input_file       = "${path.module}/data/meminfo_available.sh"
  md5              = filemd5("${path.module}/data/meminfo_available.sh")
  description      = "16. Check if there are any memory usage issues"
  destination_path = "/agent/scripts/meminfo_available.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "config_correction" {
  name             = "config_correction"
  input_file       = "${path.module}/data/config_correction.sh"
  md5              = filemd5("${path.module}/data/config_correction.sh")
  description      = "Identify and analyze the configuration settings of the compaction strategy and rectify the misconfiguration."
  destination_path = "/agent/scripts/config_correction.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_ping_traceroute" {
  name        = "invoke_ping_traceroute"
  description = "6. Check if there are any network issues"
  command     = "`chmod +x /agent/scripts/ping_traceroute.sh && /agent/scripts/ping_traceroute.sh`"
  params      = []
  file_deps   = ["ping_traceroute"]
  enabled     = true
  depends_on  = [shoreline_file.ping_traceroute]
}

resource "shoreline_action" "invoke_ulimit_n_max_open_files" {
  name        = "invoke_ulimit_n_max_open_files"
  description = "15. Check if there are any file descriptor limits reached"
  command     = "`chmod +x /agent/scripts/ulimit_n_max_open_files.sh && /agent/scripts/ulimit_n_max_open_files.sh`"
  params      = ["PID"]
  file_deps   = ["ulimit_n_max_open_files"]
  enabled     = true
  depends_on  = [shoreline_file.ulimit_n_max_open_files]
}

resource "shoreline_action" "invoke_meminfo_available" {
  name        = "invoke_meminfo_available"
  description = "16. Check if there are any memory usage issues"
  command     = "`chmod +x /agent/scripts/meminfo_available.sh && /agent/scripts/meminfo_available.sh`"
  params      = []
  file_deps   = ["meminfo_available"]
  enabled     = true
  depends_on  = [shoreline_file.meminfo_available]
}

resource "shoreline_action" "invoke_config_correction" {
  name        = "invoke_config_correction"
  description = "Identify and analyze the configuration settings of the compaction strategy and rectify the misconfiguration."
  command     = "`chmod +x /agent/scripts/config_correction.sh && /agent/scripts/config_correction.sh`"
  params      = []
  file_deps   = ["config_correction"]
  enabled     = true
  depends_on  = [shoreline_file.config_correction]
}

