FROM alpine:3.6

RUN apk add --update\
    curl unzip \
    bash vim

WORKDIR /tmp

RUN curl -so packer.zip https://releases.hashicorp.com/packer/1.0.2/packer_1.0.2_linux_amd64.zip \
    && unzip packer.zip -d /usr/local/bin/ \
    && rm packer.zip

COPY . .

# Uncomment for work on the Docker builder container
# CMD ["/bin/bash", "-c", "bash"]

ENTRYPOINT ["packer", "build"]
CMD ["us-east-2_create-dockerhost-ami.json"]