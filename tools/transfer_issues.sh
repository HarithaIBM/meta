#!/usr/bin/env bash

# Set the source and destination repository names
source_repo=ZOSOpenTools/utils
destination_repo=$1

# Set your personal access token
access_token=$ZOPEN_GIT_OAUTH_TOKEN

# Set the API endpoint base URL
api_endpoint=https://api.github.com

# Get the list of issues in the source repository
echo "Fetching list of issues from source repository..."
issues=$(curl -s -H "Authorization: token $access_token" "$api_endpoint/repos/$source_repo/issues")

# Iterate over the list of issues
for issue in $(echo "${issues}" | jq -r '.[] | @base64'); do
	# Decode the issue data
	issue_data=$(echo "${issue}" | base64 --decode)

	# Extract the issue title and body
	title=$(echo "${issue_data}" | jq -r .title | jq -sR .)
	body=$(echo "${issue_data}" | jq -r .body | jq -sR .)
	echo "|$body|"
	echo "|$title|"

	# Create a new issue in the destination repository with the same title and body
	echo "Creating new issue in destination repository: $title"
	new_issue=$(curl -s -X POST -H "Authorization: token $access_token" -H "Content-Type: application/json" "$api_endpoint/repos/$destination_repo/issues" -d "{\"title\":$title,\"body\":$body}")
	echo $new_issue

	# Extract the new issue number
	new_issue_number=$(echo "${new_issue}" | jq -r .number)

	# Iterate over the labels in the source issue
	labels=$(echo "${issue_data}" | jq -r .labels[])
	for label in $(echo "${labels}" | jq -r '.name | @base64'); do
		# Decode the label data
		label_name=$(echo "${label}" | base64 --decode)

		echo "Adding label to new issue: $label_name - $label_data"

		# Check if the label name is non-empty
		if [ -n "$label_name" ]; then
			# Add the label to the new issue
			echo "Adding label to new issue: $label_name"
			curl -s -X POST -H "Authorization: token $access_token" -H "Content-Type: application/json" "$api_endpoint/repos/$destination_repo/issues/$new_issue_number/labels" -d "[\"$label_name\"]"
		fi
	done
done
