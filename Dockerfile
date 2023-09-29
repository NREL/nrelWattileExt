FROM ghcr.io/haxall/hxpy:latest

# Build Arguments
ARG WATTILE_VERSION=0.1.0
ARG USER_NAME=skyspark
ARG GROUP_NAME=skyspark

# Clone Wattile
RUN apt-get -y update; apt-get -y install curl
RUN mkdir /wattile
RUN curl -L https://github.com/NREL/Wattile/archive/refs/tags/${WATTILE_VERSION}.tar.gz | tar zx -C /wattile  --strip-components 1

# Copy Wattile and Models
RUN mv /wattile/tests/fixtures /wattile/trained_models
ENV PYTHONPATH=${PYTHONPATH}:${PWD}

# Install Dependencies
WORKDIR /wattile
RUN pip install .

# Non-Root User/Group
RUN groupadd -r ${GROUP_NAME} && useradd -r -g ${GROUP_NAME} ${USER_NAME}
USER ${USER_NAME}

ENTRYPOINT ["python"]