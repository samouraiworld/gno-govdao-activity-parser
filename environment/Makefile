.PHONY: help setup fake-data all

# Default target
help:
	@echo "🚀 GovDAO Environment Setup"
	@echo ""
	@echo "Available targets:"
	@echo "  make all        - Setup and start everything (recommended)"
	@echo "  make setup      - Set up the environment (clone & build Gno)"
	@echo "  make fake-data  - Create fake DAO data for testing"
	@echo ""
	@echo "Quick start:"
	@echo "  make all"

# Setup and start in one command
all:
	@./setup_environment.sh

# Set up the environment
setup:
	@./setup_environment.sh

# Create fake data
fake-data:
	@echo "🎲 Creating fake DAO data..."
	@./create_fake_data.sh
