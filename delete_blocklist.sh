#!/bin/bash

PREFIX="Blocklist (Ads)"
MAX_RETRIES=10

function error() {
	echo "Error: $1"
}

# Set environment variable from local .env for local execution
if [[ -f .env ]]; then
	export $(grep -v '^#' .env | xargs)
fi

if [[ -z "$ACCOUNT_ID" || -z "$API_TOKEN" ]]; then
	error "ACCOUNT_ID and API_TOKEN must be set"
fi

# Get current lists from Cloudflare
current_lists=$(curl -sSfL --retry "$MAX_RETRIES" --retry-all-errors -X GET "https://api.cloudflare.com/client/v4/accounts/${ACCOUNT_ID}/gateway/lists" \
	-H "Authorization: Bearer ${API_TOKEN}" \
	-H "Content-Type: application/json") || error "Failed to get current lists from Cloudflare"

# Get current policies from Cloudflare
current_policies=$(curl -sSfL --retry "$MAX_RETRIES" --retry-all-errors -X GET "https://api.cloudflare.com/client/v4/accounts/${ACCOUNT_ID}/gateway/rules" \
	-H "Authorization: Bearer ${API_TOKEN}" \
	-H "Content-Type: application/json") || error "Failed to get current policies from Cloudflare"

# Delete policy with $PREFIX as name
echo "Deleting policy..."
policy_id=$(echo "${current_policies}" | jq -r --arg PREFIX "${PREFIX}" '.result | map(select(.name == $PREFIX)) | .[0].id') || error "Failed to get policy ID"
curl -sSfL --retry "$MAX_RETRIES" --retry-all-errors -X DELETE "https://api.cloudflare.com/client/v4/accounts/${ACCOUNT_ID}/gateway/rules/${policy_id}" \
	-H "Authorization: Bearer ${API_TOKEN}" \
	-H "Content-Type: application/json" >/dev/null || error "Failed to delete policy"

# Delete all lists with $PREFIX in name
echo "Deleting lists..."
for list_id in $(echo "${current_lists}" | jq -r --arg PREFIX "${PREFIX}" '.result | map(select(.name | contains($PREFIX))) | .[].id'); do
	echo "Deleting list ${list_id}..."
	curl -sSfL --retry "$MAX_RETRIES" --retry-all-errors -X DELETE "https://api.cloudflare.com/client/v4/accounts/${ACCOUNT_ID}/gateway/lists/${list_id}" \
		-H "Authorization: Bearer ${API_TOKEN}" \
		-H "Content-Type: application/json" >/dev/null || error "Failed to delete list ${list_id}"
done
