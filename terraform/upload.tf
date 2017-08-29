resource "google_compute_address" "upload" {
    name            = "upload"
}

# resource "google_compute_instance" "upload" {
#     name            = "upload"
#     machine_type    = "g1-small"
#     zone            = "${var.zone}"

#     boot_disk {
#         initialize_params {
#             image   = "debian-cloud/debian-8"
#         }
#     }

#     network_interface {
#         network     = "default"

#         access_config {
#             nat_ip  = "${google_compute_address.upload.address}"
#         }
#     }

#     service_account {
#         # scopes = ["compute-rw"]
#     }
# }