Matrix synapse service with IRC and Telegram gateways
=====================================================

A collection of systemd services that run synapse and the IRC gateway
(matrix-appservice-irc) in an isolated read-only alpine squashfs image.

Building the squashfs image
---------------------------

Run:

``` {.sourceCode .shell}
$ sh build.sh
```

It will create a rootfs/ folder with an alpine filesystem, install synapse,
matrix-appservice-irc and compress it into a squashfs image that will be used
as a root filesystem for the container.

If the script finished successfully, you should get an \~45M matrix.raw
image.

Running the portable services
-----------------------------

Attach the container with `sudo portablectl attach ./matrix.raw`.

The output should look something like this:

``` {.sourceCode .shell}
$ sudo portablectl attach ./matrix.raw

Created directory /etc/systemd/system.attached.
Created directory /etc/systemd/system.attached/matrix.service.d.
Written /etc/systemd/system.attached/matrix.service.d/20-portable.conf.
Created symlink /etc/systemd/system.attached/matrix.service.d/10-profile.conf → /usr/lib/systemd/portable/profile/default/service.conf.
Copied /etc/systemd/system.attached/matrix.service.
Created directory /etc/systemd/system.attached/matrix-appservice-irc.service.d.
Written /etc/systemd/system.attached/matrix-appservice-irc.service.d/20-portable.conf.
Created symlink /etc/systemd/system.attached/matrix-appservice-irc.service.d/10-profile.conf → /usr/lib/systemd/portable/profile/default/service.conf.
Copied /etc/systemd/system.attached/matrix-appservice-irc.service.
Created symlink /etc/portables/matrix.raw → /tmp/matrix.raw.


Start/Stop as any other systemd service, e.g:

``` {.sourceCode .shell}
sudo systemctl start matrix-appservice-irc.service
sudo systemctl stop matrix.service
```

Existing matrix installations
-----------------------------

1.  Stop your current services.
2.  Copy all configuration files to `/etc/matrix`.
3.  Run all portable services, so that they create all directories in
    `/var/lib`.
4.  Copy all data files, e.g. homeserver.db if you\'re using sqlite,
    media and upload folders for synapse, rooms.db for the irc gateway,
    etc. to `/var/lib/matrix-{synapse,appservice-irc}`.

Warning
-------

You should set up all logging to stdout.

Any configuration that has something to do with the filesystem should be
configured to write files to `/var/lib/matrix-{synapse,appservice-irc}`.

TODO
----

-   Use a Makefile to build the image. Add attach, detach and clean
    targets.
