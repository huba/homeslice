require 'homeslice_core'
require 'geometry'

describe Homeslice do
  it "should find this face doesn't intersect" do
    layer = Homeslice::Layer.new 1.0, 0.25
    face = Homeslice::Face.make_face [0, 0, 0], [0, 1, 0.5], [0, 2, 0]
    
    intersection_result = layer.intersect_face face
    
    expect(intersection_result[:face_type]).to be == :no_intersection
  end
  
  it "should find that the face has a point on the layer" do
    layer = Homeslice::Layer.new 1.0, 0.25
    face = Homeslice::Face.make_face [0, 0, 0], [0, 1, 1], [0, 2, 0]
    
    intersection_result = layer.intersect_face face
    
    expect(intersection_result[:face_type]).to be == :one_point
    expect(intersection_result[:data]).to be == [:q]
  end
  
  it "should find that the face has an edge on the layer" do
    layer = Homeslice::Layer.new 1.0, 0.25
    face = Homeslice::Face.make_face [0, 0, 1], [0, 1, 0], [0, 2, 1]
    
    intersection_result = layer.intersect_face face
    
    expect(intersection_result[:face_type]).to be == :one_edge
    expect(intersection_result[:data]).to be == [:p, :r]
  end
  
  it "should find that the face lies completely on the layer" do
    layer = Homeslice::Layer.new 1.0, 0.25
    face = Homeslice::Face.make_face [0, 0, 1], [1, 1, 1], [0, 2, 1]
    
    intersection_result = layer.intersect_face face
    
    expect(intersection_result[:face_type]).to be == :triangle
    expect(intersection_result[:data]).to be == [:p, :q, :r]
  end
  
  it "should calculate the two intersection points from the face" do
    layer = Homeslice::Layer.new 1.0, 0.25
    face = Homeslice::Face.make_face [0, 0, 0], [0, 1, 2], [0, 2, 0]
    
    intersection_result = layer.intersect_face face
    
    expect(intersection_result[:face_type]).to be == :proper_intersection
    # The points are now 2D
    expect(intersection_result[:data]).to be == {:pq => Geometry::Point[0, 0.5], :qr => Geometry::Point[0, 1.5]}
  end
  
  it "should generate an approrpriate height layer stack" do
    model = Homeslice::Parser.read_file 'spec/test_models/10mm_test_cube.stl'
    layer_stack = Homeslice::ModelLayerStack.new model, 0.25
    
    expect(layer_stack.layer_count).to be == 40
    expect(layer_stack[0].z_offset).to be == 0.25
    expect(layer_stack[-1].z_offset).to be == 10
  end
  
  it "should calculate the correct layer indexes based on the given z_offset" do
    model = Homeslice::Parser.read_file 'spec/test_models/10mm_test_cube.stl'
    layer_stack = Homeslice::ModelLayerStack.new model, 0.25
    
    expect(layer_stack.index_of 0.1).to be == 0
    expect(layer_stack.index_of 0.25).to be == 0
    expect(layer_stack.index_of 0.26).to be == 1
    expect(layer_stack.index_of 10.00100040435791).to be == 39
    expect(layer_stack.index_of -3.0).to be nil
  end
end