# Configuration
SSH_KEY      ?= ~/.ssh/agent-vm
SSH_KEY_NAME ?= agent-vm
SERVER_TYPE  ?= cx23
IMAGE        ?= ubuntu-24.04
FLAKE        ?= .\#agent
TASK         ?= SKY

# Prompt for server name when a target needs it and SERVER wasn't passed
NEEDS_SERVER := provision install connect setup-task fetch-results fetch-all deploy rebuild teardown

ifneq ($(filter $(NEEDS_SERVER),$(MAKECMDGOALS)),)
ifndef SERVER
SERVER := $(shell \
  if [ -f agents.md ] && grep -q '^| [^S]' agents.md; then \
    echo "" >&2; \
    echo "Active agents:" >&2; \
    grep '^| ' agents.md | grep -v '^| Server' | grep -v '^|[-—]' | \
      awk -F'|' '{gsub(/^ +| +$$/, "", $$2); gsub(/^ +| +$$/, "", $$3); printf "  %-16s %s\n", $$2, $$3}' >&2; \
    echo "" >&2; \
  fi; \
  read -p "Server name [agent-01]: " s </dev/tty; \
  echo $${s:-agent-01})
endif
endif

SERVER ?= agent-01

# Derived
SERVER_IP     = $(shell hcloud server ip $(SERVER))
REMOTE        = agent@$(SERVER_IP)
SSH_OPTS      = -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
SCP           = scp -i $(SSH_KEY) $(SSH_OPTS)
SSH           = ssh -i $(SSH_KEY) $(SSH_OPTS)

.PHONY: help list status ssh-keygen _sync provision install connect setup-task fetch-results fetch-all teardown deploy rebuild

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'

list: _sync ## Show active agents
	@cat agents.md

_sync: _init-agents
	@running=$$(hcloud server list -o columns=name -o noheader 2>/dev/null); \
	for s in $$running; do \
		if ! grep -q "^| $$s " agents.md; then \
			echo "Registering missing agent: $$s"; \
			echo "| $$s | unknown | $$(date +%Y-%m-%d) |" >> agents.md; \
		fi; \
	done

status: ## Check which agents are actually running on Hetzner
	@hcloud server list -o columns=name,status,ipv4,type

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

fetch-results: ## Pull output files from the server
	mkdir -p ./results/$(TASK)
	rsync -avz -e 'ssh -i $(SSH_KEY) $(SSH_OPTS)' $(REMOTE):~/tasks/$(TASK)/output/ ./results/$(TASK)/

fetch-all: ## Pull entire task directory including all agent logs
	mkdir -p ./results/$(TASK)
	rsync -avz -e 'ssh -i $(SSH_KEY) $(SSH_OPTS)' $(REMOTE):~/tasks/$(TASK)/ ./results/$(TASK)/

deploy: _register ## Tear down existing server (if any), provision, install NixOS, and push task
	@hcloud server describe $(SERVER) >/dev/null 2>&1 && \
		echo "Tearing down existing server $(SERVER)..." && \
		hcloud server delete $(SERVER) && \
		sleep 5 \
		|| true
	$(MAKE) provision SERVER=$(SERVER)
	$(MAKE) install SERVER=$(SERVER)
	$(MAKE) setup-task SERVER=$(SERVER) TASK=$(TASK)

rebuild: ## Teardown and redeploy from scratch
	$(MAKE) teardown SERVER=$(SERVER)
	$(MAKE) deploy SERVER=$(SERVER) TASK=$(TASK)

teardown: _deregister ## Delete the server
	hcloud server delete $(SERVER)

# --- State management ---

_init-agents:
	@if [ ! -f agents.md ]; then \
		printf '# Agents\n\n| Server | Task | Created |\n|--------|------|---------|\n' > agents.md; \
	fi

_register: _init-agents
	@sed -i '/^| $(SERVER) /d' agents.md
	@echo "| $(SERVER) | $(TASK) | $$(date +%Y-%m-%d) |" >> agents.md

_deregister:
	@if [ -f agents.md ]; then \
		sed -i '/^| $(SERVER) /d' agents.md; \
	fi
