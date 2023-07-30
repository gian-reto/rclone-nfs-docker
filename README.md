# rclone-nfs-docker

This Docker image mounts a remote file system using NFS and [rclone](https://github.com/rclone/rclone).

Based on: https://github.com/nedix/s3-nfs-docker

## Usage

Keep in mind that the following commands have only been tested on Debian 11, and might need to be adapted for other distributions.

- Run `sudo modprobe {fuse,nfs,nfsd}` on the host machine to load the necessary kernel modules.
- Make sure the kernel modules are loaded across reboots by running:

```sh
echo fuse | sudo tee /etc/modules-load.d/fuse.conf && \
echo nfs | sudo tee /etc/modules-load.d/nfs.conf && \
echo nfsd | sudo tee /etc/modules-load.d/nfsd.conf
```

### Usage with `docker compose`

```yaml
version: "3.8"
services:
  rclone-nfs:
    build: .
    restart: unless-stopped
    cap_add:
      - SYS_ADMIN
    security_opt:
      - apparmor:unconfined
    devices:
      - /dev/fuse:/dev/fuse:rwm
    tmpfs:
      - /run
    volumes:
      - /etc/passwd:/etc/passwd:ro
      - /etc/group:/etc/group:ro
      - /some/config/dir:/etc/rclone
      - /some/mount/dir:/mnt/rclone #optional
      - /some/cache/dir:/var/rclone #optional
    ports:
      - "2049:2049"
```

**Mount outside container**

```shell
mkdir rclone-nfs \
&& mount -v -o vers=4 -o port=2049 127.0.0.1:/ ./rclone-nfs
```

## Development

1. Clone this repo
2. Execute the `make setup` command
3. Execute the `make up` command
