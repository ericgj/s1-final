
module Data
class Table

  attr_reader :data
  attr_reader :headers
  
  DEFAULT_OPTIONS = {}
  
  def initialize(*args)
    opts = args.last.is_a?(Hash) ? args.pop : DEFAULT_OPTIONS
    rows = args.first.is_a?(Array) ? args : [args]
    # get max column count and assign default headers
    n = rows.max {|r| r.size}.size
    @headers = (0..(n - 1)).to_a
    if opts[:headers]
      opts[:headers].each_with_index {|h, i| @headers[i] = h}
    end
    @row_cache, @col_cache, @cell_cache = {}, {}, {}
    append_rows(rows)
    self
  end
  
  def col_count
    headers.size
  end
  
  def row_count
    (data/colsize).to_i
  end
  
  def row(n)
    @row_cache[n] ||= Data::Row.new(self, n)
  end
  
  def col(n_or_name)
    n = headers.index {|h| h == n_or_name} || n_or_name
    @col_cache[n] ||= Data::Col.new(self, n)
  end
  
  def cell(nrow, ncol_or_name)
    ncol = headers.index {|h| h == ncol_or_name} || ncol_or_name
    @cell_cache[[nrow, ncol]] ||= Data::Cell.new(self, nrow, ncol)
  end
  
  # iterators -- maybe better to extract these into Data::Rows, Data::Cols < Array ?
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
  
 
  # TODO really better to do this in more general insert_rows
  def append_rows(*args)
    rows = args.first.is_a?(Array) ? args : [args]
    rows.each {|r| r = pad_columns!(r, n)}
    @data += rows.flatten
    self
  end
  
  def append_cols(*args)
  end
  
  # signatures:
  #   Array           insert 1+ rows at end
  #   Array, Numeric  insert 1+ rows after n row
  #   Array, Hash     insert 1+ rows :after => n or :before => n
  #
  def insert_rows(*args)
  end
  
  # signatures:
  #   Array           insert 1+ cols at end
  #   Array, Numeric  insert 1+ cols after n row
  #   Array, Hash     insert 1+ cols :after => n or :before => n
  #
  def insert_cols(*args)
  end
  
  def delete_row(n)
  end
  
  def delete_col(n_or_name)
  end
  
  def delete_rows(range, &blk)
  end
  
  def delete_cols(range, &blk)
  end
  

  def update_cell_value(nrow, ncol_or_name, value)
  end
  
  
  private
  
  def pad_columns!(data, n, default = nil)
    #TODO
  end
  
  def pad_rows!(data, n, default = nil)
    #TODO
  end
  
end
end
