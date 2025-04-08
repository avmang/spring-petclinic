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
   auth  =  var.token
}

resource "grafana_data_source" "prometheus" {
  type                = "prometheus"
  name                = "spring-petclinic"
  url                 = "http://prometheus:9090"
}

resource "grafana_folder" "jmx" {
  title = "JMX Exporter Folder"
  uid   = "folder-jmx"
}


resource "grafana_dashboard" "jmx_exporter" {
   folder = grafana_folder.jmx.uid
   depends_on = [ grafana_data_source.prometheus ]
   config_json = templatefile("./jmx_exporter_dashboard.json", {
      DS_PROMETHEUS = grafana_data_source.prometheus.name
   })
}
