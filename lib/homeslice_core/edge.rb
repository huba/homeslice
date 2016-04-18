require 'geometry'

module Geometry
  # Hash the edge object based on its first and last points
  class Edge
    def eql?(other)
      self == other
    end
    
    def hash
      return [@first, @last].hash
    end
    
    def min
      @first.min @last
    end
    
    def max
      @first.max @last
    end
  end
end