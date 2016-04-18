require 'geometry'

module Homeslice
  class Layer
    def initialize(z_offset, height)
      @z_offset = z_offset
      @height = height
      
      # calculate the treshold within which objects must be caught
      @z_max = @z_offset + @height / 2 # inclusive
      @z_min = @z_offset - @height / 2 #exclusive
      
      @origin = Geometry::Point[0, 0, @z_offset]
      @plane_1 = Vector[1, 0, 0]
      @plane_2 = Vector[0, 1, 0]
    end
    
    # classifies face whether it has no intersection with the layer, has
    # two edge intersections, one point on the layer, an edge on the layer
    # or the face lies on the layer
    # this feels a little clumsy, might come back to it later
    def intersect_face(face)
      # do the most trivial one first
      if face.min_point.z > @z_max || face.max_point.z <= @z_min
        return {:face_type => :no_intersection, :data => nil}
      end
      
      # looks for points on the plane
      points_on_plane = []
      face.each_point do |key, point|
        if point.z > @z_min and point.z <= @z_max
          points_on_plane.push key
        end
      end
      
      face_type = :unknown
      data = nil
      
      case points_on_plane.length
      when 0 # There are exactly two edges to intersect with
        face_type = :proper_intersection
        data = {} # proper intersection will need more computation
        face.each_edge do |key, edge|
          if edge.min.z <= @z_min and edge.max.z > @z_max
            edge_vec = edge.last - edge.first
            origin_vec = edge.first - @origin
            matrix = Matrix.columns([edge_vec, @plane_1, @plane_2]).inverse
            
            intersection = matrix * origin_vec
            
            data[key] = Geometry::Point[intersection[1], intersection[2], @z_offset]
          end
        end
      when 1 # Creates one point on the layer
        face_type = :one_point
        data = points_on_plane
      when 2 # Creates one edge on the layer
        face_type = :one_edge
        data = points_on_plane
      when 3 # creates a triangle (that may be an ear of a polygon) on the layer
        face_type = :triangle
        data = points_on_plane
      end
      
      return {:face_type => face_type, :data => data}
    end
  end
end