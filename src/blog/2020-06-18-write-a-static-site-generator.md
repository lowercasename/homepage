---
title: "You Should Write a Static Site Generator"
date: 2020-06-18
---

Recently, I decided to learn [everyone's new favourite programming language, Rust](https://www.rust-lang.org/). I really, really enjoy Rust, mostly because learning it has made me realise that our human brains must do a vast amount of hiding the compile-time errors of our thoughts from us.

My problem was that I am by no means a patient or an exacting coder. I had a brief look at the Rust book, found some source code which looked well-written, hacked together a command-line utility which sort of worked, and then decided that the best way to learn more would be to move this website over from Jekyll to a handmade static site generator. This meant that I spent hours slowly and meticulously adding `&` to variable names and seeing whether the angry wiggly red lines would move somewhere different instead of, y'know, reading the manual. But hey, many ways to mutate and/or borrow a cat, right?

I don't actually think that using a handmade site generator is particularly brilliant or clever or should be encouraged when amazing open source tools to do this already exist and could probably use the energy of keen programmers to improve their own codebases. _However_, I think that building a static site generator is a fun learning activity in any language because it taught me about:

- Writing, reading, deleting, and copying files
- Parsing text and manipulating strings
- Parsing command line arguments (I could have also built the generator around a config file, with the same general result)
- Writing more efficient code
- Error handling (sort of); I mean I ignored most of what I learned but it's now in my brain somewhere

My result is called [Orogene](https://github.com/lowercasename/orogene). It's named after the characters in N.K Jemisin's astonishing, magisterial _Broken Earth_ trilogy, because I just finished the last book and I feel very emotional. It's messy, panic-prone, and feature-limited, but I'm still really proud of it, and it generated this website. Consider writing your own!