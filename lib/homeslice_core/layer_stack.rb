require 'geometry'

require_relative 'layer'

module Homeslice
  # Not a stack as the LIFO data type, it's literally a stack of pancakes, mmmmm.
  class ModelLayerStack
    attr_reader :layer_count, :layer_height
    
    def initialize(model, layer_height)
      @model = model
      @min_z = @model.min_point.z
      @max_z = @model.max_point.z
      @layer_height = layer_height
      
      # the bottom layer is min_z + layer_height
      # otherwise model would become one layer taller than it really needs to be
      @layer_count = ((@max_z - @min_z) / @layer_height).round
      
      @layers = []
      (1..@layer_count).each do |n|
        # again, bottom layer must be min_z + layer height, that's why this goes from 1 not 0
        # note that the bottom layer will still have index zero in the array
        new_layer = Layer.new n * @layer_height + @min_z, @layer_height
        @layers.push new_layer
      end
    end
    
    def [](number)
      @layers[number]
    end
    
    def index_of(z_offset)
      if (@min_z..@max_z).cover? z_offset
        index = ((z_offset - @min_z) / @layer_height).ceil - 1
        if index == @layer_count
          # the model is taller than the top layer, but it was rounded down
          index -= 1
        end
        
        return index
      else
        return nil
      end
    end
  end
end