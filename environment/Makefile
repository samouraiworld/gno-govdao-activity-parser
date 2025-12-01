# Generated
.PHONY: help setup fake-data all

# Configuration (can be overridden)
GNO_REPO ?= git@github.com:gnolang/gno.git
ADDRESS ?= g17raryfukyf7an7p5gcklru4kx4ulh7wnx44ync
BRANCH ?= master

# Default target
help:
	@echo "🚀 GovDAO Environment Setup"
	@echo ""
	@echo "Available targets:"
	@echo "  make all        - Setup and start everything (recommended)"
	@echo "  make setup      - Set up the environment (clone & build Gno)"
	@echo "  make fake-data  - Create fake DAO data for testing"
	@echo ""
	@echo "Configuration (use environment variables to override):"
	@echo "  GNO_REPO        - Gno repository URL (default: git@github.com:gnolang/gno.git)"
	@echo "  ADDRESS         - Gno address for T1 member (default: g17raryfukyf7an7p5gcklru4kx4ulh7wnx44ync)"
	@echo "  BRANCH          - Git branch to use (default: master)"
	@echo ""
	@echo "Examples:"
	@echo "  make all"
	@echo "  make all GNO_REPO=git@github.com:moul/gno.git BRANCH=dev"
	@echo "  make setup ADDRESS=g1youraddress123"
	@echo ""
	@echo "Quick start:"
	@echo "  make all"

# Setup and start in one command
all: 
	@./setup_environment.sh "$(GNO_REPO)" "$(BRANCH)" "$(ADDRESS)" 
	@sleep 5
	@echo "🎲 Creating fake DAO data..."
	@./create_fake_data.sh

# Set up the environment
setup:
	@./setup_environment.sh "$(GNO_REPO)" "$(BRANCH)" "$(ADDRESS)"

# Create fake data
fake-data:
	@echo "🎲 Creating fake DAO data..."
	@./create_fake_data.sh

clean:
	pkill -9 gnodev 