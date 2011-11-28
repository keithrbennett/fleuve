require File.join(File.dirname(__FILE__), '..', 'spec_helper')

require 'area'

module Fleuve


describe Area do

  def array_data;  [[0, -1], [2, 4]]; end
  def string_data; "0 -1 \n 2 4";     end

  it "should instantiate with a two dimensional array" do
    Area.new(array_data).should be
  end

  it "should return a correct row count when initialized with an array" do
    Area.new(array_data).row_count.should == 2
  end

  it "should return a correct row count when initialized with a string" do
    Area.new(string_data).row_count.should == 2
  end


  it "should hold the same data whether initialized by data or string" do
    Area.new(array_data).matrix_data.should == Area.new(string_data).matrix_data
  end

end

end
