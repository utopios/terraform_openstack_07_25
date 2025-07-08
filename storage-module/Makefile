.PHONY: help init plan apply destroy clean

help: ## Afficher cette aide
	@echo "Commandes disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

init: ## Initialiser Terraform
	cd examples && terraform init

plan: ## Planifier le déploiement
	cd examples && terraform plan

apply: ## Appliquer la configuration
	cd examples && terraform apply

destroy: ## Détruire l'infrastructure
	cd examples && terraform destroy

clean: ## Nettoyer les fichiers temporaires
	rm -rf examples/.terraform*
	rm -f examples/terraform.tfstate*
	rm -f examples/*.tfplan

validate: ## Valider la configuration
	terraform validate
	cd examples && terraform validate

format: ## Formater le code
	terraform fmt -recursive

docs: ## Afficher la documentation
	@cat README.md
