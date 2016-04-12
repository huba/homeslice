require 'homeslice_core'
require 'geometry'

describe Homeslice do
  it "will complain about degenerate triangle" do
    expect {
      Homeslice::Face.make_face(
        Geometry::Point[0, 0, 0],
        Geometry::Point[0, 1, 1],
        Geometry::Point[0, 1, 1]
      )
    }.to raise_error(Vector::ZeroVectorError)
  end
  
  it "will generate triangle with a normal in the positive z direcion" do
    triangle = Homeslice::Face.make_face(
      Geometry::Point[3, 1, 2],
      Geometry::Point[4, 1, 2],
      Geometry::Point[3, 2, 2]
    )
    
    # in the z direction
    expect(triangle.normal).to be == Vector[0, 0, 1]
  end
  
  it "will generate triangle with a normal in the negative z direcion" do
    triangle = Homeslice::Face.make_face(
      Geometry::Point[3, 2, 2],
      Geometry::Point[4, 1, 2],
      Geometry::Point[3, 1, 2]
    )
    
    # in the z direction
    expect(triangle.normal).to be == Vector[0, 0, -1]
  end
  
  it "will identify the minimum point and the maximum point of the triangle's bounding box" do
    triangle = Homeslice::Face.make_face(
      Geometry::Point[0, -1, 2],
      Geometry::Point[4, 1, 4],
      Geometry::Point[3, 2, 5]
    )
    
    expect(triangle.min_point).to be == Geometry::Point[0, -1, 2]
    expect(triangle.max_point).to be == Geometry::Point[4, 2, 5]
  end
  
  it "will make a face that is attached to an given edge" do
    point_a = Geometry::Point[0, 0, 0]
    point_b = Geometry::Point[1, 0, 0]
    point_c = Geometry::Point[0, 1, 0]
    
    edge = Geometry::Edge.new point_a, point_b
    face = Homeslice::Face.make_face point_a, point_b, point_c
    
    expect(face.has_edge edge).to be true
  end
  
  it "will make a face that is not attached to a given edge" do
    point_a = Geometry::Point[0, 0, 0]
    point_b = Geometry::Point[1, 0, 0]
    point_c = Geometry::Point[0, 1, 0]
    
    edge = Geometry::Edge.new point_a, Geometry::Point[0, 0, 1]
    face = Homeslice::Face.make_face point_a, point_b, point_c
    
    expect(face.has_edge edge).to be false
  end
end