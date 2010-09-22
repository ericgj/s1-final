# Usage:
#
# To run a transformation on the row in the underlying table:
#   row.each {|cell| cell.update {|v| v += 1 } }    #=> row
# Or:
#   row.map {|cell| cell.update {|v| v.reverse} }  #=> new array of cells linked to the table
# Or for simple cases:
#   row.map {|cell| cell.value = cell.value.reverse}
#
# To run a transformation on a *copy* of a row:
#   row.values {|v| v += 1 }   #=> array of copy of cell values
#

# TODO add [] indexable by column or header

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

end
end