require "evox/version"
require 'prawn'
require 'commander/import'
require 'yaml'
require 'fileutils'


module Evox
  class Start
    program :name, 'Evox'
    program :version, '1.0.0'
    program :description, 'Rugged Songbook generator'
    default_command :instructions

    command :instructions do |c|
      c.syntax = 'evox instructions'
      c.description = 'Displays initial instructions for the song book'
      c.action do |_args, _options|
        puts 'generate initial folder structure by running "evox init"'
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

  end
end
