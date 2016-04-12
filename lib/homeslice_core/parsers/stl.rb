require 'geometry'

require_relative '../face'
require_relative '../model'

module Homeslice
  module Parsers
    module STLAsciiParser
      def identify(extension)
        (extension == 'stl') and @stream.gets(80).include?('solid')
      end
      
      def parse()
        model = Model.new
        face_points = []
        face_normal = None
        
        @stream.each do |line|
          case line
          when /solid (.*)/
            
          when /facet normal\s+(\S+)\s+(\S+)\s+(\S+)/
            normal = Vector[$1.to_f, $2.to_f, $3.to_f]
          
          when /vertex\s+(\S+)\s+(\S+)\s+(\S+)/
            face_points.push(Geometry::Point[$1.to_f, $2.to_f, $3.to_f])
          when /endloop/
            unless face_points.length == 3
              raise 'Face not a triangle!'
            end
            
            model.add_face Face.new face_normal, *face_points
            
            face_points = []
            face_normal = None
          end
        end
        
        return model
      end
    end
    
    module STLBinParser
      def identify(extension)
        extension == 'stl' and not @stream.gets(80).include?('solid')
      end
      
      def parse()
        @stream.seek(80, IO::SEEK_SET)	# Skip the header bytes
        count = @stream.read(4).unpack('V').first
        # puts "expecting #{count} faces."
        
        model = Model.new
        
        while not @stream.eof?
          normal, *vertices = @stream.read(50).unpack('F3F3F3F3x2').each_slice(3).to_a
          vertices.map! {|vertex| Geometry::Point[vertex]}
          model.add_face Face.new(Vector[*normal], *vertices)
        end
        
        raise "Unexpected end of file after #{faces.length} triangles" if model.length != count
        
        return model
      end
    end
  end
end