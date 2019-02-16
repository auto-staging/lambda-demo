auto-staging-init: setup-environment terraform-init terraform-init-deployment

auto-staging-apply: terraform-apply terraform-apply-deployment

auto-staging-destroy: terraform-destroy terraform-destroy-deployment

setup-environment:
	apt-get install golang -y --no-install-recommends && mkdir -p ${GOPATH}/bin && curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh && mv ${GOPATH}/bin/dep /usr/bin/dep

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
	mkdir bin && \
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
