require "evox/version"
require 'prawn'
require 'commander/import'
require 'yaml'
require 'fileutils'


module Evox
  class Start
    program :name, 'Evox'
    program :version, '1.0.2'
    program :description, 'Rugged Songbook generator'
    default_command :howto

    command :howto do |c|
      c.syntax = 'evox howto'
      c.description = 'Displays instructions for using the evox song book generator'
      c.action do |_args, _options|
        puts '1. Generate initial folder structure by running "evox init"'
        puts '2. Build your songbook by running "evox generate"'
        puts '3. Learn more about the songbook generator at https://github.com/leouofa/evox'
      end
    end

    command :init do |c|
      c.syntax = 'evox init'
      c.description = 'initializes the folder structure & copies default config files'
      c.action do |_args, _options|
        source_folder = File.expand_path("../templates", __FILE__)
        dest_folder = FileUtils.pwd()
        Dir.mkdir('book')
        Dir.mkdir('cover')
        Dir.mkdir('songs')
        puts '✅ Initialized Folder Structure'

        FileUtils.cp "#{source_folder}/config.yml", "#{dest_folder}/cover/config.yml"
        FileUtils.cp "#{source_folder}/logo.png", "#{dest_folder}/cover/logo.png"
        puts '✅ Copied Default Cover Files'

        FileUtils.cp "#{source_folder}/free_falling.evox", "#{dest_folder}/songs/free_falling.evox"
        FileUtils.cp "#{source_folder}/over_the_rainbow.evox", "#{dest_folder}/songs/over_the_rainbow.evox"
        FileUtils.cp "#{source_folder}/i_dont_love.evox", "#{dest_folder}/songs/i_dont_love.evox"
        puts '✅ Copied Sample Longs'

        puts ''
        puts '🚨 Consider checking this folder in source control 🚨'
      end
    end

    command :generate do |c|
      c.syntax = 'evox generate [options]'
      c.description = 'generates the songbook'
      c.action do |_args, _options|

        Prawn::Document.generate('book/book.pdf', page_size: "A4", margin: [48, 30, 60, 30]) do
          def build_cover
            cover = YAML.load(File.read('cover/config.yml'))
            # Generate Cover Page
            pad_top(cover["header"]["top_padding"]) { text cover["header"]["title"], size: cover["header"]["title_size"], style: :bold, align: :center }
            pad_bottom(cover["header"]["bottom_padding"]) { text cover["header"]["subtitle"], size: cover["header"]["subtitle_size"], style: :bold, align: :center }

            image "cover/#{cover["logo"]["image"]}", width: cover["logo"]["width"], height: cover["logo"]["height"], position: :center

            pad_top(50) { text cover["footer"]["title"], size: cover["footer"]["title_size"], style: :bold, align: :center }
          end

          def scanner(delimiter, song)
            column_start = false
            columns = []
            current_column = []

            File.open( "songs/#{song}").each_with_index do |line, index|
              if line =~ /#{Regexp.quote(delimiter)}/
                # tracking if the state has been changed
                state_changed = false

                # starting to scan a column if the column is not being scanned
                if column_start == false
                  column_start = true
                  state_changed = true

                  current_column << index
                end

                # ending the column scan if the column is already being scanned
                if column_start == true && state_changed == false
                  column_start = false

                  current_column << index
                  columns << current_column
                  current_column = []
                end

              end
            end

            columns
          end

          def build_pages
            songs = Dir.entries('songs').select {|f| !File.directory? f}
            songs = songs.sort_by {|f| f }
            toc = []

            # build songs
            songs.each do |song|
              start_new_page
              song_config = get_song_config(song)

              build_page_header(song_config)
              build_lyrics(song, song_config)

              toc << {name: song_config["name"], page_number: page_number}
            end

            # number the pages
            string = "<page> of <total>"
            options = { :at => [0, 0],
                        :width => bounds.width,
                        :align => :center,
                        :page_filter => Proc.new { |page| page != 1 },
                        :start_count_at => 2,
                        :color => "000000" }
            number_pages string, options

            # build the toc
            build_toc(toc)


          end

          def get_song_config(song_file)
            song = File.read("songs/#{song_file}")
            config = song[/==(.*?)==/m, 1]
            YAML.load(config)
          end

          def build_page_header(song_config)
            stroke_horizontal_rule
            pad_top(10) { text song_config["name"].upcase, size: 18 }
            pad_bottom(5) { text song_config["author"].upcase, size: 12 }
            pad_bottom(25) { stroke_horizontal_rule }
          end

          def build_lyrics(song_file, song_config)
            col_array = scanner '--', song_file
            y_position = cursor

            col_array.each_with_index do |column, column_index|
              gutter = song_config["gutter"]
              column_width = (song_config["column_width"] / (col_array.count)) - gutter

              if column_index == 0
                x_position = 0
              else
                x_position = (column_width + gutter) * column_index
              end

              font_size = song_config["font"]

              bounding_box([x_position, y_position], width: column_width, overflow: :shrink_to_fit) do
                File.open( "songs/#{song_file}").each_with_index do |line, line_index|
                  if line_index >= column[0] && line_index <= column[1]
                    next if line =~ /--/
                    if line[0] == '.'
                      text line.gsub('.','').gsub(' ',' '), size: font_size, color: '008aff'
                    end
                    pad_bottom(5) { text line.strip, size: font_size, color: '000000', font: 'courier' } if line[0] == ' '
                    pad_bottom(15) {} if line[0] =~ /\n/
                  end
                end
              end

            end

            bounding_box [0,10], width: bounds.width do
              stroke_horizontal_rule
            end

          end

          def build_toc(toc)
            start_new_page
            stroke_horizontal_rule
            pad(10) { text "Table of Contents".upcase, size: 20, style: :bold }
            pad_bottom(20) { stroke_horizontal_rule }

            dots = 65
            toc.each do |toc_item|
              spacer = "." * (dots - toc_item[:name].length - toc_item[:page_number].to_s.length)
              pad_bottom(8) { text "#{toc_item[:name]} #{spacer} #{toc_item[:page_number]}" }
            end
          end

          fonts_path = File.expand_path("../fonts", __FILE__)

          font_families.update("RobotoMono" => {
              :normal => "#{fonts_path}/roboto/RobotoMono-Regular.ttf",
              :italic => "#{fonts_path}/roboto/RobotoMono-Italic.ttf",
              :bold => "#{fonts_path}/roboto/RobotoMono-Bold.ttf",
              :bold_italic => "#{fonts_path}/roboto/RobotoMono-BoldItalic.ttf"
          })
          font "RobotoMono"

          build_cover
          build_pages

        end

      end
    end


  end
end
