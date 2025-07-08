# Module Terraform Storage OpenStack

Ce module Terraform permet de créer et gérer des volumes de stockage dans OpenStack avec des fonctionnalités avancées comme les snapshots et volumes de sauvegarde.

## Structure du projet

```
storage-module/
├── main.tf          # Ressources principales du module
├── variables.tf     # Variables d'entrée
├── outputs.tf       # Sorties du module
├── README.md        # Cette documentation
└── examples/
    └── main.tf      # Exemple d'utilisation
```

## Fonctionnalités

- ✅ Création de volumes de stockage
- ✅ Création conditionnelle de snapshots
- ✅ Création conditionnelle de volumes de sauvegarde
- ✅ Gestion des métadonnées et tags
- ✅ Validation des paramètres d'entrée
- ✅ Protection contre la destruction accidentelle

## Prérequis

1. **Provider OpenStack** configuré
2. **Credentials OpenStack** configurées via variables d'environnement

### Configuration des credentials

```bash
export OS_AUTH_URL="https://your-openstack.com/identity"
export OS_USERNAME="your-username"
export OS_PASSWORD="your-password"
export OS_PROJECT_NAME="your-project"
export OS_USER_DOMAIN_NAME="Default"
export OS_PROJECT_DOMAIN_NAME="Default"
```

## Déploiement

```bash
# 1. Aller dans le répertoire d'exemple
cd examples/

# 2. Initialiser Terraform
terraform init

# 3. Planifier le déploiement
terraform plan

# 4. Appliquer la configuration
terraform apply
```

## Variables d'entrée

| Variable | Type | Description | Défaut | Obligatoire |
|----------|------|-------------|---------|-------------|
| `volume_name` | string | Nom du volume principal | - | ✅ |
| `volume_size` | number | Taille du volume en GB (1-1000) | - | ✅ |
| `create_snapshot` | bool | Créer un snapshot du volume | `false` | ❌ |
| `backup_volume_size` | number | Taille du volume de sauvegarde | `null` | ❌ |
| `volume_type` | string | Type de volume OpenStack | `null` | ❌ |
| `availability_zone` | string | Zone de disponibilité | `null` | ❌ |
| `tags` | map(string) | Tags à appliquer | `{}` | ❌ |

## Utilisation

### Exemple simple

```hcl
module "mon_volume" {
  source = "./storage-module"

  volume_name = "app-data"
  volume_size = 20
}
```

### Exemple avec snapshot et sauvegarde

```hcl
module "volume_complet" {
  source = "./storage-module"

  volume_name        = "critical-data"
  volume_size        = 100
  create_snapshot    = true
  backup_volume_size = 120
  
  tags = {
    Environment = "production"
    Critical    = "true"
  }
}
```
