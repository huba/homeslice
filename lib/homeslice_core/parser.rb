require_relative 'parsers/stl.rb'

module Homeslice
  class Parser
    def self.read_file(filepath)
      unless File.exists? filepath
        raise "#{filepath} does not exist!"
      end
      
      File.open(filepath, 'r') do |stream|
        parser = self.new stream
        parser.determine_filetype(filepath, stream)
        parser.parse()
      end
    end
    
    def self.parse_stream(stream, stream_format)
      parser = self.new stream
    end
    
    def initialize(stream)
      @stream = stream
    end
    
    def determine_filetype(filepath, stream)
      unless filepath.split('.').length > 1
        raise Exception.new "No file extension on #{filepath}!"
      end
      
      extension = filepath.split('.')[-1]
      
      Parsers.constants.each do |parser_module_name|
        @stream.rewind
        parser_module = Parsers.const_get parser_module_name
        
        if parser_module.instance_method(:identify).bind(self).call(extension)
          extend parser_module
          return
        end
      end
      
      raise Exception.new "Unknown file extension .#{extension}!"
    end
  end
end