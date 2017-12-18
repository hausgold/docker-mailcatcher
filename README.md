![mDNS enabled schickling/mailcatcher](https://raw.githubusercontent.com/hausgold/docker-mailcatcher/master/docs/assets/project.png)

This Docker images provides the [schickling/mailcatcher](https://hub.docker.com/r/schickling/mailcatcher/) image as base
with the mDNS/ZeroConf stack on top. So you can enjoy the great
[mailcatcher](https://mailcatcher.me/) app, which is accessible by default as *mailcatcher.local*.

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
    # Mind the .local suffix
    - MDNS_HOSTNAME=mailcatcher.test.local
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
$ docker run --rm -e MDNS_HOSTNAME=something.else.local hausgold/mailcatcher
```

This will result in *something.else.local*.

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
