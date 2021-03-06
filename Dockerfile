FROM phusion/baseimage:focal-1.0.0

LABEL maintainer="mknyunt97@gmail.com"

# update all packages
RUN apt-get update && \
    apt-get upgrade -y -o Dpkg::Options::="--force-confold" && \
    apt-get dist-upgrade -y && \
    apt-get install --no-install-recommends -y \
    # apt-transport-https \
    git \
    iputils-ping \
    # lsb \
    mysql-client \
    p7zip-full \
    htop \
    silversearcher-ag \
    # software-properties-common \
    tmux \
    vim-gui-common \
    wget \
    zip \
    zsh

# install docker
# RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
#     add-apt-repository \
#     "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
#     apt-get update && \
#     apt-get install -y docker-ce \
#     docker-ce-cli \
#     containerd.io && \
#     curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
#     chmod +x /usr/local/bin/docker-compose

# install cheat for system cheatsheet command line
# RUN curl -L https://github.com/cheat/cheat/releases/download/4.2.1/cheat-linux-amd64.gz -o /cheat-linux-amd64.gz && \
#     gunzip /cheat-linux-amd64.gz && \
#     chmod +x /cheat-linux-amd64 && \
#     mv /cheat-linux-amd64 /usr/local/bin/cheat

# args and env variables
ARG TZ=UTC
ARG UID=1000
ARG GID=${UID}
ARG LANG=en_US.UTF-8
ARG WORKSPACE_USER=devuser
ARG WORKSPACE_HOME=/home/${WORKSPACE_USER}
ARG WORKSPACE=/workspace

ENV WORKSPACE_USER=${WORKSPACE_USER}
ENV LANG=${LANG}

# add user for development
RUN useradd -u ${UID} -m ${WORKSPACE_USER}

# change group id
RUN groupmod -g ${GID} ${WORKSPACE_USER}

# run docker without sudo
# RUN usermod -aG docker ${WORKSPACE_USER}

USER ${WORKSPACE_USER}

# configure cheat
# RUN yes | yes | cheat

# install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install zsh plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions

# install dir colors
RUN git clone https://github.com/arcticicestudio/nord-dircolors.git $HOME/nord-dircolors && \
    ln -sr "$HOME/nord-dircolors/src/dir_colors" "$HOME/.dir_colors"

# copy zsh config
COPY zsh/zshrc ${WORKSPACE_HOME}/.zshrc

# copy tmux config
COPY tmux/tmux.conf ${WORKSPACE_HOME}/.tmux.conf

# copy vim config
COPY vim/vimrc ${WORKSPACE_HOME}/.vimrc

# set tmux as default shell in bash
RUN echo '[[ $TERM != "screen" ]] && exec tmux' >> ${WORKSPACE_HOME}/.bashrc

USER root

# set home folder owned by ${WORKSPACE_USER}
RUN chown -R ${WORKSPACE_USER}:${WORKSPACE_USER} ${WORKSPACE_HOME}

# set timezone
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo ${TZ} > /etc/timezone

# create workspace
RUN mkdir ${WORKSPACE} && \
    chown ${WORKSPACE_USER}:${WORKSPACE_USER} ${WORKSPACE}

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod u+x /docker-entrypoint.sh

RUN install_clean

ENTRYPOINT [ "/sbin/my_init", "--", "/docker-entrypoint.sh" ]

VOLUME ["${WORKSPACE}"]

WORKDIR ${WORKSPACE}
