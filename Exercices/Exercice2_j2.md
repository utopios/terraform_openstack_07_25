## Exercice : Module Terraform pour gestion de volumes OpenStack

### Objectif
Créer un module Terraform réutilisable pour la gestion de volumes de stockage dans OpenStack, puis l'utiliser dans une configuration principale.

### Structure attendue
```
storage-module/
├── main.tf
├── variables.tf
├── outputs.tf
└── examples/
    └── main.tf
```

### Module à créer (`storage-module/`)

**Fonctionnalités du module :**
1. Créer un volume de stockage principal
2. Créer optionnellement un snapshot
3. Créer optionnellement un volume de sauvegarde depuis le snapshot

**Variables d'entrée :**
- `volume_name` : nom du volume principal
- `volume_size` : taille en GB
- `create_snapshot` : booléen pour créer le snapshot
- `backup_volume_size` : taille du volume de sauvegarde (optionnel)

**Outputs :**
- ID du volume principal
- ID du snapshot (si créé)
- ID du volume de sauvegarde (si créé)

### Utilisation du module (`examples/main.tf`)

Utiliser le module pour créer :
1. Un volume "app-data" de 30GB avec snapshot
2. Un volume "logs" de 10GB sans snapshot
3. Un volume "database" de 50GB avec snapshot et volume de sauvegarde
