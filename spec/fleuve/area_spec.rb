require File.join(File.dirname(__FILE__), '..', 'spec_helper')

require 'area'

module Fleuve


describe Area do

  def array_data;      [[0, -1], [2, 4], [12, 18]];      end
  def string_data;     "0 -1 \n 2 4\n  12  18 ";         end
  def big_array_data;  ([string_data] * 3).join("\n");   end
  def big_array_size;  9;                                end

  it "should instantiate with a two dimensional array" do
    Area.new(array_data).should be
  end

  it "should hold the same data whether initialized by data or string" do
    Area.new(array_data).matrix_data.should == Area.new(string_data).matrix_data
  end

  it "should return a correct row count when initialized with an array" do
    Area.new(array_data).row_count.should == 3
  end

  it "should return a correct row count when initialized with a string" do
    Area.new(string_data).row_count.should == 3
  end


  it "should return a correct column count when initialized with an array" do
    Area.new(array_data).column_count.should == 2
  end

  it "should return a correct row count when initialized with a string" do
    Area.new(string_data).column_count.should == 2
  end

  it "should calculate the 3 possible row numbers correctly for non-edge rows" do
    Area.new(big_array_data).next_column_rownums(3).should == [2, 3, 4]
  end

  it "should calculate the 3 possible row numbers correctly for bottom row" do
    Area.new(big_array_data).next_column_rownums(big_array_size - 1).should == [big_array_size - 2, big_array_size - 1, 0]
  end

  it "should calculate the 3 possible row numbers correctly for the top row" do
    Area.new(big_array_data).next_column_rownums(0).should == [-1, 0, 1]
  end

  it "should not permit initializing with invalid data" do
    pending "Need to add validation of matrix data input."
  end
end

end
