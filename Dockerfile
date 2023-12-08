FROM ghcr.io/haxall/hxpy:latest

# Build Arguments
ARG WATTILE_BRANCH
ARG WATTILE_RELEASE=0.1.0
ARG USER_NAME=skyspark
ARG GROUP_NAME=skyspark

# Clone Wattile
RUN apt-get -y update; apt-get -y install curl
RUN mkdir /wattile
RUN if [ -n "$WATTILE_BRANCH" ]; then \
        echo "Downloading from: https://github.com/NREL/Wattile/archive/${WATTILE_BRANCH}.tar.gz"; \
        curl -L https://github.com/NREL/Wattile/archive/${WATTILE_BRANCH}.tar.gz | tar zx -C /wattile  --strip-components 1; \
    else \
        echo "Downloading from: https://github.com/NREL/Wattile/archive/refs/tags/${WATTILE_RELEASE}.tar.gz"; \
        curl -L https://github.com/NREL/Wattile/archive/refs/tags/${WATTILE_RELEASE}.tar.gz | tar zx -C /wattile  --strip-components 1; \
    fi

# Copy Wattile and Models
RUN mv /wattile/tests/fixtures /wattile/trained_models
ENV PYTHONPATH=${PYTHONPATH}:${PWD}

# Install Dependices
RUN cd /wattile && pip install .

# Non-Root User/Group
RUN groupadd -r ${GROUP_NAME} && useradd -r -g ${GROUP_NAME} ${USER_NAME}
USER ${USER_NAME}

ENTRYPOINT ["python"]