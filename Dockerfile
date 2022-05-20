# syntax=docker/dockerfile:1
FROM homebrew/brew:latest AS brew

USER linuxbrew

RUN sudo apt-get update -qq \
  && sudo apt-get install -qq -y --no-install-recommends openssh-client git \
  && sudo rm -rf /var/lib/apt/lists/*

# Download public key for github.com
RUN --mount=type=ssh mkdir -p -m 0700 /home/linuxbrew/.ssh \
  && ssh-keyscan github.com >> ~/.ssh/known_hosts \
  && git config --global url."git@github.com:".insteadOf https://github.com

# Clone private repository
RUN --mount=type=ssh git -C /home/linuxbrew clone git@github.com:j5pu/bats.git
