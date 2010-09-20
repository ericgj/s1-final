module RMU
module Data
  class Row
    include Enumerable

    attr_reader :table
    attr_reader :index
    
    def initialize(table, index)
      @table = table; @index = index
    end
    
    def each
      (0..(@table.col_count - 1)).each do |icol|
        yield(@table.cell(@index, icol))
      end
    end
    alias :each_cell, :each
    
    def each_value
      each {|cell| yield(cell.value) }
    end
    
    def values
      map {|cell| yield(cell.value) }
    end
    
  end

end
end