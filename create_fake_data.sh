#!/usr/bin/env bash

# Script to create fake governance DAO data using gnokey
# This replicates the functionality of CreateFakeGovDAOData

set -e

# Configuration
CHAINID="${CHAINID:-dev}"
REMOTE="${REMOTE:-tcp://127.0.0.1:26657}"
GAS_FEE="${GAS_FEE:-1000000ugnot}"
GAS_WANTED="${GAS_WANTED:-50000000}"
DAO_PKGPATH="gno.land/r/gov/dao/v3/impl"
DAO_PROXY_PKGPATH="gno.land/r/gov/dao"

# Test account (you should replace with your actual test account)
DEFAULT_ACCOUNT="a"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_step() {
    echo -e "${YELLOW}[STEP]${NC} $1"
}

# Function to add a member directly
add_member() {
    local creator=$1
    local new_member_addr=$2
    local tier=$3
    
    log_step "Adding member $new_member_addr to tier $tier"
    
    gnokey maketx call \
        -pkgpath "$DAO_PKGPATH" \
        -func "AddMember" \
        -args "$new_member_addr" \
        -gas-fee "$GAS_FEE" \
        -gas-wanted "$GAS_WANTED" \
        -send "" \
        -broadcast \
        -chainid "$CHAINID" \
        -remote "$REMOTE" \
        "$creator"
    
    log_success "Member added"
}

# Function to create a proposal to add a member
create_member_proposal() {
    local creator=$1
    local new_member_addr=$2
    local tier=$3
    local portfolio=$4
    
    log_step "Creating proposal to add member $new_member_addr to tier $tier"
    
    # Create a Gno script that calls NewAddMemberRequest and then CreateProposal
    local script="package main

import (
    \"gno.land/r/gov/dao\"
    \"gno.land/r/gov/dao/v3/impl\"
)

func main() {
    // Create the proposal request
    req := impl.NewAddMemberRequest(cross, address(\"$new_member_addr\"), \"$tier\", \"$portfolio\")
    
    // Create the proposal with the request
    dao.MustCreateProposal(cross, req)
}"
    
    # Write script to temporary file
    local tmpfile="/tmp/proposal_script.gno"
    echo "$script" > "$tmpfile"
    echo $tmpfile

    sleep 1
    # Execute the script
    gnokey maketx run \
        -gas-fee "$GAS_FEE" \
        -gas-wanted "$GAS_WANTED" \
        -broadcast \
        -chainid "$CHAINID" \
        -remote "$REMOTE" \
        "$creator" \
        $tmpfile
    
    # Clean up
    rm "$tmpfile"
    
    log_success "Proposal created"
}

# Function to vote on a proposal
vote_on_proposal() {
    local voter=$1
    local proposal_id=$2
    local vote_option=$3
    
    log_step "Voting $vote_option on proposal $proposal_id as $voter"
    
    gnokey maketx call \
        -pkgpath "$DAO_PROXY_PKGPATH" \
        -func "MustVoteOnProposalSimple" \
        -args "$proposal_id" \
        -args "$vote_option" \
        -gas-fee "$GAS_FEE" \
        -gas-wanted "$GAS_WANTED" \
        -send "" \
        -broadcast \
        -chainid "$CHAINID" \
        -remote "$REMOTE" \
        "$voter"
    
    log_success "Vote submitted"
}

# Function to execute a proposal
execute_proposal() {
    local executor=$1
    local proposal_id=$2
    
    log_step "Executing proposal $proposal_id"
    
    gnokey maketx call \
        -pkgpath "$DAO_PROXY_PKGPATH" \
        -func "ExecuteProposal" \
        -args "$proposal_id" \
        -gas-fee "$GAS_FEE" \
        -gas-wanted "$GAS_WANTED" \
        -send "" \
        -broadcast \
        -chainid "$CHAINID" \
        -remote "$REMOTE" \
        "$executor"
    
    log_success "Proposal executed"
}

# Main script
main() {
    log_info "Starting fake governance DAO data creation"
    log_info "Using account: $DEFAULT_ACCOUNT"
    log_info "Chain ID: $CHAINID"
    log_info "Remote: $REMOTE"
    echo ""
    
    # Example: Add 3 T3 members directly
    log_info "=== Adding T3 Members ==="
    
    # Member 1: Add a T3 member
    add_member "$DEFAULT_ACCOUNT" \
        "g1fake1member1111111111111111111111" \
        "T3"
    
    # Member 2: Add another T3 member
    add_member "$DEFAULT_ACCOUNT" \
        "g1fake2member2222222222222222222222" \
        "T3"
    
    # Member 3: Add another T3 member
    add_member "$DEFAULT_ACCOUNT" \
        "g1fake3member3333333333333333333333" \
        "T3"
    
    echo ""
    log_info "=== Creating Proposals ==="
    
    # Create proposals to add T2 and T1 members (requires voting)
    # Proposal 1: Add a T2 member
    create_member_proposal "$DEFAULT_ACCOUNT" \
        "g1fake1t2member111111111111111111111" \
        "T2" \
        "# T2 Member Portfolio\n\n- Senior contributor\n- 2+ years experience\n- Active in governance"
    
    # Proposal 2: Add another T2 member
    create_member_proposal "$DEFAULT_ACCOUNT" \
        "g1fake2t2member222222222222222222222" \
        "T2" \
        "# T2 Member Portfolio\n\n- Core developer\n- Community leader\n- Technical expertise"
    
    # Proposal 3: Add a T1 member
    create_member_proposal "$DEFAULT_ACCOUNT" \
        "g1fake1t1member111111111111111111111" \
        "T1" \
        "# T1 Member Portfolio\n\n- Executive team\n- Strategic advisor\n- Long-term vision"
    
    echo ""
    log_info "=== Voting on Proposals ==="
    
    # Vote YES on all proposals (proposal IDs start at 0)
    vote_on_proposal "$DEFAULT_ACCOUNT" "0" "YES"
    
    vote_on_proposal "$DEFAULT_ACCOUNT" "1" "YES"
    
    vote_on_proposal "$DEFAULT_ACCOUNT" "2" "YES"
    
    echo ""
    log_success "Fake data creation completed!"
    log_info "Added 3 T3 members directly"
    log_info "Created 3 proposals (2 for T2, 1 for T1)"
    log_info "Voted YES on all proposals"
    log_info ""
    log_info "Note: Proposals need supermajority to pass"
    log_info "You may need more votes or execute proposals manually"
}

# Show usage if help is requested
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: $0 [account_name]"
    echo ""
    echo "Creates fake governance DAO data using gnokey commands"
    echo ""
    echo "Arguments:"
    echo "  account_name    The gnokey account to use (default: test1)"
    echo ""
    echo "Environment variables:"
    echo "  CHAINID         Chain ID (default: dev)"
    echo "  REMOTE          Remote node address (default: tcp://127.0.0.1:26657)"
    echo "  GAS_FEE         Gas fee (default: 1000000ugnot)"
    echo "  GAS_WANTED      Gas wanted (default: 5000000)"
    echo ""
    echo "Examples:"
    echo "  $0 test1"
    echo "  CHAINID=portal-loop REMOTE=https://rpc.gno.land:443 $0 myaccount"
    exit 0
fi

# Run main function
main
