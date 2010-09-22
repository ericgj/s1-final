module RMU
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
         
    def row?(n); n == row_index; end
    
    def col?(n_or_name)
      n_or_name == col_index || \
        n_or_name == col_header
    end
    
    def value
      @table.cell_value(@rindex, @cindex)
    end
    
    def value=(it)
      @table.update_cell_value(@rindex, @cindex, it)
    end
    
    def fill(&blk)
      return unless block_given?
      @table.update_cell_value(@rindex, @cindex, yield(value))
    end
    alias_method :update, :fill
    
  end
end
end