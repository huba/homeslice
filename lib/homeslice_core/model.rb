require 'geometry'

module Homeslice
  class Model
    def initialize()
      @edges = {}
      @free_edges = {} # all the edges that so far only have one facet attached to them
      @faces = Set[]
    end
    
    def add_face(face)
      @faces.add(face)
      
      face.edges.each_value do |edge|
        if @free_edges.member? edge
          neighbor = @free_edges.delete edge
          @edges[edge] = Set[face, neighbor]
        else
          @free_edges[edge] = face
        end
      end
      
      # update stats
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
    end
    
    def length
      @faces.length
    end
  end
  
  def find_neighbours(face)
    if not @faces.member? face
      return nil
    end
    
    neighbours = []
    
    face.edges.each_value do |edge|
      
    end
  end
  
  def has_free_edges
    not @free_edges.empty?
  end
end