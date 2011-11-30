require File.join(File.dirname(__FILE__), '..', 'spec_helper')

require 'area'

module Fleuve


describe Area do

  def array_data;      [[0, 2, 12], [-1, 4, 18]];          end
  def string_data;     "0 2 12\n -1 4 18";                 end
  def big_array_data;  [(0..6).to_a, (20..26).to_a];       end
  def array_3_x_3;     [[1, 2, 3], [2, 3, 1], [3, 1, 2]];  end

  it "should instantiate with a two dimensional array" do
    Area.new(array_data).should be
  end

  it "should hold the same data whether initialized by data or string" do
    Area.new(array_data).matrix_data.should == Area.new(string_data).matrix_data
  end

  it "should return a correct row count when initialized with an array" do
    Area.new(array_data).row_count.should == 2
  end

  it "should return a correct row count when initialized with a string" do
    Area.new(string_data).row_count.should == 2
  end


  it "should return a correct column count when initialized with an array" do
    Area.new(array_data).column_count.should == 3
  end

  it "should return a correct row count when initialized with a string" do
    Area.new(string_data).column_count.should == 3
  end

  it "should calculate the 3 possible row numbers correctly for non-edge rows" do
    Area.new(big_array_data).next_column_rownums(3).should == [2, 3, 4]
  end

  it "should calculate the 3 possible row numbers correctly for bottom row" do
    area = Area.new(big_array_data)
    row_count = area.row_count
    area.next_column_rownums(row_count - 1).should == [row_count - 2, row_count - 1, 0]
  end

  it "should calculate the 3 possible row numbers correctly for the top row" do
    Area.new(big_array_data).next_column_rownums(0).should == [1, 0, 1]
  end

  it "should not permit initializing with invalid data" do
    pending "Need to add validation of matrix data input."
  end

  it "should create a new Path whose rownum array is empty and total resistance is 0" do
    path = Area.new(string_data).new_path
    path.total_resistance.should be_zero
    path.rownums.should be_empty
  end

  it "should update rownum array and total resistance correctly when items are added" do
    area = Area.new(string_data)
    path = area.new_path
    path << 1 << 1 << 0
    path.total_resistance.should == 15
    path.rownums.should == [1, 1, 0]
  end

  it "calculates an optimal path" do
    area = Area.new(array_3_x_3)
    expected_path = area.new_path << 0 << 2 << 1
    area.optimal_path.should == expected_path
  end
end

end
