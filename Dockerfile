ARG BASE_IMAGE=node:16.3.0-alpine3.13
FROM ${BASE_IMAGE}
ARG MAINTAINER
LABEL maintainer="${MAINTAINER}"

RUN apk add --no-cache dumb-init
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

ARG USER=node
ARG PACKAGE
USER ${USER}

WORKDIR "/home/${USER}"

RUN mkdir -p "/home/${USER}/.npm" \
    && npm config set prefix "/home/${USER}/.npm" \
    && npm config get prefix

LABEL package="${PACKAGE}"
ARG VERSION
LABEL version="${VERSION}"

ARG PACKAGE_TGZ
COPY "${PACKAGE_TGZ}" "/tmp/${PACKAGE_TGZ}"
RUN npm install -g @mountainpass/addressr

ENV PATH="/home/${USER}/.npm/bin:$PATH"

ENV ELASTIC_PORT="9200"
# Use a more generic default
ENV ELASTIC_HOST="localhost" 
# ENV ELASTIC_USERNAME=
# ENV ELASTIC_PASSWORD=
# ENV ELASTIC_PROTOCOL=

ENV ADDRESSR_INDEX_TIMEOUT="30s"
ENV ADDRESSR_INDEX_BACKOFF="1000"
ENV ADDRESSR_INDEX_BACKOFF_INCREMENT="1000"
ENV ADDRESSR_INDEX_BACKOFF_MAX="10000"

CMD ["addressr-server-2"]
