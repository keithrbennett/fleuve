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


    def parse(multiline_rows_string)
      row_strings = multiline_rows_string.split("\n")
      rows_as_arrays = []
      row_strings.each do |row_string|
        row = row_string.split.map { |int_string| int_string.to_i }
        rows_as_arrays << row
      end
      rows_as_arrays
    end


    def row_count
      matrix_data.size
    end


    def column_count
      matrix_data[0].size
    end
  end
end
