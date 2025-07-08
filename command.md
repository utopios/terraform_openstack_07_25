## Commande pour installer terraform sur alma

sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

sudo dnf install terraform

## Conditions de validation.

- length() => vérifier la longueur.
- contains() => Vérifier si une valeur est dans une liste.
- can() => tester si une expression est valide.
- regex() => validation des expressions regulières.

## inserer les valeurs des variables

- terrafrom plan -var="var1=value"
- terraform plan -var-file="chemin.tfvars"
- variable d'environnement (var1)
    - TF_VAR_var1 = "" 
- fichier auto.tfvars
- valeur du paramètre default
- intéractive (avec le prompt)


## Test de validation de base

- Validation syntaxique

```bash
terraform validate
```

- Fromatage du code
```bash
terraform fmt -check
```

## Variables d'environnement pour les logs
- TF_LOG=TRACE (DEBUG, INFO, WARN, ERROR) (Log provider et core terraform)
    - TF_LOG_PROVIDER=TRACE
    - TF_LOG_CORE=DEBUG
- TF_LOG_PATH=./terraform.log

## Générer un graph de dépendances
terraform graph | dot -Tpng > graph.png