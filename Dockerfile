FROM postgres:12

# COPY ./sources.list /etc/apt/sources.list
# RUN apt-get update && apt-get install ca-certificates apt-transport-https

ENV PLV8_VERSION=v2.3.12 \
    PLV8_SHASUM="fac8052c926c9ece74f655500caeca50552c0c4b4c7081c0c7946e06ed114d1c  v2.3.12.tar.gz"

RUN buildDependencies="build-essential \
    ca-certificates \
    apt-utils \
    python \
    curl \
    git-core \
    postgresql-server-dev-$PG_MAJOR" \
  && apt-get update \
  && apt-get install -y --no-install-recommends ${buildDependencies} \
  && mkdir -p /tmp/build \
  && curl -o /tmp/build/${PLV8_VERSION}.tar.gz -SL "https://github.com/plv8/plv8/archive/$PLV8_VERSION.tar.gz" \
  && cd /tmp/build \
  && tar -xzf /tmp/build/${PLV8_VERSION}.tar.gz -C /tmp/build/ \
  && cd /tmp/build/plv8-${PLV8_VERSION#?} \
  && make static \
  && make install \
  && strip /usr/lib/postgresql/${PG_MAJOR}/lib/plv8.so \
  && cd / \
  && apt-get clean \
  && apt-get remove -y  ${buildDependencies} \
  && apt-get autoremove -y \
  && rm -rf /tmp/build /var/lib/apt/lists/*
