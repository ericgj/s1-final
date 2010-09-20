
module RMU
module Data
class Table

  attr_reader :data
  attr_accessor :headers
  
  DEFAULT_OPTIONS = {}
  
  def initialize(rdata = [], opts = DEFAULT_OPTIONS)
    @data = []
    @headers = []
    @row_cache, @col_cache, @cell_cache = {}, {}, {}
    @headers = opts[:headers] if opts[:headers]
    rdata = [rdata] unless rdata.first.is_a?(Array)
    unless rdata.empty? 
      rdata.each {|r| append_row(r)}
    end
  end
   
  def col_count
    headers.size
  end
  
  def row_count
    col_count == 0 ? 0 : (data.size/col_count).to_i
  end
  
  def row(n)
    return nil unless n <= row_count
    @row_cache[n] ||= Row.new(self, n)
  end
  
  def col(n_or_name)
    n = headers.index {|h| h == n_or_name} || n_or_name
    return nil unless n && n <= col_count
    @col_cache[n] ||= Col.new(self, n)
  end
  
  def cell(nrow, ncol_or_name)
    ncol = headers.index {|h| h == ncol_or_name} || ncol_or_name
    return nil unless nrow <= row_count
    return nil unless ncol && n <= col_count
    @cell_cache[[nrow, ncol]] ||= Data::Cell.new(self, nrow, ncol)
  end
  
  # iterators -- maybe better to extract these into Rows, Cols < Array ?
  #
  def rows(range = nil)
    range ||= (0..row_count)
    range.map {|i| row(i)}
  end
  
  def cols(range = nil)
    range ||= (0..col_count)
    range.map {|i| col(i)}
  end
  
  def each_row
    (0..row_count).each {|i| yield(row(i))}
  end
  
  def each_col
    (0..col_count).each {|i| yield(col(i))}
  end
  
  def select_rows(range = nil)
    range ||= (0..row_count)
    idxs = range.select {|i| yield(row(i)) }
    idxs.map {|i| row(i)}
  end
  
  def select_cols(range = nil)
    range ||= (0..col_count)
    idxs = range.select {|i| yield(col(i)) }
    idxs.map {|i| col(i)}
  end
  
  def find_row(range = nil)
    range ||= (0..row_count)
    idxs = range.find {|i| yield(row(i)) }
    idxs.map {|i| row(i)}
  end
  
  def find_col(range = nil)
    range ||= (0..col_count)
    idxs = range.find {|i| yield(col(i)) }
    idxs.map {|i| col(i)}
  end
  
  def map_row(range = nil)
    rows(range).map {|i| yield(row(i))}
  end
  
  def map_col(range = nil)
    cols(range).map {|i| yield(col(i))}
  end
  
 
  def append_row(*args)
    insert_row(*args)
  end
  
  def append_col(*args)
    insert_col(*args)
  end
  
  # signatures:
  #   Array           insert 1 row at end
  #   Array, Numeric  insert 1 row before n row
  #   Array, Hash     insert 1 row :after => n or :before => n
  #
  def insert_row(*args)
    after, before = nil, nil
    opts = (Hash === args.last || Numeric === args.last) ? args.pop : {}
    case opts
    when Numeric
      before = opts
    when Hash
      after = opts[:after]
      before = opts[:before]
    end
    input = args.flatten
    # get input column count and assign default headers
    if @headers.empty?
      n = input.size
      @headers = (0..(n - 1)).to_a if n > 0
    end
    # pad or truncate row based on headers
    input = normalized_columns(input, @headers.size)
    unless after or before
      @data += input
    else
      if after
        after = [after, row_count].min
        @data.insert( [index_of_next_row_start(after), @data.size].min, *input)
      end
      if before
        before = [before, row_count].min
        @data.insert(index_of_row_start(before), *input)
      end
    end
    self
  end
  
  # signatures:
  #   Array           insert 1 cols at end
  #   Array, Numeric  insert 1 cols before n row
  #   Array, Hash     insert 1 cols :after => n or :before => n
  #
  def insert_col(*args)
    after, before = nil, nil
    opts = (Hash === args.last || Numeric === args.last) ? args.pop : {}
    case opts
    when Numeric
      before = opts
    when Hash
      name = opts[:name]    # TODO deal with case if name not passed
      after = opts[:after]
      before = opts[:before]
    else
      after = col_count
    end
    #TODO lookup after, before if not Numeric
    input = args.flatten
    # pad or truncate column based on row count
    input = normalized_rows(input, row_count)    
    if after
      after = [after, col_count].min
      i = -1
      @data = \
        @data.inject([]) do |memo, it|
          i += 1
          memo << it
          if (i % col_count) == after
            memo << input.shift
          end
          memo
        end
      if name
        @headers.insert((-1 * after), name)
      else
        @headers = (0..@headers.size).to_a
      end
    if before
    
    end
    self
  end
  
  def delete_row(n)
  end
  
  def delete_col(n_or_name)
  end
  
  def delete_rows(range, &blk)
  end
  
  def delete_cols(range, &blk)
  end
  

  def header(n)
  end
  
  # Call from Col#header=
  def update_header(ncol_or_name, name)
  end
  
  
  def cell_value(nrow, ncol_or_name)
  end
  
  # Call from Data::Cell#value=
  def update_cell_value(nrow, ncol_or_name, value)
  end
  
  
  private
  
  def index_of_row_start(n)
    n * col_count
  end
  
  def index_of_next_row_start(n)
    (n+1) * col_count
  end
  
  def index_of_col_start(n)
    n * row_count
  end
  
  def index_of_next_col_start(n)
    (n+1) * row_count
  end
  
  def normalized_columns(rdata, n, default = nil)
    if n > rdata.size
      (rdata.size..(n-1)).each {|i| rdata[i] = default}
    elsif n < rdata.size
      Kernel.warn "Note: row truncated from #{rdata.size} to #{n} columns"
      rdata = rdata[0,n]
    end
    rdata
  end
  
  def normalized_rows(cdata, n, default = nil)
    #TODO
  end
  
end
end
end
