FROM alpine

LABEL "repository"="https://github.com/WiktorJ/github-tag-action"
LABEL "homepage"="https://github.com/WiktorJ/github-tag-action"
LABEL "maintainer"="Wiktor Jurasz"
LABEL "forked"="https://github.com/anothrNick/github-tag-action"

COPY ./contrib/semver /contrib/semver
RUN install /contrib/semver /usr/local/bin
COPY entrypoint.sh /entrypoint.sh

RUN apk add --no-cache git bash curl jq && \
    addgroup -g 1000 mygroup && \
    adduser -D -u 1000 -G mygroup myuser && \
    chown -R myuser:mygroup /github/workspace

USER myuser

RUN git config --global --add safe.directory /github/workspace

ENTRYPOINT ["/entrypoint.sh"]
