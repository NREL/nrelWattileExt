FROM ghcr.io/haxall/hxpy:latest

# Build Arguments
ARG WATTILE_BRANCH
ARG WATTILE_RELEASE=0.1.0
ARG HOST_UID=1022
ARG HOST_GID=1022
ARG USER_NAME=containeruser
ARG GROUP_NAME=containeruser

# Create UID + GID environment variables and assign the values from the build arguments.
ENV HOST_UID=$HOST_UID \
    HOST_GID=$HOST_GID

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

# Create the group and user defined above, then run as the specified user
RUN addgroup --gid $HOST_GID $GROUP_NAME
RUN adduser --uid $HOST_UID --gid $HOST_GID --gecos "" --disabled-password $USER_NAME
USER ${USER_NAME}

ENTRYPOINT ["python"]