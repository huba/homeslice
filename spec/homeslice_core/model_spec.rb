require 'homeslice_core'
require 'geometry'

describe Homeslice do
  it "should find no neighbours for the given face" do
    test_model = Homeslice::Model.new
    test_face = test_model.create_face [0.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.5, 0.5, 1.0]
    
    expect(test_model.find_neighbours test_face).to be == []
    
    test_model.create_face [2.0, 0.0, 0.0], [2.0, 1.1, 1.0], [2.0, 3.0, 0.0]
    
    expect(test_model.find_neighbours test_face).to be == []
  end
  
  it "should know that the face is not in the model" do
    test_model = Homeslice::Model.new
    test_model.create_face [0.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.5, 0.5, 1.0]
    test_model.create_face [0.0, 0.0, 0.0], [0.5, 0.5, 1.0], [1.0, 0.0, 0.0]
    test_model.create_face [0.0, 1.0, 0.0], [1.0, 1.0, 0.0], [0.5, 0.5, 1.0]
    
    test_face = Homeslice::Face.make_face [2.0, 0.0, 0.0], [2.0, 1.1, 1.0], [2.0, 3.0, 0.0]
    
    expect(test_model.find_neighbours test_face).to be == nil
  end
  
  it "should find both neighbours for the given face" do
    test_model = Homeslice::Model.new
    test_face = test_model.create_face [0.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.5, 0.5, 1.0]
    test_model.create_face [0.0, 0.0, 0.0], [0.5, 0.5, 1.0], [1.0, 0.0, 0.0]
    test_model.create_face [0.0, 1.0, 0.0], [1.0, 1.0, 0.0], [0.5, 0.5, 1.0]
    
    expect(test_model.find_neighbours(test_face).length).to be == 2
  end
  
  it "should make a model with no free edges." do
    test_model = Homeslice::Model.new
    test_model.create_face [0.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.5, 0.5, 1.0]
    test_model.create_face [0.0, 0.0, 0.0], [0.5, 0.5, 1.0], [1.0, 0.0, 0.0]
    test_model.create_face [0.0, 1.0, 0.0], [1.0, 0.0, 0.0], [0.5, 0.5, 1.0]
    test_model.create_face [0.0, 0.0, 0.0], [1.0, 0.0, 0.0], [0.0, 1.0, 0.0]
    
    expect(test_model.has_free_edges).to be false
  end
  
  it "should make a model with free edges." do
    test_model = Homeslice::Model.new
    test_model.create_face [0.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.5, 0.5, 1.0]
    test_model.create_face [0.0, 0.0, 0.0], [0.5, 0.5, 1.0], [1.0, 0.0, 0.0]
    test_model.create_face [0.0, 1.0, 0.0], [1.0, 0.0, 0.0], [0.5, 0.5, 1.0]
    
    expect(test_model.has_free_edges).to be true
  end
end