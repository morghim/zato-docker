FROM python:3.9
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install sudo -y \
    && apt-get install librdkafka-dev -y \
    && apt-get install -y --no-install-recommends \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd zato \
    && useradd --comment "Zato Enterprise Service Bus" --home-dir /opt/zato --create-home --shell /bin/bash --gid zato zato \
    && adduser zato sudo
RUN echo "zato:zato" | chpasswd
RUN git clone https://github.com/morghim/zato.git
RUN ./zato/code/install.sh -p python3
# CMD ["/bin/bash"]