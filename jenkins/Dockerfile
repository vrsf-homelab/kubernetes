ARG VERSION=2.460-jdk17

FROM jenkins/jenkins:${VERSION}

## Prevent prompting Jenkins to install additional plugins
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

## Copy a list with plugins to be preinstalled
COPY --chown=jenkins:jenkins plugins.txt /usr/share/jenkins/ref/plugins.txt

## Install plugins from the list
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
