terraform {
   required_providers {
      grafana = {
         source  = "grafana/grafana"
         version = ">= 2.9.0"
      }
   }
}
provider "grafana" {
   url   = "http://localhost:3000"
   auth  =  "your-generated-token"
}

# resource "grafana_service_account" "admin" {
#   name        = "terraform-admin sa"
#   role        = "Admin"
#   is_disabled = false
# }

# resource "grafana_service_account_token" "admin-token" {
#   name               = "terraform-token"
#   service_account_id = grafana_service_account.admin.id
# }

resource "grafana_data_source" "prometheus" {
  type                = "prometheus"
  name                = "spring-petclinic"
  url                 = "https://prometheus:9090"
}

resource "grafana_folder" "jmx" {
  title = "JMX Exporter Folder"
  uid   = "folder-jmx"
}
resource "grafana_dashboard" "jmx" {
    folder = grafana_folder.jmx.uid
    config_json = file("${path.module}/10519_rev2.json")
}