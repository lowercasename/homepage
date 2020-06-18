---
title: "Simple image captions in Jekyll"
date: 2018-10-08
categories: coding
---

Images, and image captions, are always a problem in Markdown. Not only is there no real way to semantically signify images using a text-only format, but it's never really obvious how to tie image captions to the images to which they belong.

[This Stack Overflow post](https://stackoverflow.com/a/30366422/1057716) demonstrates the simplest way to display image captions on a Jekyll site or blog while keeping the markup and resulting HTML reasonably semantic. The same process will work for any other site which transforms Markdown into HTML.

Just wrap your caption in any tag, such as an emphasis tag, and put it directly below the image, without a new line. To anyone reading raw Markdown, this will hopefully signify the image and caption are linked. I like using the single asterisk italics tags here and the underscore tags elsewhere, to distinguish actual italicised text from caption text.

``` markdown
![](path_to_image)
*image_caption*
```

For those seeing the HTML, I style the caption using the following CSS. The [`+` selector](https://www.w3schools.com/cssref/sel_element_pluss.asp) will only target an element directly after another, so it doesn't affect any other `<em>` tags on the page.

``` css
img + em {
	font-style: normal; 
	font-size: smaller;
}
```

The CSS stops the caption from being italicised, but if you need to be able to italicise text inside the caption, you could wrap it in bold Markdown tags (`**bold text**`) and add the following CSS:

``` css
img + em > strong {
	font-weight: 400;
	font-style: italic;
}
```
If you need to make text in a caption both italic and bold, rethink your design choices.

To centre-align captions under images, try this:

``` css
img + em {
	display: block;
	text-align: center;
	font-style: normal; 
	font-size: smaller;
}
```