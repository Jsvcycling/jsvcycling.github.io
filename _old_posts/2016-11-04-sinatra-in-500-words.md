---
layout: post
title: Sinatra in 500 Words
---

Sinatra is a Domain-Specific Language (DSL) framework for writing web servers in
Ruby. While not as complete and full as the popular Ruby on Rails framework,
Sinatra still has enough built-in functionality to be extremely useful for
anyone looking to develop a basic or even semi-complex web backend. In addition,
the DSL-centered syntax makes Sinatra easy to read, write, and learn.

So without further ado, let's learn some Sinatra.

*NB: This tutorial assumes that you (the reader) have an basic understanding of
an existing backend frameworks (such as Flask or ExpressJS). In addition, a
basic knowledge of Ruby is useful.*

But wait, before we move on, we need to install Sinatra. And in order to install
Sinatra, we first need to install Ruby (if it isn't installed already). To
install Ruby, go to [https://www.ruby-lang.org/](https://www.ruby-lang.org/) and
follow the instructions to install Ruby for your operating system. Once
installed, open a command-line window and run the following command (you may
need to prefix the command with "sudo" if you are on a \*nix operating system):

```bash
gem install sinatra
```

This will automatically download and install the latest version of Sinatra into
the appropriate location(s) on your computer. If you don't encounter any errors,
you're now free to continue.


## The First Page

Let's start by making a super-basic single page Sinatra server. Start by
creating a folder that will hold all our Sinatra code for this tutorial. Once
created, make a file named *server.rb* inside of it and open it up in a text
editor. Put the following code in and save it:

```ruby
require 'sinatra'

get '/' do
  erb :index
end
```

You can probably tell what this code snippet is doing, but just in case let's do
a quick rundown. The first line imports the Sinatra library, the third creates a
route handler for the index route, and the fourth tells Sinatra to render the
*views/index.erb* template. We were able to do all this with just four lines of
code (and one empty line for readability) thanks to Sinatra's amazing DSL.

Great, we're just about halfway done with this tutorial. Next up we need to
create that *views/index.erb* template Sinatra is expect. In order to do this,
first create a directory in our project folder called *views*. Inside that newly
created folder, create a file called *index.erb* and open it in a text editor.
Put the following code in and save it:

```html
<!DOCTYPE html>
<html>
<head>
  <title>Hello World</title>
</head>
<body>
  <h1>Hello World</h1>
</body>
</html>
```

And now comes the moment of truth. Open up a command-line window in the project
folder and run the following command:

```bash
ruby server.rb
```

If all goes well, after a few seconds you should be able to navigate
to [http://localhost:4567/](http://localhost:4567) in your web browser and see
the simple "hello world" page from above.

Congratulations, you've officially written your first Sinatra server!

## Conclusion

While the above sample isn't all that impressive, we were able to write a
fully-functioning web server in just 4 lines of Ruby code. This isn't the extent
of Sinatra's abilities either, this is just the very tip of the iceberg. For its
simplicity, Sinatra still has a surprising number of built-in features, making
it ideal for both "quick and dirty" projects as well as more defined and planned
projects.

So next time you're thinking of writing a web server, consider Sinatra to get
you up and running in no time.
