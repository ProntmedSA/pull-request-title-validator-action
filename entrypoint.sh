#!/bin/bash
set -e

if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Set the GITHUB_TOKEN env variable."
  exit 1
fi

if [[ -z "$GITHUB_REPOSITORY" ]]; then
  echo "Set the GITHUB_REPOSITORY env variable."
  exit 1
fi

if [[ -z "$GITHUB_EVENT_PATH" ]]; then
  echo "Set the GITHUB_EVENT_PATH env variable."
  exit 1
fi

URI="https://api.github.com"
API_HEADER="Accept: application/vnd.github.v3+json"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"

number=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")
title=$(jq --raw-output .pull_request.title "$GITHUB_EVENT_PATH")
user=$(jq --raw-output .pull_request.user.login "$GITHUB_EVENT_PATH")

# Try to get the JIRA ticket from the title
TASK=$(echo "$title" | grep -E 'CN-[0-9]+' -o || true)

# If no JIRA ticket is included, request changes
if [[ -z "$TASK" || "$TASK" == " " ]]; then
  echo "No JIRA ticket found, requesting changes"
  curl -sSL \
      -H "${AUTH_HEADER}" \
      -H "${API_HEADER}" \
      -X POST \
      -H "Content-Type: application/json" \
      -d "{\"event\": \"REQUEST_CHANGES\",\"body\": \"@${user} o PR não possui o número do ticket do JIRA, por favor inclua um 'CN-XXXX | ' no início do título do seu PR\"}" \
      "${URI}/repos/${GITHUB_REPOSITORY}/pulls/${number}/reviews"
fi
