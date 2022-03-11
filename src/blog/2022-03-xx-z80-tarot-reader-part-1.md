---
title: "Hex80, a Z80 Tarot Reader, Part 1"
date: 2022-03-11
categories: microcomputers
---

> A computational process is indeed much like a sorcerer's idea of a spirit. It
> cannot be seen or touched. It is not composed of matter at all. However, it is
> very real. It can perform intellectual work. It can answer questions. It can
> affect the world by disbursing money at a bank or by controlling a robot arm
> in a factory. The programs we use to conjure processes are like a sorcerer's
> spells. They are carefully composed from symbolic expressions in arcane and
> esoteric programming languages that prescribe the tasks we want our processes
> to perform.
>
> [Harold Abelson, Gerald Jay Sussman, and Julie Sussman - _Structure and
> Interpretation of Computer
> Programs_](https://mitpress.mit.edu/sites/default/files/sicp/index.html)

> This talk is called "so you want to be a wizard". The main problem with being
> a wizard is that, of course, computers are not magic! They are logical
> machines that you can totally learn to understand. So this talk is actually
> going to be about learning hard things and understanding complicated systems.
>
> [Julia Evans - 'So You Want To Be a
Wizard'](https://jvns.ca/blog/so-you-want-to-be-a-wizard/)

About two years ago, I watched Ben Eater's [wonderful series of educational
videos](https://www.youtube.com/playlist?list=PLowKtXNTBypFbtuVMUVXNR0z1mu7dp7eH)
on building an 8-bit computer based on the 6502 processor from scratch, using
breadboards and simple components. I discovered Eater's videos when I started
trying to understand how computers worked from their most basic foundations.

I wanted to recreate Eater's computer as soon as I saw it, but I didn't have
a 6502 processor on hand. Fortuitously, I had recently acquired a broken ZX
Spectrum +2A, which used the [Zilog
Z80](https://en.wikipedia.org/wiki/Zilog_Z80), an 8-bit processor of the same
vintage. The case of the Spectrum became part of another project, but I kept the
circuit board, and discovered that the 30 year old processor still worked
perfectly. In short order, I found out that the Z80 DIY and homebrew computer
scene was just as active as the 6502 scene, and with the help of many, many
tutorials, began working on my own homebrew breadboard Z80.

I knew that if I had any chance of creating something useable, I needed to
give myself a clear goal. I decided to build a computer:

1. With a text-based display
2. To which I could connect a PS/2 keyboard
3. Which would implement a simple console interface, into which I could
   type commands and which would respond with messages
4. And which would draw random Tarot cards on request.

And so, the design specification for Hex80, an 8-bit thaumo-computational
interface, was born.

This design spec is a little different from a lot of DIY and kit-based Z80
computers out there, which often connect to the outside world through an RS-232
serial interface, allowing them to run software like BASIC or CP/M. I wanted my
computer to be completely standalone, and implement its own display and input.
This is in many ways more difficult than implementing a serial interface!
There's a reason why many early computers handed all the logic of talking to
humans and showing them pretty things over to [dedicated
terminals](https://en.wikipedia.org/wiki/Computer_terminal).

I've now got relatively far through this spec, and in its current iteration,
Hex80 can implement a console display on an LCD screen using a PS/2 keyboard,
and respond to my commands. I haven't yet programmed the Tarot reader, and the
second version of the Z80 I'm building uses an Arduino Mega to mock the clock,
RAM, and ROM. The final version, however, will either not use an Arduino at all,
or use one only to translate PS/2 keycodes into ASCII keycodes.

This will be a multi-part series of posts which will go through building Hex80
from the bare bones. It won't be a complete introduction to the magical world of
the Z80 or 8-bit computers. Below is a list of some of the best tutorials and
guides which inspired and educated me, and some of these would be a really good
place to start if, like me, until a couple of years ago, you didn't even have
the foggiest idea of what a processor _did_ or how it _worked_.

## Tutorials

- [Ben Eater's 'Build a 6502 computer' series](https://eater.net/6502)
- [Couch to 64k: Building a Z80 Breadboard Computer](https://bread80.com/2020/07/24/couch-to-64k-a-k-a-building-a-z80-breadboard-computer-part-1-pins/)
- [Jack Leightcap's Z80 Homebrew Computer](https://jleightcap.srht.site/project/z801.html)
- [How to program the Z80 periphery](http://www.blunk-electronic.de/train-z/pdf/howto_program_the_Z80-CTC.pdf)

## Resources and inspiration

- [Z80 instruction set table](https://clrhome.org/table/)
- [Z80 Heaven wiki](http://z80-heaven.wikidot.com/)
- [Z80.info](http://z80.info/)
- [Z80 Bits](http://map.grauw.nl/sources/external/z80bits.html)
- [LM80C](https://www.leonardomiliani.com/en/lm80c/)
- [Ben Ryves' Z80 computer](http://www.benryves.com/projects/z80computer)
- [CPUville standalone Z80 computer](http://www.cpuville.com/Projects/Standalone-Z80-computer/Standalone-Z80-home.html)
- [The Second Great Z80 Project](https://lateblt.tripod.com/z80proj2.htm)

## Processor and clock


