FROM ghcr.io/haxall/hxpy:latest

# clone wattile
RUN apt-get -y update; apt-get -y install curl
RUN mkdir /wattile
RUN curl -L https://github.com/NREL/Wattile/archive/refs/tags/0.1.0.tar.gz | tar zx -C /wattile  --strip-components 1

# Copy wattile and models
RUN mv /wattile/tests/fixtures /wattile/trained_models

ENV PYTHONPATH=${PYTHONPATH}:${PWD}

# Install Dependices
WORKDIR /wattile
RUN pip install .

ENTRYPOINT ["python"]