resource "shoreline_notebook" "kubernetes_persistent_volumes_running_out_of_storage_space" {
  name       = "kubernetes_persistent_volumes_running_out_of_storage_space"
  data       = file("${path.module}/data/kubernetes_persistent_volumes_running_out_of_storage_space.json")
  depends_on = [shoreline_action.invoke_pv_space_check,shoreline_action.invoke_increase_pvc_size]
}

resource "shoreline_file" "pv_space_check" {
  name             = "pv_space_check"
  input_file       = "${path.module}/data/pv_space_check.sh"
  md5              = filemd5("${path.module}/data/pv_space_check.sh")
  description      = "There might be a sudden increase in data volume that the persistent volume cannot handle."
  destination_path = "/agent/scripts/pv_space_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "increase_pvc_size" {
  name             = "increase_pvc_size"
  input_file       = "${path.module}/data/increase_pvc_size.sh"
  md5              = filemd5("${path.module}/data/increase_pvc_size.sh")
  description      = "Increase the storage capacity of the persistent volumes."
  destination_path = "/agent/scripts/increase_pvc_size.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_pv_space_check" {
  name        = "invoke_pv_space_check"
  description = "There might be a sudden increase in data volume that the persistent volume cannot handle."
  command     = "`chmod +x /agent/scripts/pv_space_check.sh && /agent/scripts/pv_space_check.sh`"
  params      = ["PV_NAME"]
  file_deps   = ["pv_space_check"]
  enabled     = true
  depends_on  = [shoreline_file.pv_space_check]
}

resource "shoreline_action" "invoke_increase_pvc_size" {
  name        = "invoke_increase_pvc_size"
  description = "Increase the storage capacity of the persistent volumes."
  command     = "`chmod +x /agent/scripts/increase_pvc_size.sh && /agent/scripts/increase_pvc_size.sh`"
  params      = ["PVC_NAME","NEW_SIZE"]
  file_deps   = ["increase_pvc_size"]
  enabled     = true
  depends_on  = [shoreline_file.increase_pvc_size]
}

