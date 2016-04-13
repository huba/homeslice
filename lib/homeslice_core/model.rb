require 'geometry'

require_relative 'face'

module Homeslice
  class Model
    attr_reader :min_point, :max_point
    
    def initialize()
      @edges = {}
      @free_edges = {} # all the edges that so far only have one facet attached to them
      @faces = Set[]
    end
    
    def create_face(point_p, point_q, point_r)
      new_face = Face.make_face point_p, point_q, point_r
      
      add_face(new_face)
      
      return new_face
    end
    
    def add_face(face)
      @faces.add(face)
      
      face.edges.each_value do |edge|
        # See if the new facet is attached to any of the free edges in the model
        # if so, that edge is no longer free. Check reverse edge too
        if @free_edges.key? edge
          neighbour = @free_edges.delete edge
          @edges[edge] = Set[face, neighbour]
        elsif @free_edges.key? edge.reverse
          neighbour = @free_edges.delete edge.reverse
          @edges[edge.reverse] = Set[face, neighbour]
        else
          @free_edges[edge] = face
        end
      end
      
      # update the bounding box of the model.
      if @min_point
        @min_point = face.min_point.min(@min_point)
      else
        @min_point = face.min_point
      end
      
      if @max_point 
        @max_point = face.max_point.max(@max_point)
      else
        @max_point = face.max_point
      end
      
      # make sure the face knows it belongs to this model now
      face.attach_to_model self
    end
    
    def length
      @faces.length
    end
    
    # Provides us with a constant time lookup of the given facet's neighbours
    def find_neighbours(face)
      if not @faces.member? face
        # There is no point doing anything if the face is not in the model
        return nil
      end
      
      neighbours = []
      face.edges.each_value do |edge|
        if @edges.member? edge
          # this will match a pair of faces one of them will be this face
          matches = @edges[edge]
          matches.each do |matched_face|
            if matched_face != face
              neighbours.push(matched_face)
            end
          end
        end
      end
      
      return neighbours
    end
    
    def has_free_edges?
      # No free edges implies no holes in the model
      not @free_edges.empty?
    end
  end
end