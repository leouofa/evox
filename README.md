# EvoX Songbook Builder

EvoX is a PDF songbook generator for the masses. Making it easy for anyone to create and maintain their very own songbook. 

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
    
This will create the book.pdf inside the __book__ folder.

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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/leouofa/evox.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
