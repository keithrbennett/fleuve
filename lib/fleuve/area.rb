module Fleuve


  # Contains the matrix data and functionality relating to it,
  # except for that which is specific to a path through the
  # matrix; that is encapsulated in the Area::Path class.
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
    # The multiline string should not include any empty lines.
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


    # The maximum resistance allowable in a successful path.
    def max_resistance
      50  # Currently there is no requirement to allow deviating from this value.
    end


    # The rows that may be accessed in the next column, with top and bottom wrap.
    def next_column_rownums(current_rownum)
      [
          (current_rownum == 0 ? row_count - 1 : current_rownum - 1),
          current_rownum,
          (current_rownum == row_count - 1) ? 0 : current_rownum + 1
      ]
    end


    # The optimal path calculation's entry point.
    #
    # To avoid naming conflicts, the term 'optimal' is used for function names,
    # and 'solution' is used for the implementation's variable names.
    def optimal_path
      solution_path = nil
      (0...row_count).each do |rownum|
        working_path = new_path << rownum

        # The sole underscore is used by Erlang and (AFAIK) other languages
        # to indicate an ignored value/variable:
        _, row_solution_path = optimal_path_recursive(working_path)
        solution_path = Path.min_copy(solution_path, row_solution_path)
      end
      solution_path
    end


    def optimal_path_recursive(working_path, solution_path = nil)
      if working_path.reached_last_column?
        solution_path = Path.min_copy(solution_path, working_path)
      else
        row_candidates = next_column_rownums(working_path.last_column_row)
        row_candidates.each do |rownum|
          working_path << rownum
          working_path, solution_path = optimal_path_recursive(working_path, solution_path)
        end
      end

      working_path.pop
      [working_path, solution_path]
    end


    def new_path
      Path.new(self)
    end


    def report_string

      path = optimal_path
      success = path && path.does_not_exceed_max_resistance?
      format_string = "%-17.17s: %s"

      lines = [format(format_string, "Success", (success ? "Yes" : "No" ))]

      if success
        lines << format(format_string, "Total Resistance", path.total_resistance)
        lines << format(format_string, "Row Numbers", path.rownums_one_offset.join(", "))
      end

      lines.join("\n")
    end




    class Path

      # The way we will determine whether or not the maximum has been exceeded
      # is this:  After the path is processed, if its column count is equal to
      # the area's column count, then we know that it has processed all columns,
      # and does not exceed the maximum.  The other case is that processing the
      # next column would result in exceeding the maximum, so that column's row
      # number is not added to the path, and the array is short.

      attr_accessor :area, :rownums

      # Minimum of two paths, where nil is considered greater than any instance.
      # This is for updating the solution (optimal) path variable.
      # A deep copy is returned so that modifying the working copy does not
      # modify the solution copy.
      def self.min_copy(path1, path2)

        min_path = if path1.nil? && path2.nil?
          nil
        elsif path1.nil?
          path2
        elsif path2.nil?
          path1
        else
          path1 < path2 ? path1 : path2
        end

        (min_path && min_path.does_not_exceed_max_resistance?) ? min_path.copy : nil
      end

      def initialize(area, rownums_to_copy = nil)
        @area = area
        @rownums = rownums_to_copy || []
      end

      def copy
        Path.new(area, rownums.dup)
      end

      def current_column
        rownums.size - 1
      end

      def reached_last_column?
        current_column == area.column_count - 1 # || over maximum
      end

      # Yes, it's CPU-wasteful not to cache this value, but it can be optimized later.
      def total_resistance
        (0..current_column).inject(0) do |sum, colnum|
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

      def  <(other); self.<=>(other)  < 0; end
      def ==(other); self.<=>(other) == 0; end
      def  >(other); self.<=>(other)  > 0; end


      # For stepping back a column. Returns the Path instance, not the value popped.
      def pop
        rownums.pop
        self
      end

      # The example text uses offset 1 for the row numbers.  We're storing them
      # internally as 0 offset.  This function, transforms them to 1 offset for display.
      def rownums_one_offset
        rownums.map { |n| n + 1 }
      end

      # Whether or not this Path instance conforms to the max resistance constraint.
      def does_not_exceed_max_resistance?
        total_resistance <= area.max_resistance
      end

      # Show the row array in [1, 3, 5] format.
      def to_s
        rownums.inspect
      end
    end
  end
end
