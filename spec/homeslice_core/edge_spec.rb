require 'homeslice_core'
require 'geometry'

describe Homeslice do
  it "should generate identical hashes" do
    edge_a = Geometry::Edge.new(Geometry::Point[0, 0, 0], Geometry::Point[1, 1, 1])
    edge_b = Geometry::Edge.new(Geometry::Point[0, 0, 0], Geometry::Point[1, 1, 1])
    
    expect(edge_a.hash == edge_b.hash).to be true
  end

  it "should generate different hashes" do
    edge_a = Geometry::Edge.new(Geometry::Point[0, 0, 0], Geometry::Point[1, 1, 1])
    edge_b = Geometry::Edge.new(Geometry::Point[0, 0, 2], Geometry::Point[1, 1, 1])
    
    expect(edge_a.hash == edge_b.hash).to be false
  end
end