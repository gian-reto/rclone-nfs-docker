ARG RCLONE_VERSION=1.65.0

FROM rclone/rclone:$RCLONE_VERSION as rclone

FROM --platform=$BUILDPLATFORM alpine:3.19.0

COPY --from=rclone /usr/local/bin/rclone /usr/bin/rclone

RUN apk --no-cache add \
        ca-certificates \
        fuse3 \
        tzdata \
        inotify-tools \
        nfs-utils \
        nfs-utils-doc \
        nfs-utils-openrc \
        openrc \
        psmisc && \
        echo "user_allow_other" >> /etc/fuse.conf

ADD rootfs /

RUN chmod +x \
        /entrypoint.sh \
        /usr/local/bin/timestamp_updater.sh \
        /etc/init.d/rclone \
        /etc/init.d/timestamp_updater

RUN mkdir -p \
        /etc/rclone

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 2049/tcp

VOLUME ["/etc/rclone", "/mnt/rclone"]

HEALTHCHECK CMD mountpoint -q /mnt/rclone || exit 1
