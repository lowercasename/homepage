---
title: "A script to create print-ready tiny zine layouts on macOS"
date: 2019-05-25
categories: coding, zines
---

I recently experienced a headache when I was trying to make a very, very small zine.

Zines are great, and small zines are even better - especially for sharing academic research. People love small things; they're memorable; and the small format forces you to really think hard and critically about the most important things you want to say to an audience. You can make zines and give them out before a panel or conference paper!

By far the easiest way to make a small zine is the [fabled one-page zine format](http://experimentwithnature.com/03-found/experiment-with-paper-how-to-make-a-one-page-zine/). All you need for this is a sheet of paper and a pair of scissors, and it transforms a single A4 page into an adorable 8-page booklet, with space for a secret poster on the back.

But I wasn't content with the 8-page format because it loses the entire second side of the page - I wanted to work out the easiest way to create a zine with regular double-sided pages. My solution requires a stapler and probably a guillotine or paper trimmer, because it involves dividing one sheet of paper, printed on both sides, into eight tiny double-sided sheets. Each group of four sheets is then folded in half, for a total of _two_ tiny adorable 16-page zines from one piece of A4 paper.

It's easy enough to mock a zine like this up in Word - just set your paper size to 74mm wide by 52.5mm tall, with 3mm margins. As far as I know, you unfortunately can't set manual paper sizes in Google Docs.

**Important:** you need to create exactly 16 pages of zine. The first page is the front cover; the second page is the inside of the front cover, which you can leave blank if you want; the second-last page is therefore the inside back cover; and the last, sixteenth page is the back cover. This gives you 12 inside pages, or 14 if you write on the inside covers.

 When you're done writing - 10pt or 9pt font is surprisingly legible if you pick a good sans-serif - save the file as a PDF.

 Now comes the difficult part. One of the great benefits of a zine like this is that you can fit two copies of the zine onto one piece of A4 paper, but this requires some truly painful playing around with PDF reordering and n-up layouts. Luckily, the whole point of this blog post is saving you the trouble by automating it for you.

 The first thing you need to do is install MacTeX. If you don't use LaTeX and don't fancy downloading a 3GB file, you only actually need the 70MB BasicTeX package, which is available from [this page](http://www.tug.org/mactex/morepackages.html).

Once you've installed MacTeX, if your Terminal is open, close and open it again. Double-check that the necessary components have been installed by running the following two commands in Terminal - both should give you some information rather than an error or a blank line:

```
pdftex -v
kpsewhich pdfpages.sty
```

Now you need to install the PDFjam tools - these provide an easy wrapper for the PDF tools that come with pdfTeX. The easiest way to do this is to use a small helper script I wrote - open your Terminal and enter this line:

```
curl https://raphaelkabo.com/scripts/pdfjaminstall.sh | bash
```

This script downloads the latest PDFjam source files, extracts them, and installs them in your /usr/bin directory. As ever with strange scripts you find on the internet, you should open the file and read through it to make sure it won't destroy your computer before running the above command.

If you'd rather do it manually, head to [the PDFjam page](https://warwick.ac.uk/fac/sci/statistics/staff/academic-research/firth/software/pdfjam/) and download the pdfjam_latest.tgz file. Extract it, then copy all the files in the bin/ directory to a directory on your path (like /usr/bin).

Verify PDFjam works by running the following command:

```
pdfjam --version
```

Now you're ready to rock! In Terminal, navigate to the directory containing your beautiful 16-page PDF. Enter the following command, substituting the filename of your PDF file:

```
pdfjam --nup 4x4 --a4paper --landscape INPUTFILE.pdf '8,9,6,11,4,13,2,15,8,9,6,11,4,13,2,15,12,5,10,7,16,1,14,3,12,5,10,7,16,1,14,3' -o OUTPUTFILE.pdf
```

The file you get out of this looks completely bonkers, but I assure you that once the file has been printed off, cut, and assembled, you will end up with two perfectly logically ordered zines.

Alternatively, you can download a bash script I wrote, [available here as a Gist](https://gist.github.com/lowercasename/31342fadfc2a5cf608275d1097e23764) which does this for you. Open the link, save the raw file to your computer, navigate to where you downloaded it, and run it like so (you only need to `chmod` it once, to make it executable):

```
chmod +x tinyzine
./tinyzine /path/to/input.pdf
```

To make it easier to use from anywhere, once you've downloaded it, navigate to the directory it's in and execute the following commands:

```
chmod +x tinyzine
sudo mv tinyzine /usr/bin/tinyzine
```

Now you can simply run this command from any directory (like the directory where your PDF file is):

```
tinyzine input.pdf
```

It will create a file in the same directory with the appended name '-16-up'.

Now all that's left is to open your file, print it, cut it into four lengthways strips, cut each strip in half, and assemble your tiny zines! Happy zineing!
