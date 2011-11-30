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
          (current_rownum == 0 ? row_count - 1 : current_rownum - 1),
          current_rownum,
          (current_rownum == row_count - 1) ? 0 : current_rownum + 1
      ]
    end


    # The calculation's entry point..  This function is called recursively,
    # once per column.
    #
    # To avoid naming conflicts, the term 'optimal' is used for function names,
    # and 'solution' is used for the implementation's variable names.
    def optimal_path
      solution_path = nil
      (0...row_count).each do |rownum|
        working_path = new_path << rownum

        # The sole underscore is used by Erlang and (AFAIK) other languages
        # to indicate an unused value/variable:
        _, row_solution_path = optimal_path_recursive(working_path)
        solution_path = Path.min_copy(solution_path, row_solution_path)
      end
      solution_path
    end


    def optimal_path_recursive(working_path, solution_path = nil)
      if working_path.reached_last_column?
        solution_path = Path.min_copy(solution_path, working_path)
        puts "\n\nUpdated solution path is #{solution_path}\n\n"
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


    class Path

      attr_accessor :area, :rownums

      # Minimum of two paths, where nil is considered greater than any instance.
      # This is for updating the solution (optimal) path variable.
      # A deep copy is returned so that modifying the working copy does not
      # modify the solution copy.
      def self.min_copy(path1, path2)
        if path1.nil? && path2.nil?
          raise "Invalid input: both paths are nil."
        elsif path1.nil?
          path2.copy
        elsif path2.nil?
          path1.copy
        else
          path1 < path2 ? path1.copy : path2.copy
        end
      end

      def initialize(area, rownums_to_copy = nil)
        @area = area
        @rownums = rownums_to_copy ? rownums_to_copy : []
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

      def  <(other); self.<=>(other)  < 0; end
      def ==(other); self.<=>(other) == 0; end
      def  >(other); self.<=>(other)  > 0; end


      # For stepping back a column.
      def pop
        rownums.pop
        self
      end

      def to_s
        rownums.inspect
      end
    end
  end
end

