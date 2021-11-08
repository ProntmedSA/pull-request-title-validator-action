FROM alpine:3.10

#LABEL "com.github.actions.name"="Validade Pull Request Title"
#LABEL "com.github.actions.description"="Request changes when no JIRA ticket is found on the PR title"
#LABEL "com.github.actions.icon"="tag"
#LABEL "com.github.actions.color"="gray-dark"

#LABEL version="1.0.0"
#LABEL repository="https://github.com/ProntmedSA/pull-request-title-validator-action"
#LABEL homepage="https://github.com/ProntmedSA/pull-request-title-validator-action"
#LABEL maintainer="Prontmed Architecture Team"

RUN apk add --no-cache bash curl jq

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
