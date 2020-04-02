require "evox/version"
require 'prawn'
require 'commander/import'
require 'yaml'


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
      c.description = 'initializes the folder structure'
      c.action do |_args, _options|
        puts 'initializing the folder structure'
      end
    end

  end
end
