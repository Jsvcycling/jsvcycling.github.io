---
layout: post
title: The Hodgkin-Huxley Model as a Performance Matric
---

<i>The source code associated with this post is available on
[GitHub](https://github.com/Jsvcycling/hh-perf).</i>

In the world of scientific computing, languages like Python, Julia, and even
MATLAB have become the de facto standard. It's understandable why these
languages have become so popular too. For one, you don't have to be a computer
scientist to use them well; just about anyone can pick them up and start
building useful tools. In addition, they're all interpreted languages and don't
need to be compiled before being executed making it faster to iterate on.

While these languages have a lot going for them does performance suffer?
Performance may not always be the most important metric when selecting a
language to use, but as models become more complex performance starts to matter.
In this post, I'll be implementing the well-known Hodgkin-Huxley model in
several different programming languages to see how their performance compares.

The [Hodgkin-Huxley](https://en.wikipedia.org/wiki/Hodgkin%E2%80%93Huxley_model)
model is a mathematical model that describes the propagation of action
potentials in neurons. It was developed by Alan Lloyd Hodgkin and Andrew
Fielding Huxley in 1952 to describe the giant axon in squid. Since then, it has
become a fairly standard model in mathematical neuroscience. I won't be
discussing the model itself in much more detail since we're really only
concerned with it's performance but below are a few of the important
equations. I do however highly recommend the Wikipedia page for a brief but
thorough discussion on it.

$$C_m\frac{dV_m}{dt} = I_{app} - I_K - I_{Na} - I_l$$

$$I_K = \bar{g}_Kn^4(V_m - V_K)$$

$$I_{Na} = \bar{g}_{Na}m^3h(V_m - V_{Na})$$

$$I_l = \bar{g}_l(V_m - V_l)$$

Because this model is a complex derivative, we're going to solve it numerically
using the second-order Runge-Kutta method known as [Heun's
method](https://en.wikipedia.org/wiki/Heun's_method) (sometimes referred to as
the modified Euler method). In addition, we'll be simulating it for a 10 seconds
with an a constant applied current ($$I_{app}$$) of 12 nA (that's nano-amperes
if you didn't know). All other values and equations are pulled from the original
model.

All tests are executed on a [Linode](https://www.linode.com/) nanode instance
running Debian 9 amd64 (<i>I'm currently working to get MATLAB setup on a nanode
instance</i>). The table below briefly tabulates the average performance results
across three attempts.

| Language   | Version   | Run-time | Memory usage |
|------------|-----------|----------|--------------|
| C float    | gcc 6.3.0 | 0.966 s  | 20.348 MB    |
| C double   | gcc 6.3.0 | 0.919 s  | 39.901 MB    |
| C++ float  | g++ 6.3.0 | 1.092 s  | 22.254 MB    |
| C++ double | g++ 6.3.0 | 1.273 s  | 41.723 MB    |
| Julia      | 1.0.1     | 6.287 s  | 222.613 MB   |
| Python     | 3.5.3     | 68.954 s | 64.082 MB    |

Now let's dive a little bit more into the results of each language.

<h3>C</h3>

There's nothing really all that surprising about C's performance here in
general. The combination of performance and low memory usage is something that C
developers have raved about for years. After years of using C here and there I
too have come to expect a result like this and I wasn't disappointed. Also of
note is that the performance when using double-precision values was actually
faster on average than single-precision. Although I didn't expect
double-precision to be significantly slower I most definitely didn't expect it
to be faster. I wonder what the reasoning for this could be. Statistical error?
Process scheduling? Aliens? We may never know.

What I did find challenging about implementing the model in C was the
plotting. Although the plotting isn't being taken into account with the
performance test, I'm using plotting to visually validate that the model is
working correctly. However, unlike Python, Julia, and other common data sciencpe
languages, C doesn't exactly have a plotting library that I can just link my
program to and use. Instead, I had to open up a pipe stream to gnuplot and
stream in the resulting model before plotting it to a PNG file. While this work
file for me and for something simple like this, it's definitely not as scalable
as say Python's matplotlib. Not to mention that I'm fairly comfortable coding in
C and Linux, something that many data scientists and mathematicians can't say.

To sum it all up, while C scores really highly on performance, it really suffers
when it comes to usability. Not to mention that the C ecosystem is still fairly
fragmented when it comes to operating system features and compilers.

<h3>C++</h3>

Much like the results with C, C++ didn't really provide any big surprises. It's
ever-so-slightly lower performance and small additional memory overhead are all
characteristic of the relationship between C and C++. However, in a real-world
situation, the addition of OOP and features added in C++11 and beyond make it a
viable alternative for those who can afford the overhead. Notably, here we see
that the double-precision version ran in just under 200 ms slower than the
single-precision version. Even still, the C++ implementation comes out ahead of
many of the other competitors (except for C, obviously).

Again though, I again experienced challenges with plotting and although C++ has
slightly better offerings than C, I decided to stick with what I knew worked and
ported over the gnuplot code (it wasn't really a port, more like a Ctrl-C Ctrl-V
but same idea).

I really don't have much else to say about C++ since a lot of what was said
about C applies here as well. If you want OOP and fancy "modern" language
features but still really care about performance then C++ is the way to
go. Otherwise, it's probably best to stick with the more traditional data
science languages.

<h3>Julia</h3>

I'll admit it, I was really expecting a lot from Julia. I've heard a lot of
people say that it's the future of data science. Instead of delivering on those
expectations though it's feels a bit like a mixed bag. I can't really be too
harsh on Julia though; this is my first time ever writing a line of code in
Julia. I wouldn't be surprised at all if I implemented the problem in a way that
just doesn't work well in Julia.

I'm not too concerned with the performance itself: 6 seconds is nothing to laugh
at. What really concerns me is the memory usage. Although it ran 10x faster,
Julia required over 3x as much memory as Python 3 (and almost 11x as much as C
required). The Hodgkin-Huxley model is a rather simple model and there's no
reason it should be using that much memory.

In my opinion, Julia is a language that has a lot of potential when it comes to
the computational sciences. Since I've never before used Julia I'm fully willing
to admit that I did something wrong and that the 222 MB statistic can actually
be lower. I really hope that this is the case too. Julia seems to be a language
that fits nicely between C and Python in terms of performance and
usability. It's very well documented and it looks to have a fairly active
community behind it. I'm definitely interested in learning more about it and
using it in the future. Hopefully I'll figure out a way to bring that memory
usage down to a more reasonable level.

<h3>Python</h3>

I'm not sure what I found more surprising: Julia's memory usage or Python's
run-time. I mean, I didn't expect anything near C or C++ level performance, but
10x slower than Julia seems a bit excessive. Python 3 is a language that I tend
to feel fairly comfortable proficient in so I don't believe that I wrote
inherently poor code. Could my use of numpy be causing the slow down? In my past
experiences with Python 3 as a data science language and using packages like
numpy (and pandas in many cases), I found that it was generally faster than
standard python lists.

I might have to take another look at the Python 3 implementation and see if
there's a more efficient and "python-ic" way to solving the equation. I know
Python is relatively slow, but 68 seconds just seems way too damn slow compared
to what I know and my own past experience. I really hope I just made some kind
of newbie mistake or something with the Python implementation because otherwise
I think I'll have to re-evaluate my usage of Python for data science.

<h2>Conclusion</h2>

Overall, I didn't really find anything to be mid-boggling in any way. While
Julia's memory usage and Python's run-time were pretty bad I can't say I didn't
expect them (well the Python one at least, I didn't really know what to expect
from Julia). C and C++ are still king when it comes to raw performance but they
really lack the approachability and easy-of-use that languages like Python 3 and
Julia can offer. With the exception of the memory usage, I feel that Julia has
the best balance between power and usability of the languages that were
tested. Because of this, I'm really interested to learn about it more and maybe
even start applying it to my data science needs both with my current research
position and in my personal projects.

If I am able to find the time later on, I plan on diving more deeply into my
concerns with Julia and Python 3 and figure out of I'm able to solve them. I
also would like to test more languages like MATLAB, R, Ruby, Octave, and any
others that I can think of between now and then. For now though, this simple
performance test will have to suffice.
