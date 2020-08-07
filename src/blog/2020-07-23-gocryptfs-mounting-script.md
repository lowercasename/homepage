---
title: "A simple gocryptfs mounting/unmounting script"
date: 2020-07-23
---

Nothing fancy, but I got bored of typing out both directories when I was mounting or unmounting my gocryptfs filesystem. This script creates a mount folder, mounts to it, and opens it in Thunar. When you unmount, it also deletes that directory if it's empty. Neat, and makes me happy.

``` bash
#! /bin/bash

# cryptmount v1.0.0
# mv this script to /usr/local/bin (or similar)
# Change the directories to match yours
# To mount: cryptmount m
# To unmount: cryptmount u

ACTION=$1
ENCDIR=/path/to/encrypted/directory
MOUNTDIR=/path/to/decrypted/directory
FILEMANAGER=thunar

case $ACTION in

  mount | m)
    if [[ $(findmnt -M $MOUNTDIR) ]]; then
      echo "The encrypted directory is already mounted."
    else
      gocryptfs --version | cut -d';' -f1
      mkdir $MOUNTDIR
      gocryptfs $ENCDIR $MOUNTDIR
      $FILEMANAGER $MOUNTDIR
    fi
    ;;

  unmount | umount | u)
    if [[ $(findmnt -M $MOUNTDIR) ]]; then
      umount $MOUNTDIR
      # Make sure the directory is empty before deleting it
      if [ -z "$(ls -A $MOUNTDIR)" ]; then
        rm -rf $MOUNTDIR
      else
        echo "Mount directory not empty, exiting."
      fi
    else
      echo "The encrypted directory is not mounted."
    fi
    ;;

  *)
    echo 'Please specify an action: mount (m) or unmount (u).'
    ;;

esac
```