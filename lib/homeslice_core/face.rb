require 'geometry'
require 'set'

require_relative 'model'

module Homeslice
  class Face
    # calculates the normal to the face from 3 points that define a plane
    # uses the 3 points to create the triangle of the face.
    # P, Q, R will be anti-clockwise on the plane
    def self.make_face(point_p, point_q, point_r)
      vec_pq = Vector[*(point_q - point_p)]
      vec_pr = Vector[*(point_r - point_q)]
      
      vec_n = vec_pq.cross(vec_pr).normalize
      
      return self.new vec_n, point_p, point_q, point_r
    end
    
    attr_reader :normal, :points, :edges, :min_point, :max_point
    
    # Only allow triangles
    def initialize(normal, point_p, point_q, point_r)
      @points = {:p => point_p, :q => point_q, :r => point_r}
      @edges = {
        :pq => Geometry::Edge.new(point_p, point_q),
        :qr => Geometry::Edge.new(point_q, point_r),
        :rp => Geometry::Edge.new(point_r, point_p)
      }
      
      @normal = normal
      
      @min_point = point_p.min(point_q).min(point_r)
      @max_point = point_p.max(point_q).max(point_r)
    end
    
    def attach_to_model model
      @model = model
    end
    
    def has_edge(edge)
      @edges.value? edge
    end
    
    def ==(other)
      self.points == other.points
    end
    
    def eql?(other)
      self == other
    end
    
    def hash
      @points.values.hash
    end
  end
end