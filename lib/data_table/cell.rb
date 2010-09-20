module Data
  class Cell

    def initialize(table, row_index, col_index)
      @table, @rindex, @cindex = table, row_index, col_index
    end
    
    def row_index; @rindex; end
    def col_index; @cindex; end
    def col_header; @table.header(@cindex); end
    def row; @table.row(@rindex); end
    def col; @table.col(@cindex); end
    
    def value
      @table.cell_value(@rindex, @cindex)
    end
    
    def value=(it)
      @table.update_cell_value(@rindex, @cindex, it)
    end
    
    
  end
end
