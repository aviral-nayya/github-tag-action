FROM alpine
LABEL "repository"="https://github.com/WiktorJ/github-tag-action"
LABEL "homepage"="https://github.com/WiktorJ/github-tag-action"
LABEL "maintainer"="Wiktor Jurasz"
LABEL "forked"="https://github.com/anothrNick/github-tag-action"

COPY ./contrib/semver ./contrib/semver
RUN install ./contrib/semver /usr/local/bin
COPY entrypoint.sh /entrypoint.sh

RUN apk add --no-cache git
RUN chown -R $USER /github/workspace
RUN git config --global --add safe.directory /github/workspace
RUN apk update && apk add bash git curl jq

ENTRYPOINT ["/entrypoint.sh"]
