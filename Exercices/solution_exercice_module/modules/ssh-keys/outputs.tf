output "ssh_keypairs_map" {
  description = "Map des keypairs créées"
  value = {
    for k, v in openstack_compute_keypair_v2.ssh_keypairs : k => {
      id          = v.id
      name        = v.name
      fingerprint = v.fingerprint
    }
  }
}

output "ssh_keys_info" {
  description = "Informations sur les clés SSH"
  value = {
    for k, v in openstack_compute_keypair_v2.ssh_keypairs : k => {
      name             = v.name
      fingerprint      = v.fingerprint
      private_key_file = "${var.project_name}-${var.environment}-${k}-key.pem"
      public_key_file  = "${var.project_name}-${var.environment}-${k}-key.pub"
      algorithm        = var.ssh_keys_config[k].algorithm
    }
  }
  sensitive = false
}

output "private_keys_content" {
  description = "Contenu des clés privées (sensible)"
  value = {
    for k, v in tls_private_key.ssh_keys : k => v.private_key_pem
  }
  sensitive = true
}