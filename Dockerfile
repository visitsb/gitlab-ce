FROM gitlab/gitlab-ce:latest
LABEL maintainer="Shanti Naik <visitsb@gmail.com>"

# https://serverfault.com/a/960335
# chmod doesn't work correctly
USER root

# One-time fix despite running update-permissions (ignore exit codes)
ADD entry /assets/

# Fix to migrate amni.co/git database into dockerized gitlab
# https://daten-und-bass.io/blog/fixing-missing-locale-setting-in-ubuntu-docker-image/
RUN /bin/chmod +x /assets/entry \
    && /usr/bin/apt-get update \
    && DEBIAN_FRONTEND=noninteractive /usr/bin/apt-get install -y locales \
    && /bin/sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && /usr/sbin/dpkg-reconfigure --frontend=noninteractive locales \
    && /usr/bin/localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 \
    ; exit 0
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Override default CMD with our own
# https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/docker/Dockerfile
CMD ["/assets/entry"]
