
module RMU
module Data
class Table

  attr_reader :data
  attr_accessor :headers
  
  DEFAULT_OPTIONS = {}
  
  def initialize(rdata = [], opts = DEFAULT_OPTIONS)
    @data = []
    init_caches
    init_headers(opts[:headers] || [])
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
    init_blank_headers(input.size) if @headers.empty?
    
    # pad or truncate row based on headers
    input = normalized_columns(input)
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
    
    init_caches
    
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
      name = opts[:name]
      after = opts[:after]
      before = opts[:before]
    else
      after = col_count
    end
    #TODO lookup after, before if not Numeric
    input = args.flatten
        
    if @data.empty? && !input.empty?
      @data = input
      name ? init_headers(name) : init_blank_headers(1)
    else
      
      # pad or truncate column based on row count
      input = normalized_rows(input)    
      
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
          insert_header((-1 * after), name)
        else
          init_blank_headers(@headers.size + 1)
        end
        
      end
    
      if before
        before = [before, col_count].min
        i = -1
        @data = \
          @data.inject([]) do |memo, it|
            i += 1
            if (i % col_count) == before
              memo << input.shift
            end
            memo << it
            memo
          end
          
        if name
          insert_header(before, name)
        else
          init_blank_headers(@headers.size + 1)
        end
      end

    end
    
    init_caches
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
  
  
  protected
  
  def init_caches
    @row_cache, @col_cache, @cell_cache = {}, {}, {}
  end
  
  #TODO: these header operations should be moved to a separate class
  
  def init_headers(names = [])
    names = [names] unless names.is_a?(Array)
    @headers = []
    names.each_with_index {|name, i| @headers[i] = name}
  end
  
  def init_blank_headers(n)
    @headers = []
    (0..(n-1)).each {|i| @headers[i] = nil} if n > 0
  end
  
  def insert_header(at, name)
    @headers.insert(at, name)
  end
  
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
  
  def normalized_columns(rdata, default = nil)
    padded_or_truncated_array(rdata, col_count, default)
  end
  
  def normalized_rows(cdata, default = nil)
    padded_or_truncated_array(cdata, row_count, default)
  end
  
  def padded_or_truncated_array(array, n, default = nil)
    if n > array.size
      (array.size..(n-1)).each {|i| array[i] = default}
    elsif n < array.size
      Kernel.warn "Note: data truncated to #{n} from #{array.size}"
      array = array[0,n]
    end
    array
  end
  
end
end
end
