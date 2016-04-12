require 'geometry'

module Geometry
  # Hash the edge object based on its first and last points
  class Edge
    def eql?(other)
      self.hash == other.hash
    end
    
    def hash
      return [@first, @last].hash
    end
  end
end