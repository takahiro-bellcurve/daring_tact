variable "project_name" {
  default = {
    tf-sample = "daring_tact"
  }
}

variable "credential" {
  default = {
    data = "gcp_service_account.json"
  }
}
