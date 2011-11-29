module Fleuve

  class Area

    attr_accessor :matrix_data, :solution_array, :working_array


    # Can be passed either a 2D array or a multiline string of space delimited numbers.
    def initialize(array2d_or_string)
      case array2d_or_string
        when Array
          @matrix_data = array2d_or_string
        when String
          @matrix_data = parse(array2d_or_string)
      end
    end


    # Although the problem description says only "delimited integers",
    # the input examples are all space delimited, so we'll make the
    # assumption for now that these numbers will always be space delimited.
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


    def next_column_rownums(current_rownum)
      [
        current_rownum - 1,  # -1 is ok
        current_rownum,
        (current_rownum == row_count - 1) ? 0 : current_rownum + 1
      ]
    end

    def optimal_path(current_column_number, current_row_number)
      (current_column_number...column_count).each do |column_number|

      end
    end
  end
end
