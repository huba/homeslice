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
    expect(intersection_result[:data]).to be == {:pq => Geometry::Point[0, 0.5, 1], :qr => Geometry::Point[0, 1.5, 1]}
  end
end