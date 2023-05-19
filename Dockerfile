FROM alpine

LABEL "repository"="https://github.com/WiktorJ/github-tag-action"
LABEL "homepage"="https://github.com/WiktorJ/github-tag-action"
LABEL "maintainer"="Wiktor Jurasz"
LABEL "forked"="https://github.com/anothrNick/github-tag-action"

COPY ./contrib/semver /contrib/semver
RUN install /contrib/semver /usr/local/bin
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
