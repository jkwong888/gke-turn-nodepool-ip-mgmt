resource "google_service_account" "cnrm_sa" {
  project       = module.service_project.project_id
  account_id    = "cnrm-controller-manager"
  display_name  = format("config connector service account")
}

# bind config connector SA using workload identity
resource "google_service_account_iam_member" "cnrm_sa_role" {
  service_account_id  = google_service_account.cnrm_sa.name
  role                = "roles/iam.workloadIdentityUser"
  member              = format("serviceAccount:%s.svc.id.goog[cnrm-system/cnrm-controller-manager]", 
                               module.service_project.project_id)
}

# allow config connector to make changes to this project
resource "google_project_iam_member" "cnrm_editor" {
  project       = module.service_project.project_id
  member = format("serviceAccount:%s", google_service_account.cnrm_sa.email)
  role = "roles/editor"
}

# allow config connector to use host network
resource "google_project_iam_member" "cnrm_networkUser" {
  project       = data.google_project.host_project.project_id
  member = format("serviceAccount:%s", google_service_account.cnrm_sa.email)
  role = "roles/compute.networkAdmin"
}

# allow config connector to set IAM roles on the network host project
resource "google_project_iam_member" "cnrm_hostProjectIamAdmin" {
  project       = data.google_project.host_project.project_id
  member = format("serviceAccount:%s", google_service_account.cnrm_sa.email)
  role = "roles/resourcemanager.projectIamAdmin"
}

resource "google_project_iam_member" "cnrm_saAdmin" {
  project       = module.service_project.project_id
  member = format("serviceAccount:%s", google_service_account.cnrm_sa.email)
  role = "roles/iam.serviceAccountAdmin"
}

resource "google_project_iam_member" "cnrm_iamAdmin" {
  project       = module.service_project.project_id
  member = format("serviceAccount:%s", google_service_account.cnrm_sa.email)
  role = "roles/resourcemanager.projectIamAdmin"
}

resource "google_project_iam_member" "cnrm_roleAdmin" {
  project       = module.service_project.project_id
  member = format("serviceAccount:%s", google_service_account.cnrm_sa.email)
  role = "roles/iam.roleAdmin"
}