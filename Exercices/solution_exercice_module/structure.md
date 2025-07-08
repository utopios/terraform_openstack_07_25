# Structure Terraform Modulaire

```
terraform-openstack-modular/
├── main.tf                    # Configuration principale
├── variables.tf               # Variables globales
├── outputs.tf                 # Outputs principaux
├── terraform.tfvars           # Valeurs des variables
├── versions.tf                # Providers
├── locals.tf                  # Variables locales
├── modules/
│   ├── images/
│   │   ├── main.tf           # Création des images
│   │   ├── variables.tf      # Variables du module images
│   │   ├── outputs.tf        # Outputs du module images
│   │   └── versions.tf       # Providers pour images
│   ├── flavors/
│   │   ├── main.tf           # Création des flavors
│   │   ├── variables.tf      # Variables du module flavors
│   │   ├── outputs.tf        # Outputs du module flavors
│   │   └── versions.tf       # Providers pour flavors
│   ├── ssh-keys/
│   │   ├── main.tf           # Génération des clés SSH
│   │   ├── variables.tf      # Variables du module SSH
│   │   ├── outputs.tf        # Outputs du module SSH
│   │   └── versions.tf       # Providers pour SSH
│   ├── networking/
│   │   ├── main.tf           # Réseau, sous-réseau, routeur
│   │   ├── variables.tf      # Variables du module réseau
│   │   ├── outputs.tf        # Outputs du module réseau
│   │   └── versions.tf       # Providers pour réseau
│   ├── security/
│   │   ├── main.tf           # Groupes de sécurité
│   │   ├── variables.tf      # Variables du module sécurité
│   │   ├── outputs.tf        # Outputs du module sécurité
│   │   └── versions.tf       # Providers pour sécurité
│   ├── storage/
│   │   ├── main.tf           # Volumes de stockage
│   │   ├── variables.tf      # Variables du module stockage
│   │   ├── outputs.tf        # Outputs du module stockage
│   │   └── versions.tf       # Providers pour stockage
│   ├── compute/
│   │   ├── main.tf           # Instances VMs
│   │   ├── variables.tf      # Variables du module compute
│   │   ├── outputs.tf        # Outputs du module compute
│   │   ├── versions.tf       # Providers pour compute
│   │   └── user_data/        # Templates user_data
│   │       ├── web_server.tpl
│   │       ├── app_server.tpl
│   │       ├── database.tpl
│   │       ├── monitoring.tpl
│   │       └── cache_server.tpl
│   └── floating-ips/
│       ├── main.tf           # IPs flottantes et associations
│       ├── variables.tf      # Variables du module IPs
│       ├── outputs.tf        # Outputs du module IPs
│       └── versions.tf       # Providers pour IPs
├── environments/
│   ├── dev.tfvars            # Variables environnement dev
│   ├── staging.tfvars        # Variables environnement staging
│   └── prod.tfvars           # Variables environnement prod
└── README.md                 # Documentation
```