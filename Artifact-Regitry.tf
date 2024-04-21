resource "google_artifact_registry_repository" "tf-stg-repo" {
  location      = "europe-west1"              # Location Of Artifact Registry
  repository_id = "my-repository"             # Name Of Artifact Registry
  description   = "example docker repository" # Description Of Artifact Registry
  format        = "DOCKER"
  labels = { # Labels for Artifact Registry
    "env"     = "test",
    "name"    = "my-repository",
    "project" = "qureos"
  }
  cleanup_policy_dry_run = false
  cleanup_policies {
    id     = "delete-Policy" # Name of CleanUp Policy
    action = "DELETE"        # Policy action. Possible values are: DELETE, KEEP.
    condition {
      tag_state  = "UNTAGGED" # Match versions by tag status. Default value is ANY. Possible values are: TAGGED, UNTAGGED, ANY.
      older_than = "604800s"
    }
  }

  cleanup_policies {
    id     = "keep-policy"
    action = "KEEP"
    condition {
      tag_state             = "TAGGED"
      tag_prefixes          = ["release"]
      package_name_prefixes = ["webapp", "mobile"]
    }
  }
  cleanup_policies {
    id     = "keep-minimum-versions-policey"
    action = "KEEP"
    most_recent_versions {
      package_name_prefixes = ["webapp", "mobile", "sandbox"]
      keep_count            = 5
    }
  }
}