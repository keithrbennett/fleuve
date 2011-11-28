module Fleuve

  class Area

    attr_accessor :matrix_data

    def initialize(array2d_or_string)
      case array2d_or_string
        when Array
          @matrix_data = array2d_or_string
      end
    end


    def row_count
      matrix_data.size
    end
  end
end
