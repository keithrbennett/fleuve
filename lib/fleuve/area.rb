module Fleuve

  class Area

    attr_accessor :matrix_data


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

    def resistance(row, col)
      matrix_data[row][col]
    end


    def next_column_rownums(current_rownum)
      [
        current_rownum - 1,  # -1 is ok
        current_rownum,
        (current_rownum == row_count - 1) ? 0 : current_rownum + 1
      ]
    end


    def optimal_path
      solution_path = nil
      (0...row_count).each do |rownum|
        working_path = new_path << rownum
        row_optimal_path = calc_optimal_path(working_path)
        if solution_path.nil? || (row_optimal_path < solution_path)
          solution_path = row_optimal_path
        end
      end
      solution_path
    end

    # Here's the heart of the calculation.  This function is called recursively,
    # once per column.
    def calc_optimal_path(working_path, solution_path = nil)
      if working_path.reached_last_column?
        if working_path < solution_path
          solution_path = working_path
        end
        next_column_rownums(working_path.last_column_row).each do |rownum|
          working_path.eat_next_column(rownum)
          calc_optimal_path(working_path, solution_path)
        end
        working_path.pop
      end
      solution_path
    end

    
    def new_path
      Path.new(self)
    end


    class Path

      attr_accessor :area, :rownums

      def initialize(area)
        @area = area
        @rownums = []
      end

      def current_column
        rownums.size - 1
      end

      def eat_next_column(rownum)
        self << area.resistance(rownum, current_column + 1)
      end

      def reached_last_column?
        current_column == area.column_count - 1 # || over maximum
      end

      # Yes, it's CPU-wasteful not to cache this value, but it can be optimized later.
      def total_resistance
        (0..current_column).to_a.inject(0) do |sum, colnum|
          sum += area.resistance(rownums[colnum], colnum)
        end
      end

      def last_column_row
        rownums[-1]
      end

      def <<(rownum)
        @rownums << rownum
        self
      end

      def <=>(other)
        total_resistance - other.total_resistance
      end

      # For stepping back a column.
      def pop
        rownums.pop
        self
      end
    end
  end
end
