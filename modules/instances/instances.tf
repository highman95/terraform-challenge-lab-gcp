locals {
    # instance_names = toset([
    #     "tf-instance-1",
    #     "tf-instance-2",
    # ])
    instance_names = map(object({
        name: "tf-instance-1",
    }, {
        name: "tf-instance-2",
    }))
}

resource "google_compute_instance" "webvms" {
    for_each = local.instance_names

    # name = each.key
    name = each.value.name
    machine_type = "e2-micro"
    project = var.project_id
    zone = var.zone

    boot_disk {
      initialize_params {
        image = "debian-cloud/debian-11-bullseye-v20231212"
      }
    }

    network_interface {
        network = "default"
        access_config {
        }
    }

    metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT
    allow_stopping_for_update = true
}

resource "google_compute_instance" "tf-instance-1" {
    name = "tf-instance-1"
    machine_type = "e2-standard-2"
    project = var.project_id
    zone = var.zone

    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-11-bullseye-v20231212"
        }
    }

    network_interface {
        network = "tf-vpc-925181"
        subnetwork = "subnet-01"
        access_config {
        }
    }

    metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT
    allow_stopping_for_update = true
}

resource "google_compute_instance" "tf-instance-2" {
    name = "tf-instance-2"
    machine_type = "e2-standard-2"
    project = var.project_id
    zone = var.zone

    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-11-bullseye-v20231212"
        }
    }

    network_interface {
        network = "tf-vpc-925181"
        subnetwork = "subnet-02"
        access_config {
        }
    }

    metadata_startup_script = <<-EOT
        #!/bin/bash
    EOT
    allow_stopping_for_update = true
}

# resource "google_compute_instance" "tf-instance-3" {
#     name = "tf-instance-381894"
#     machine_type = "e2-standard-2"
#     project = var.project_id
#     zone = var.zone

#     boot_disk {
#         initialize_params {
#             image = "debian-cloud/debian-11-bullseye-v20231212"
#         }
#     }

#     network_interface {
#         network = "default"
#         access_config {
#         }
#     }

#     metadata_startup_script = <<-EOT
#         #!/bin/bash
#     EOT
#     allow_stopping_for_update = true
# }
