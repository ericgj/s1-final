require 'set'

module Data
class Table

  attr_reader :data
  attr_accessor :headers
  
  DEFAULT_OPTIONS = {}
  
  def initialize(*args)
    @data = []
    #TODO: not sure SortedSet is what we want since it swallows duplicates
    # instead of raising error
    @headers = SortedSet.new
    @row_cache, @col_cache, @cell_cache = {}, {}, {}
    opts = args.last.is_a?(Hash) ? args.pop : DEFAULT_OPTIONS
    @headers = opts[:headers] if opts[:headers]
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
  
 
  def append_rows(*args)
    insert_rows(*args)
  end
  
  def append_cols(*args)
    insert_cols(*args)
  end
  
  # signatures:
  #   Array           insert 1+ rows at end
  #   Array, Numeric  insert 1+ rows after n row
  #   Array, Hash     insert 1+ rows :after => n or :before => n
  #
  def insert_rows(*args)
    after, before = nil, nil
    opts, rows = args.pop, args
    case opts
    when Numeric
      after = opts
    when Hash
      after = opts[:after]
      before = opts[:before]
    when NilClass
      rows = opts
    end
    rows = [rows] unless rows.first.is_a?(Array)
    # get max column count and assign default headers
    if @headers.empty?
      n = rows.max {|r| r.size}.size
      @headers = (0..(n - 1)).to_a
    end
    # pad rows based on headers (or raise error if size of row > size of headers)
    rows.each {|r| r = pad_columns!(r, @headers.size)}
    unless after or before
      @data += rows.flatten
    else
      if after
        after = [after, row_count].max
        @data.insert(index_of_next_row_start(after), rows.flatten)
      end
      if before
        before = [before, row_count].max
        @data.insert(index_of_row_start(before), rows.flatten)
      end
    end
    self
  end
  
  # signatures:
  #   Array           insert 1+ cols at end
  #   Array, Numeric  insert 1+ cols after n row
  #   Array, Hash     insert 1+ cols :after => n or :before => n
  #
  def insert_cols(*args)
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
  
  # Call from Data::Col#header=
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
  
  def pad_columns!(data, n, default = nil)
    #TODO
  end
  
  def pad_rows!(data, n, default = nil)
    #TODO
  end
  
end
end
