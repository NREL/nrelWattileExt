FROM ghcr.io/haxall/hxpy:latest

RUN mkdir /wattile

# Important! Assumes docker build path is correctly set to Wattile repo

# Copy wattile and models
COPY ./wattile /wattile/wattile
COPY ./tests/fixtures /trained_models

# TO DO: copying of trained models to change

ENV PYTHONPATH=${PYTHONPATH}:${PWD}

# Install Dependices
COPY ./poetry.lock /wattile
COPY ./pyproject.toml /wattile
RUN pip3 install poetry
RUN poetry config virtualenvs.create false
RUN cd /wattile && poetry install --no-dev

ENTRYPOINT ["python"]

