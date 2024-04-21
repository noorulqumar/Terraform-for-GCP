resource "google_cloud_run_v2_service" "default" {
  name     = "cloudrun-service"
  location = "europe-west1"
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    vpc_access{
      connector = google_vpc_access_connector.connector.id
      egress = "ALL_TRAFFIC"
    }
    containers {
      ports {
        name           = ""
        container_port = 3001
      }
      image = "europe-west1-docker.pkg.dev/qureos-a1006/qureos-frontend-staging-service/stg-frontend@sha256:34da0b51907982a90bf28726872fc57ef6636979c3894481402a62a44b23770e"
      resources {
        limits = {
          cpu    = "4"
          memory = "16384Mi"
        }
      }
      env {
        name  = "FOO"
        value = "bar"
      }
      env {
        name  = "FOOD"
        value = "barger"
      }
    }
    scaling {
      min_instance_count = 1
      max_instance_count = 10
    }
    labels = {
      "env"     = "test",
      "name"    = "my-service",
      "project" = "qureos"
    }
  }
}


data "google_iam_policy" "noauth-policy" {
  binding {
    role = "roles/run.invoker"
    members = [ "allUsers" ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_v2_service.default.location
  service     = google_cloud_run_v2_service.default.name
  policy_data = data.google_iam_policy.noauth-policy.policy_data
}

output "cloud-run-service-uri" {
  value = google_cloud_run_v2_service.default.uri
}