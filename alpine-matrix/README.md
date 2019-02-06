Matrix synapse service with IRC and Telegram gateways
=====================================================

A collection of systemd services that run synapse, matrix-appservice-irc
and mautrix-telegram in a read-only alpine squashfs image.

Building the squashfs image
---------------------------

Run:

``` {.sourceCode .shell}
$ sh build.sh
```

It will create a rootfs/ folder with an alpine filesystem, install
synapse, matrix-appservice-irc and mautrix-telegram and compress it into
a squashfs image that will be used as a root filesystem for the
container.

If the script finished successfully, you should get an \~50M matrix.raw
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
Created directory /etc/systemd/system.attached/matrix-telegram.service.d.
Written /etc/systemd/system.attached/matrix-telegram.service.d/20-portable.conf.
Created symlink /etc/systemd/system.attached/matrix-telegram.service.d/10-profile.conf → /usr/lib/systemd/portable/profile/default/service.conf.
Copied /etc/systemd/system.attached/matrix-telegram.service.
Created directory /etc/systemd/system.attached/matrix-appservice-irc.service.d.
Written /etc/systemd/system.attached/matrix-appservice-irc.service.d/20-portable.conf.
Created symlink /etc/systemd/system.attached/matrix-appservice-irc.service.d/10-profile.conf → /usr/lib/systemd/portable/profile/default/service.conf.
Copied /etc/systemd/system.attached/matrix-appservice-irc.service.
Created symlink /etc/portables/matrix.raw → /home/vladan/dev/portabled/alpine-matrix/matrix.raw.
```

Start/Stop as any other systemd service, e.g:

``` {.sourceCode .shell}
sudo systemctl start matrix-appservice-irc.service matrix-telegram.service
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
    etc. to `/var/lib/matrix-{synapse,telegram,appservice-irc}`.

Warning
-------

You\'ll need to modify the configuration if the services are configured
to log to disk, i.e. modify any filesystem except
`/var/lib/matrix-{synapse,telegram,appservice-irc}`.

TODO
----

-   Use a Makefile to build the image. Add attach, detach and clean
    targets.
-   Rename matrix.service to matrix-synapse.service and add
    matrix.target that starts matrix.service
