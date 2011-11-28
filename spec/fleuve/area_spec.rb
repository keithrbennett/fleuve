require File.join(File.dirname(__FILE__), '..', 'spec_helper')

require 'area'

module Fleuve


describe Area do

  it "should instantiate with a two dimensional array" do
    Area.new([[0, 0], [1, 1]]).should be
  end

  it "should return a correct row count" do
    data = [[0, 0], [1, 1]]
    Area.new(data).row_count.should == 2
  end

end

end
