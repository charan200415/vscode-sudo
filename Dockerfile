# Start from the code-server Debian base image
FROM codercom/code-server:4.0.2

USER coder

# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://rclone.org/install.sh | sudo bash

# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# You can add custom software and dependencies for your environment below
# -----------

# Install a VS Code extension:
# Note: we use a different marketplace than VS Code. See https://github.com/cdr/code-server/blob/main/docs/FAQ.md#differences-compared-to-vs-code
# RUN code-server --install-extension esbenp.prettier-vscode
# You can add custom software and dependencies for your environment here. Some examples:
RUN code-server --install-extension ms-python.python
RUN sudo apt-get install alsa-utils -y
# RUN code-server --install-extension esbenp.prettier-vscode
# RUN sudo apt-get install -y build-essential
# RUN COPY myTool /home/coder/myTool
# Install NodeJS
RUN sudo curl -fsSL https://deb.nodesource.com/setup_15.x | sudo bash -
RUN sudo apt-get install -y nodejs
# Install apt packages:
# RUN sudo apt-get install -y ubuntu-make

# Copy files: 
# COPY deploy-container/myTool /home/coder/myTool

# -----------
RUN sudo apt update && sudo apt install wget -y
RUN sudo apt install python3-pip -y
#RUN 
# Port
RUN echo 'root:root' | sudo chpasswd
RUN sudo chown root:root /etc/sudoers /etc/sudoers.d -R
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
