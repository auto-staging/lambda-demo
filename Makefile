auto-staging-init: terraform-init

auto-staging-apply: terraform-apply

auto-staging-destroy: terraform-destroy

terraform-init:
	cd terraform && \
	terraform init

terraform-apply:
	make build && \
	cd terraform && \
	terraform workspace new ${TF_VAR_branch} || true && \
	terraform workspace select ${TF_VAR_branch} && \
	terraform apply --auto-approve

terraform-destroy:
	cd terraform && \
	terraform workspace select ${TF_VAR_branch} && \
	terraform destroy --auto-approve

build:
	go build -o bin/auto-staging-lambda-demo
