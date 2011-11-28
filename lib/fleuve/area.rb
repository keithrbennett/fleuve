module Fleuve

  class Area

    attr_accessor :matrix_data

    def initialize(array2d_or_string)
      case array2d_or_string
        when Array
          @matrix_data = array2d_or_string
        when String
          @matrix_data = parse(array2d_or_string)
      end
    end


    def parse(string)
      row_strings = string.split("\n")
      rows = []
      row_strings.each do |row_string|
        row = row_string.split.map { |int_string| int_string.to_i }
        rows << row
      end
      rows
    end


    def row_count
      matrix_data.size
    end
  end
end
