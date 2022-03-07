---
title: "Wiring up Wireguard, Caddy, and Docker on a home server"
date: 2022-02-09
categories: networking
---

I wanted to write a little guide, mostly for my own future use, to describe how
I set up Wireguard on my home sever. Hopefully this will be of use to someone else!

## Why Wireguard?

I run a home server (an old, reliable, much-battered HP Proliant called
Ottoline). It runs a few public-facing websites in Docker containers, like
a library of plants in our house, a [gitea](https://gitea.io/), and
a Nextcloud sever. It also runs a bunch of services which I'd like to keep
private, like a [Glances](https://nicolargo.github.io/glances/) system
monitor and Portainer.

I have a domain name (let's call it **ottoline.com**) which I've linked up
to my home sever via Namecheap's excellent dynamic DNS API. This means
that I can access services on my home server via subdomains:
https://plants.ottoline.com, https://git.ottoline.com,
https://glances.ottoline.com. The subdomains are wired up via
a [Caddy](https://caddyserver.com/) Docker container - requests come in,
are received by Caddy, and are proxied to the internal networks of my
Docker containers.

I want to keep these two nice features the same:

- Accessing services via subdomain names
- Accessing services from outside my home network

But:

- I want to make some services to stay private and some to stay public.

Wireguard felt like the perfect solution - running Wireguard in a Docker
container would allow me to set up a backdoor to my server, accessible only
when I'm connected to the Wireguard VPN. Public services would always work,
but private services would return a 403 error if the request to them came
from outside my home network (and, by extension, my VPN).

Sounds simple! But how do I do it?

## Setting up Caddy

I started by reworking my Caddyfile, Caddy's main configuration file.

For publicly accessible sites, the configuration remained the same:

```
plants.ottoline.com {
  file_server
  root * /usr/share/caddy
  encode gzip
}

nextcloud.ottoline.com {
  reverse_proxy nextcloud:80
}
```

For private sites, I used a [named matcher](https://caddyserver.com/docs/caddyfile/matchers#named-matchers) to match only internal IPs (including Docker's `172.x.x.x` IPs):

```
portainer.ottoline.com {
  @internal {
    remote_ip 192.168.0.0/16 172.0.0.0/8
  }
  handle @internal {
    reverse_proxy portainer:9000
    reverse_proxy portainer:8000
  }
  respond 403
}
```

If the IP is in the `@internal` range, it'll be reverse proxied. Otherwise, Caddy
responds with a 403. Nice!

With this setup in place, I was already half the way there - I could access public
sites from the wider Internet, and private sites only from inside my home network.
Now for the VPN.

## Setting up Wireguard

I added the following section to my `docker-compose.yml` and ran `docker-compose
up -d`:

```
wireguard:
  image: linuxserver/wireguard
  container_name: wireguard
  cap_add:
    - NET_ADMIN
    - SYS_MODULE
  environment:
    - PUID=1000
    - GUID=1000
    - TZ=Europe/London
    - SERVERURL=wireguard.ottoline.com
    - PEERS=2
    - PEERDNS=auto
    - INTERNAL_SUBNET=10.10.10.0
  volumes:
    - ./wireguard:/config
    - /lib/modules:/lib/modules
  ports:
    - 51820:51820/udp
  sysctls:
    - net.ipv4.conf.all.src_valid_mark=1
  restart: unless-stopped
```

I set up two peers - one for my laptop, one for my phone. When this configuration
is run, it will create two peer configuration files, `peer1.conf` and `peer2.conf`,
inside the `./wireguard` directory on the host system. I copied the first one
to `/etc/wireguard/wg0.conf` on my laptop, but I changed the following lines:

```
[Interface]
...
DNS = 192.168.0.4 # My home server's IP address

[Peer]
...
AllowedIPs = 192.168.0.0/16
```

The `AllowedIPs` directive means that when Wireguard is enabled on my laptop, it
will only send requests to the local server (which includes the subdomain names I
set up) through the VPN, and pass everything else outside the VPN. The `DNS` directive
means all DNS queries will go through the home server, which is essential because
Caddy needs to know which requests are internal and which are external.

For my phone, I ran the following command on the server to display a QR code and
scanned it with the excellently no-nonsense Wireguard app:

```
docker exec -it wireguard /app/show-peer 2
```

I then changed the same fields on the phone as I did on my laptop.

## Setting up DNS

The final step in the process is setting up DNS on the home server to forward
DNS queries being sent via Wireguard to the right Caddy routes. I used a lightweight
service called dnsmasq for this. There seem to be a lot of dnsmasq settings one can set,
but these worked for me.

First, I disabled the default systemd-resolved service:

```
systemctl mask systemd-resolved
systemctl stop systemd-resolved
systemctl disable systemd-resolved
```

Then I installed dnsmasq and edited `/etc/dnsmasq.conf`:

```
domain-needed
bogus-priv
cache-size=1000
server=8.8.8.8
server=4.4.4.4
address=/.ottoline.com/192.168.0.4
```

This sets two default DNS servers (8.8.8.8 and 4.4.4.4) for unresolved queries,
and catches all queries to ottoline.com and its subdomains to the home server's
local IP.

Then, turn on dnsmasq:

```
systemctl enable dnsmasq
systemctl start dnsmasq
```

Finally, I needed to edit `/etc/resolv.conf` (I'm not sure why, but considering the rest
of this somehow worked, I'm not counting my blessings). I think that without it,
DNS queries from inside the home server don't resolve). Because on Ubuntu, `resolv.conf`
is controlled by NetworkManager, it's just a symlink and is reset on reboots:

```
ls -la /etc/resolv.conf
lrwxrwxrwx 1 root root 32 Jan 11 10:47 /etc/resolv.conf -> /run/systemd/resolve/resolv.conf
```

I removed the symlink by renaming `/etc/resolv.conf` to `/etc/resolv.conf.bak` and creating
a new, regular `/etc/resolv.conf`, containing the following:

```
nameserver 8.8.8.8
nameserver 8.8.4.4
```

With this final piece in place, I am able to access some of my containers only via the VPN,
and others anytime.

## References

- [Create your own VPN server with WireGuard in Docker](https://www.the-digital-life.com/wireguard-docker/)
- [How to Run Your Own DNS Server on Your Local Network](https://www.cloudsavvyit.com/14816/how-to-run-your-own-dns-server-on-your-local-network/)
