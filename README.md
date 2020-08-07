# Raphael's website

This is the source of Raphael's website at [raphaelkabo.com](https://raphaelkabo.com), minus the `src/assets` directory. It is generated into a static HTML site with [Orogene](https://github.com/lowercasename/orogene) using the following command line script:

```
orogene -mdv -i src/pages -o build -t src/template.html -s src/style.css -a src/assets -b src/blog -p src/post_template.html
```

Then the `build/` directory is `rsync`ed to my server.