![mDNS enabled schickling/mailcatcher](https://raw.githubusercontent.com/hausgold/docker-mailcatcher/master/docs/assets/project.svg)

[![Continuous Integration](https://github.com/hausgold/docker-mailcatcher/actions/workflows/package.yml/badge.svg?branch=master)](https://github.com/hausgold/docker-mailcatcher/actions/workflows/package.yml)
[![Source Code](https://img.shields.io/badge/source-on%20github-blue.svg)](https://github.com/hausgold/docker-mailcatcher)
[![Docker Image](https://img.shields.io/badge/image-on%20docker%20hub-blue.svg)](https://hub.docker.com/r/hausgold/mailcatcher/)

This Docker images provides the [schickling/mailcatcher](https://hub.docker.com/r/schickling/mailcatcher/) image as base
with the mDNS/ZeroConf stack on top. So you can enjoy the great
[mailcatcher](https://mailcatcher.me/) app, which is accessible by default as *mailcatcher.local*.

- [Requirements](#requirements)
- [Getting starting](#getting-starting)
- [docker-compose usage example](#docker-compose-usage-example)
- [Host configs](#host-configs)
- [Configure a different mDNS hostname](#configure-a-different-mdns-hostname)
- [Other top level domains](#other-top-level-domains)
- [How it looks](#how-it-looks)
- [Further reading](#further-reading)

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
services:
  mailcatcher:
    image: hausgold/mailcatcher
    environment:
      # Mind the .local suffix
      MDNS_HOSTNAME: mailcatcher.test.local
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
$ docker run --rm -e MDNS_HOSTNAME=something.else.local hausgold/mailcatcher
```

This will result in *something.else.local*.

You can also configure multiple aliases (CNAME's) for your container by
passing the *MDNS_CNAMES* environment variable. It will register all the comma
separated domains as aliases for the container, next to the regular mDNS
hostname.

```bash
$ docker run --rm \
  -e MDNS_HOSTNAME=something.else.local \
  -e MDNS_CNAMES=nothing.else.local,special.local \
  hausgold/mailcatcher
```

This will result in *something.else.local*, *nothing.else.local* and
*special.local*.

## Other top level domains

By default *.local* is the default mDNS top level domain. This images does not
force you to use it. But if you do not use the default *.local* top level
domain, you need to [configure your host avahi][custom_mdns] to accept it.

## How it looks

![Screenshot of a browser session](https://raw.githubusercontent.com/hausgold/docker-mailcatcher/master/docs/assets/how_it_looks.png)

## Further reading

* Docker/mDNS demo: https://github.com/Jack12816/docker-mdns
* Archlinux howto: https://wiki.archlinux.org/index.php/avahi
* Ubuntu/Debian howto: https://wiki.ubuntuusers.de/Avahi/

[custom_mdns]: https://wiki.archlinux.org/index.php/avahi#Configuring_mDNS_for_custom_TLD
