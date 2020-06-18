---
title: "Wordpress in a subdirectory with Caddy"
date: 2019-01-10
categories: coding
---

I've recently moved my webserver to [Caddy](https://caddyserver.com/), a fantastic modern webserver which is very user-friendly, with a helpful support community, and most importantly, effortless HTTPS on every site through the good folks at [Let's Encrypt](https://letsencrypt.org/).

The one issue I had with Caddy was running a Wordpress blog which was located on a subdirectory (`https://domain.com/blog`) of the domain `https://domain.com`. Whatever redirect rules I tried, either JS and CSS files wouldn't load, or pretty permalinks (`https://domain.com/blog/category-name/`) wouldn't work at all. Thanks to the people at the Caddy forums, I finally worked out how to combine redirect rules in my Caddyfile to get everything working.

The important thing to note is that there is no need to create two directives in the Caddyfile, one for the main domain, one for the blog - instead, combine the `/blog/` redirect directive directly into the main directive:

``` Caddyfile
domain.com {
	root /var/www/domain.com # Directory on server
	fastcgi / /run/php/php7.2-fpm.sock php # PHP-FPM enabled
	errors /var/log/caddy/domain.com/error.log # Error logging
	# Attempt to rewrite every file under / first to its path, then to a directory, then as a URL query appended to index.php.
	rewrite / {
		to {path} {path}/ /index.php?{query}
	}
	# The same rewrite for Wordpress, with the addition of the /blog/ subdirectory, works flawlessly. Because of the way Caddy's rewrite rules work, any URLs featuring /blog will use this redirect before they attempt the more general rule.
	rewrite /blog {
		to {path} {path}/ /blog/index.php?{query}
	}
	gzip # Compress all files for faster loading.
}
```

This worked great for me!
