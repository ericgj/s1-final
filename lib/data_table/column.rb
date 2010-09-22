# Usage:
#
# To run a transformation on the col in the underlying table:
#   col.each {|cell| cell.update {|v| v += 1 }}    #=> col
# Or:
#   col.map {|cell| cell.update {|v| v.reverse }}  #=> new array of cells linked to table
# Or for simple cases:
#   col.map {|cell| cell.value = cell.value.reverse}
#
# To run a transformation on a *copy* of a col:
#   col.values {|v| v += 1 }   #=> array of copy of cell values
#

# TODO add [] indexable by row

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
    self
  end
  alias_method :each_cell, :each
  
  def each_value
    each {|cell| yield(cell.value) }
  end
  
  # Note: returns copy
  def values
    if block_given?
      map {|cell| yield(cell.value) }
    else
      map {|cell| cell.value}
    end
  end
  
end
  
  Col = Column    # shortcut
  
end
end