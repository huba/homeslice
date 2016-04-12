require 'homeslice_core'

describe Homeslice do
  it "throws a missing extension error" do
    filename = 'spec/test_models/dummy_no_extension'
    expect { Homeslice::Parser.read_file(filename) }.to raise_error("No file extension on #{filename}!")
  end
  
  it "throws a file doesn't exist error" do
    filename = 'spec/test_models/does_not_really_exist.stl'
    expect { Homeslice::Parser.read_file(filename) }.to raise_error("#{filename} does not exist!")
  end
  
  it "throws an unknown extension error" do
    filename = 'spec/test_models/unknown.extension'
    expect { Homeslice::Parser.read_file(filename) }.to raise_error('Unknown file extension .extension!')
  end
  
  it "generates a valid model structure" do
    filename = 'spec/test_models/10mm_test_cube.stl'
    model = Homeslice::Parser.read_file(filename)
    
    expect(model).to be_a(Homeslice::Model)
  end
end