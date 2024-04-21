provider "google" {
  project     = "qureos-a1006"
  credentials = file("qureos-a1006-c026e91c7283.json")
  region      = "europe-west1"
  zone        = "europe-west1-b"
}