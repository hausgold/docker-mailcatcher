![mDNS enabled schickling/mailcatcher](docs/assets/project.png)

This Docker images provides the
[schickling/mailcatcher](https://hub.docker.com/r/schickling/mailcatcher/)
image as base with the mDNS/ZeroConf stack on top. So you can enjoy the great
[mailcatcher](https://mailcatcher.me/) app, which is accessible by default as
*mailcatcher.local*.

## Requirements

* Host enabled Avahi daemon
* Host enabled mDNS NSS lookup

## Getting starting

You just need to run it like that, to get a working mailcatcher:

```bash
$ docker run --rm hausgold/mailcatcher
```

The port 1080 is proxied by haproxy to port 80 to make *mailcatcher.local*
directly accessible. The port 1025 is untouched.

## docker-compose usage example

```yaml
mailcatcher:
  image: hausgold/mailcatcher
  environment:
    # Mind the missing .local suffix
    - MDNS_HOSTNAME=mailcatcher.test
  ports:
    # The ports are just for you to know when configure your
    # container links, on depended containers
    - "1025"
    - "1080"
```

## Host configs

Install the nss-mdns package, enable and start the avahi-daemon.service. Then,
edit the file /etc/nsswitch.conf and change the hosts line like this:

```bash
hosts: ... mdns4_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] dns ...
```

## Configure a different mDNS hostname

The magic environment variable is *MDNS_HOSTNAME*. Just pass it like that to
your docker run command:

```bash
$ docker run --rm -e MDNS_HOSTNAME=something.else hausgold/mailcatcher
```

This will result in *something.else.local*.

## Further reading

* Docker/mDNS demo: https://github.com/Jack12816/docker-mdns
* Archlinux howto: https://wiki.archlinux.org/index.php/avahi
* Ubuntu/Debian howto: https://wiki.ubuntuusers.de/Avahi/
