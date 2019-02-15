auto-staging-init: terraform-init terraform-init-deployment install-language

auto-staging-apply: terraform-apply terraform-apply-deployment

auto-staging-destroy: terraform-destroy terraform-destroy-deployment

install-language:
	apk update && apk add go && curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

terraform-init:
	cd terraform && \
	terraform init

terraform-init-deployment:
	cd terraform/deployment && \
	terraform init

terraform-apply:
	make build && \
	cd terraform && \
	terraform workspace new ${TF_VAR_branch} || true && \
	terraform workspace select ${TF_VAR_branch} && \
	terraform apply --auto-approve

terraform-apply-deployment:
	cd terraform/deployment && \
	terraform workspace new ${TF_VAR_branch} || true && \
	terraform workspace select ${TF_VAR_branch} && \
	terraform apply --auto-approve

terraform-destroy:
	cd terraform && \
	terraform workspace select ${TF_VAR_branch} && \
	terraform destroy --auto-approve

terraform-destroy-deployment:
	cd terraform/deployment && \
	terraform workspace select ${TF_VAR_branch} && \
	terraform destroy --auto-approve

prepare:
	dep ensure -v

build: prepare
		go build -o bin/auto-staging-lambda-demo
