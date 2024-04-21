resource "google_compute_network" "test-vpc" {
  name                    = "tf-vpc"
  auto_create_subnetworks = false
  mtu                     = 1460
  description             = "This is my VPC"
  routing_mode            = "REGIONAL"
}


resource "google_compute_subnetwork" "private-subnet-1" {
  name                     = "private-subnet-1"
  ip_cidr_range            = "10.1.3.0/24"
  region                   = "europe-west1"
  private_ip_google_access = true
  network                  = google_compute_network.test-vpc.id
}


resource "google_compute_subnetwork" "public-subnet-1" {
  name                     = "public-subnet-1"
  ip_cidr_range            = "10.1.2.0/28"
  region                   = "europe-west1"
  private_ip_google_access = false
  network                  = google_compute_network.test-vpc.id
}


resource "google_vpc_access_connector" "connector" {
  name          = "vpc-test-access-connector"
  subnet {
    name = google_compute_subnetwork.public-subnet-1.name
  }
  machine_type = "e2-standard-4"
  min_instances = 2
  max_instances = 3
  region        = "europe-west1"
}




resource "google_compute_network_peering" "peering1" {
  name         = "peering1"
  network      = google_compute_network.test-vpc.self_link
  peer_network = "projects/p-mzz6t7fthggsrkc1dwgbuaex/global/networks/nt-654b6de6bb9bd33fe764399d-03zcl7uo"
}
