# EvoX 
EvoX is a PDF songbook generator for the masses. Making it easy for anyone to create and maintain their very own songbook. 

#### Why
I wanted to create a songbook of the songs I like to play, but being a programmer it made a total sense to build a songbook builder first.

#### Features
- It makes a PDF Songbook (obviously).
- Super sexy cover page, with logo support.
- It features a super simple plain-text markup language making it easy for people to create & share songs.
- Multiple column support.
- Per song font setting and column size adjustments.
- Table of content with page numbers.

## Installation
Install evox with:

    $ gem install evox

## Usage

Create a directory to house your songbook

    $ mkdir superbook
    $ cd superbook
 
Initialize the songbook
    
    $ evox init
    
This will create 3 different directories __book__, __cover__, and __songs__.

Next, generate the sample song book.

    $ evox generate
    
This will create the book.pdf inside the book folder.

### The Cover
Inside the cover folder there are 2 files, the __config.yml__ and __logo.png__.
The logo file is just an example you can replace with your own. 

The __config.yml__ allows you to adjust the cover heading, subheading, logo-size, and footer text. You can also change the name of the logo file.

```yaml
header:
  top_padding: 20
  title: 'The Great Book of Songs'
  title_size: 35
  subtitle: 'Version 0.5'
  subtitle_size: 15
  bottom_padding: 50
logo:
  image: logo.png
  width: 393.5
  height: 457
footer:
  title: 'Compiled by Leonid Medovyy'
  title_size: 25
```

### The Songs
The songs are just files with .evox extension that live inside the __songs__ directory, and are printed in alphabetical order when the songbook is generated.

The song settings are located in between the double equal signs. Font size, column gutter size and total column width can be adjusted.
```yaml
==
name: Free Falling
author: Tom Petty
font: 9.0
column_width: 610
gutter: 5
==
```


The columns are created by placing lyrics inside double dashes. 

Lyrics themselves start with spaces, and chords start with a period. 
This concept is inspired by [OpenSong](http://www.opensong.org/).
```yaml
--
.        C    F     F     C     G
 She's a good girl, loves her mama
.     C    F     F     C    G
 Loves Jesus and America too
.        C    F     F        C   G
 She's a good girl, crazy 'bout Elvis
.      C    F         F    C    G
 Loves horses and her boyfriend too
--

--
.       C    F        F     C   G
 It's a long day of livin' in Reseda
.          C    F    F       C          G
 There's a freeway runnin' through the yard
.          C    F             F     C     G
 And I'm a bad boy, 'cause I don't even miss her
.      C   F         F    C        G
 I'm a bad boy for breakin' her heart
--
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/leouofa/evox.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
