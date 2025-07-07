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

