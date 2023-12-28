terraform {
    backend "gcs" {
        bucket  = "tf-bucket-914868"
        prefix  = "terraform/state"
    }

    required_version = ">= 0.13.0"
    required_providers {
        google = {
            source = "hashicorp/google"
            version = "< 5.0, >= 3.83"
        }
        # google-beta = {
        #     source  = "hashicorp/google-beta"
        #     version = "< 5.0, >= 3.45"
        # }
    }
}

provider "google" {
    project = var.project_id
    region  = var.region
    zone    = var.zone
}

module "vm_instances" {
    source = "./modules/instances"
}

module "storage_buckets" {
    source = "./modules/storage"
}

module "networks" {
    source  = "terraform-google-modules/network/google"
    version = "6.0.0"
    # providers = {
    #   google = google2
    # }

    project_id   = var.project_id
    network_name = "tf-vpc-925181"
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = var.region
        },
        {
            subnet_name           = "subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = var.region
        }
    ]
}

resource "google_compute_firewall" "allow-tcp-80-fw" {
    project     = var.project_id
    name        = "tf-firewall"
    network     = module.networks.network_self_link
    description = "Creates firewall rule targeting tcp 80"

    allow {
        protocol  = "tcp"
        ports     = ["80"]
    }

    source_ranges = ["0.0.0.0/0"]
}