module RMU
module Data
  class Column
    include Enumerable

    attr_reader :table
    attr_reader :index
    
    def initialize(table, index)
      @table = table; @index = index
    end
    
    def header
      @table.header(@index)
    end
    
    def header=(value)
      @table.update_header(@index, value)
    end
    
    def each
      (0..(@table.row_count - 1)).each do |irow|
        yield(@table.cell(irow, @index))
      end
    end
    alias_method :each_cell, :each
    
    def each_value
      each {|cell| yield(cell.value) }
    end
    
    def values
      map {|cell| yield(cell.value) }
    end
    
  end
    
  Col = Column
end
end