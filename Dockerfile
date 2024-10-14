## NOTE: Temporarily not pulling hxpy image
## Need hxpy updated to use Python 3.10+
## Until then, re-create hxpy build here
#FROM ghcr.io/haxall/hxpy:3.1.10
FROM python:3.11-slim

# Build Arguments
ARG WATTILE_BRANCH
ARG WATTILE_TAG
ARG WATTILE_VERSION=0.3.0
ARG HOST_UID=1022
ARG HOST_GID=1022
ARG USER_NAME=skyspark
ARG GROUP_NAME=skyspark

# Temporary build argument: Haxall version to clone
ARG HAXALL_TAG=v3.1.10

# Install curl
RUN apt-get -y update; apt-get -y install curl

## TEMPORARY: Start hxpy image block ##
# Reference: https://github.com/haxall/haxall/blob/3.1.10/src/lib/hxPy/py/hxpy/Dockerfile
# Working directory
WORKDIR /usr/src/app

# Clone Haxall
RUN mkdir /haxall
RUN curl -L https://github.com/haxall/haxall/archive/refs/tags/${HAXALL_TAG}.tar.gz \
    | tar zx -C /haxall  --strip-components 1

# Copy hxpy
RUN cp -r /haxall/src/lib/hxPy/py/hxpy/* .

# Install Python packages
RUN pip install --no-cache-dir -r ./requirements.txt

# For Haxall <-> Docker communication?
EXPOSE 8888

# Clean up
RUN rm -r /haxall
## TEMPORARY: End hxpy image block ##

# Create UID + GID environment variables and assign the values from the build arguments.
ENV HOST_UID=$HOST_UID \
    HOST_GID=$HOST_GID

# Install Wattile
RUN mkdir /wattile
RUN <<EOT
  if [ -n "$WATTILE_BRANCH" ]
  then
    # Download Wattile branch
    echo "Downloading from: https://github.com/NREL/Wattile/archive/${WATTILE_BRANCH}.tar.gz"
    curl -L https://github.com/NREL/Wattile/archive/${WATTILE_BRANCH}.tar.gz | tar zx -C /wattile  --strip-components 1
    
    # Run pip install
    cd /wattile
    pip install .
    
  elif [ -n "$WATTILE_TAG" ]
  then
    # Download Wattile tag
    echo "Downloading from: https://github.com/NREL/Wattile/archive/refs/tags/${WATTILE_TAG}.tar.gz"
    curl -L https://github.com/NREL/Wattile/archive/refs/tags/${WATTILE_TAG}.tar.gz | tar zx -C /wattile  --strip-components 1
    
    # Run pip install
    cd /wattile
    pip install .
    
  else
    # Install from PyPi
    echo "Installing Wattile ${WATTILE_VERSION} from PyPi"
    pip install wattile==${WATTILE_VERSION}
  fi
EOT

# Create the group and user defined above, then run as the specified user
RUN addgroup --gid $HOST_GID $GROUP_NAME
RUN adduser --uid $HOST_UID --gid $HOST_GID --gecos "" --disabled-password $USER_NAME
USER ${USER_NAME}

ENTRYPOINT ["python"]