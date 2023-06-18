# rclone-nfs-docker

This Docker image mounts a remote file system using NFS and [rclone](https://github.com/rclone/rclone).

Based on: https://github.com/nedix/s3-nfs-docker

## Usage

- Install `fuse3` on the host machine.
- Run `modprobe {nfs,nfsd}` on the host machine to load the necessary kernel modules.
- Maybe uncomment `user_allow_other` in `/etc/fuse.conf` on the host machine (not sure if this is necessary).

### Standalone

**Start the NFS server on port 1234**

```shell
docker run --rm -it --cap-add SYS_ADMIN --device /dev/fuse -p 1234:2049 --name rclone-nfs \
    ghcr.io/nedix/rclone-nfs-docker
```

**Mount outside container**

```shell
mkdir rclone-nfs \
&& mount -v -o vers=4 -o port=1234 127.0.0.1:/ ./rclone-nfs
```

### As a Docker Compose volume provisioner

```yaml
version: "3.8"

services:
  rclone-nfs:
    image: ghcr.io/nedix/rclone-nfs-docker
    cap_add:
      - SYS_ADMIN
    devices:
      - /dev/fuse:/dev/fuse:rwm
    volumes:
      - /path/to/rclone.conf:/etc/rclone/rclone.conf
    ports:
      - "1234:2049"

  your-service:
    image: foo
    depends_on:
      rclone-nfs:
        condition: service_healthy
    volumes:
      - "rclone-nfs:/mnt/nfs"

volumes:
  rclone-nfs:
    driver_opts:
      type: "nfs"
      o: "vers=4,addr=127.0.0.1,port=1234,rw"
      device: ":/"
```

## Development

1. Clone this repo
2. Execute the `make setup` command
3. Execute the `make up` command
