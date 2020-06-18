---
title: "A simple Jekyll rsync script"
date: 2018-08-03
categories: coding
---

I've just moved this site to [Jekyll](http://jekyllrb.com), which is the first time I've played around with it properly, and I'm very happy with how easy and logical it has been to use. Thanks, Jekyll.

I keep my Jekyll sites in a folder on my Macbook, and have written this very simple bash script to build and upload any updates to my server. It's a little different to the rsync script available on the Jekyll site because I need it to not delete files and directories I already have on my server when it updates those Jekyll is responsible for. Just change up the bits in all caps to suit you (except the $TARGET variable).

With my configuration, I name my development directory the same as my site URL (raphaelkabo.com, for instance), and then I type `ju.sh raphaelkabo.com` to invoke it. Remember to pop this script in `/usr/local/bin/` or another directory in your path and `chmod +x` it. For a bit more magic, you can also keep the script in a local directory, like `~/scripts/`, then run `ln -s ~/scripts/ju.sh /usr/local/bin/ju` to be able to invoke the script without typing `.sh` at the end. Makes you feel like a badass.

``` bash
#!/bin/sh
TARGET=$1
cd /Users/HOMEDIRECTORY/jekyll-dev-sites/$TARGET/ && jekyll build --incremental && rsync -avh --update /Users/HOMEDIRECTORY/jekyll-dev-sites/$TARGET/_site/ username@REMOTESERVER.COM:/PATH/TO/WWW/DIRECTORY/$TARGET/public_html/
```
