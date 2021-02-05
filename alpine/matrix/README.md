# Matrix synapse service with a TURN server and riot-web frontend

A collection of systemd services that run synapse, riot-web and a TURN server
as systemd portable services.

## Building the squashfs image

Run:

``` {.sourceCode .shell}
$ sh build.sh
```

It will create a rootfs/ folder with an alpine filesystem, install synapse,
compress it into a squashfs image that will be used as a root filesystem for
the container.

If the script finished successfully, you should get an \~25M matrix.raw
image.

## Running the portable services

Attach the container with `sudo portablectl attach ./matrix.raw`.
Start/Stop as any other systemd service, e.g:

``` {.sourceCode .shell}
sudo systemctl stop matrix.service
```

## Install another existing service

``` {.sourceCode .shell}
NAME=riot sh build.sh
sudo systemctl start riot.service
```
