# Configuration
SERVER       ?= agent-01
SSH_KEY      ?= ~/.ssh/agent-vm
SSH_KEY_NAME ?= agent-vm
SERVER_TYPE  ?= cx23
IMAGE        ?= ubuntu-24.04
FLAKE        ?= .\#agent
TASK         ?= SKY
SERVER_IP     = $(shell hcloud server ip $(SERVER))
REMOTE        = agent@$(SERVER_IP)
SSH_OPTS      = -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
SCP           = scp -i $(SSH_KEY) $(SSH_OPTS)
SSH           = ssh -i $(SSH_KEY) $(SSH_OPTS)

.PHONY: help ssh-keygen provision install connect setup-task fetch-results teardown deploy rebuild

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'

ssh-keygen: ## Generate an ed25519 SSH keypair and register it with Hetzner
	ssh-keygen -t ed25519 -f $(SSH_KEY)
	hcloud ssh-key create --name $(SSH_KEY_NAME) --public-key-from-file $(SSH_KEY).pub

provision: ## Create a Hetzner cloud server
	hcloud server create --name $(SERVER) --type $(SERVER_TYPE) --image $(IMAGE) --ssh-key $(SSH_KEY_NAME)

install: ## Install NixOS on the server via nixos-anywhere
	nix run github:nix-community/nixos-anywhere -- \
		--ssh-option "IdentityFile=$(SSH_KEY)" \
		--ssh-option "StrictHostKeyChecking=no" \
		--ssh-option "UserKnownHostsFile=/dev/null" \
		--flake $(FLAKE) root@$(SERVER_IP)

connect: ## SSH into the server
	$(SSH) $(REMOTE)

setup-task: ## Create task dirs and copy persona/task files to server (TASK=SKY)
	$(SSH) $(REMOTE) "mkdir -p ~/tasks/$(TASK)/{worker,reviewer,editor,output}"
	$(SCP) tasks/$(TASK)-worker.md $(REMOTE):~/tasks/$(TASK)/task.md
	$(SCP) personas/WORKER.md $(REMOTE):~/tasks/$(TASK)/worker/CLAUDE.md
	$(SCP) personas/REVIEWER.md $(REMOTE):~/tasks/$(TASK)/reviewer/CLAUDE.md
	$(SCP) personas/EDITOR.md $(REMOTE):~/tasks/$(TASK)/editor/CLAUDE.md
	$(SCP) tasks/$(TASK)-reviewer.md $(REMOTE):~/tasks/$(TASK)/reviewer/review-instructions.md
	$(SCP) tasks/$(TASK)-editor.md $(REMOTE):~/tasks/$(TASK)/editor/editor-instructions.md

fetch-results: ## Pull results back from the server (TASK=SKY)
	rsync -avz -e "$(SSH)" $(REMOTE):~/tasks/$(TASK)/output/ ./results/$(TASK)/

deploy: ## Tear down existing server (if any), provision, install NixOS, and push task
	@hcloud server describe $(SERVER) >/dev/null 2>&1 && \
		echo "Tearing down existing server $(SERVER)..." && \
		hcloud server delete $(SERVER) && \
		sleep 5 \
		|| true
	$(MAKE) provision
	$(MAKE) install
	$(MAKE) setup-task

rebuild: ## Teardown and redeploy from scratch
	$(MAKE) teardown
	$(MAKE) deploy

teardown: ## Delete the server
	hcloud server delete $(SERVER)
