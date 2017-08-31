FROM ubuntu:17.04

ARG USER=sam

SHELL ["/bin/bash", "-c"]

RUN set -eux; \
    apt-get update; \
    apt-get dist-upgrade -y; \
    apt-get install --no-install-recommends -y \
        ca-certificates \
        curl \
        iputils-ping \
        locales \
        libgl1-mesa-glx \
        openconnect \
        openssh-client \
        sudo \
        tmux \
        vim \
        ; \
    curl -sSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb > google-chrome-stable_current_amd64.deb; \
    dpkg -i google-chrome-stable_current_amd64.deb || :; \
    apt install --no-install-recommends -f -y; \
    apt-get autoclean; \
    apt-get clean; \

    sed -i '/history-search-\(backward\|forward\)/s/# //' /etc/inputrc; \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen; \
    echo "LANG=en_US.UTF-8" > /etc/default/locale; \
    locale-gen; \

    groupadd --gid 1000 ${USER}; \
    useradd --uid 1000 --gid 1000 --shell /bin/bash --home /home/${USER} ${USER}; \
    mkdir -p /home/${USER}; \
    chown sam:sam /home/${USER}; \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER}; \
    chmod 0400 /etc/sudoers.d/${USER}

USER ${USER}

COPY vdms /usr/local/bin/

# docker build . --build-arg USER=notsam -t vdms
# docker run -e DISPLAY=$DISPLAY --name vdms -it -v /tmp/.X11-unix:/tmp/.X11-unix -v ~/work_ssh/:/home/sam/.ssh/ --privileged --cap-add NET_ADMIN vdms
