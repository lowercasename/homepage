---
title: "Suspending on idle on Void Linux using Sway WM"
date: 2022-03-16
categories: linux
---

I'm setting up another PC with the delightful [Void
Linux](https://voidlinux.org/) (my third so far!), and I decided I wanted to set
this one up with [Sway WM](https://voidlinux.org/), a Wayland-based window
manager. This is my first time using Wayland (I have, if anything, been
over-cautious), and it's been a real breeze so far. Despite what look like early
teething problems with Sway on Void, as far as I can gather from forums, all I
did to get sway up and running was follow [this
guide](https://gist.github.com/adnan360/6cba05a3881870bf4a9e3ab2cea7709e), the
short version of which is:

    sudo xbps-install sway swayidle elogind dmenu foot
    sudo ln -s /etc/sv/dbus /var/services
    mkdir -p ~/.config/sway
    sudo cp /etc/sway/config ~/.config/sway/config


I then restarted, changed Sway's terminal emulator of choice to `foot` in the
config file, and ran `sway` to start it from the console.

I want my computer's display to shut down after 10 minutes of inactivity, and
for the computer to go to sleep a minute thereafter. For this, I'm using the
excellent Sway companion tool [swayidle](https://github.com/swaywm/swayidle).

In my `~/.config/sway/config` file, I've edited the existing configuration for
swayidle to look like the following:

    exec swayidle -w \
    timeout 600 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' \
    timeout 660 'exec zzz'
    

The `resume` hook after `'exec zzz'` in `swayidle`'s configuration doesn't seem to run on a non-systemd system, so I added a file called `01-turn-screens-on.sh` in `/etc/zzz.d/resume`:

    #!/bin/sh
    swaymsg "output * dpms on"
    

`zzz` runs this script after resuming from sleep, which is exactly what we want.

Finally, I allowed my own non-root user to modify `/sys/power/state`, which is what `zzz` does under the hood. To do so, I added the following line in `/etc/rc.local`, which runs on system startup:

    chown USERNAME: /sys/power/state
    

Replace `USERNAME` with your own username, of course. Alternatively, you could create a group called, for instance, `power`, add your user to that group, and then assign that group to `/sys/power/state` on startup.

This was relatively easy once I'd figured out how all the bits of it interacted, and I'm still not sure why the `resume` hook seems to fire a fter the first line of `swayidle` but not after the second. Nonetheless, this is a lot of work for what seems like such a simple thing, and that's why we love Linux!
