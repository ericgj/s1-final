
module RMU
module Data
  class IllegalFormatError < StandardError; end
  
class Table
  extend ::Loadable
  include ::Dumpable
  
  attr_reader :data
  attr_reader :headers
  
  DEFAULT_OPTIONS = {:cache => true}
   
  load_files_of_format(:yaml) do |input, opts|
    require 'yaml'
    yaml = YAML.load(input)
    raise RMU::Data::IllegalFormatError unless yaml.is_a?(Array)
    new(yaml, DEFAULT_OPTIONS.merge(opts))
  end
  
  dump_to_files_of_format(:yaml) do |table, output, opts|
    require 'yaml'
    output.print(
      if opts[:headers]
        YAML.dump([table.headers] + table.rows.map(&:values))
      else
        YAML.dump(table.rows.map(&:values))
      end
    )
    output.flush
  end
  
  def initialize(rdata = [], opts = DEFAULT_OPTIONS)
    @data = []
    @cache = (opts[:cache] == true)
    
    init_caches!

    unless rdata.empty? 
      rdata = [rdata] unless rdata.first.is_a?(Array)
    end
    
    i = 0
    init_headers!([])
    case hdrs = opts[:headers]
    when Array
      init_headers!(hdrs)
    when TrueClass
      init_headers!(rdata.first) unless rdata.empty?
      i = 1
    end
    rdata[i..(rdata.size-1)].each {|r| append_row!(r)} \
      unless rdata.empty? 
      
  end
   
   
  def col_count
    headers.size
  end
  
  def row_count
    col_count == 0 ? 0 : (data.size/col_count).to_i
  end
  
  def header(n_or_name)
    headers[header_index(n_or_name)]
  end
  
  def header_index(n_or_name)
    idx = \
      if Numeric === n_or_name && n_or_name < col_count
        n_or_name >= 0 ? n_or_name : col_count + n_or_name
      else
        headers.index(n_or_name)
      end
    raise ArgumentError, "Unknown header or column index '#{n_or_name}'" if idx == nil
    idx
  end
  
  # Not sure how useful caching the rows, cols and cells are.
  #   For example,
  #       table.rows.where {|row| row['field'] == 'foo'}
  #       table.rows.map(&:values)
  #   caches nrows Row + ncols * nrows Cell objects (potentially a lot).
  #
  # The only place it might be useful is if you want to do several things
  # with a row or column, then it will save you creating the objects again.
  #
  # But it seems to me object creation in this case is cheap,
  # my guess is the expensive thing is dereferencing a ton of objects
  # at once which means the GC kicks in.
  #
  # The only way to know for sure is to do some performance testing.
  #
  def row(n)
    return nil unless n < row_count
    if @cache
      @row_cache[n] ||= Row.new(self, n)
    else
      Row.new(self, n)
    end
  end
  
  def col(n_or_name)
    n = header_index(n_or_name)
    return nil unless n < col_count
    if @cache
      @col_cache[n] ||= Col.new(self, n)
    else
      Col.new(self, n)
    end
  end
  
  def cell(nrow, ncol_or_name)
    ncol = header_index(ncol_or_name)
    return nil unless nrow < row_count
    return nil unless ncol < col_count
    if @cache
      @cell_cache[[nrow, ncol]] ||= Cell.new(self, nrow, ncol)
    else
      Cell.new(self, nrow, ncol)
    end
  end
  
  def rows
    @rows ||= ScopedCollection.new(self, :row, (0..(row_count-1)))
  end

  def cols
    @cols ||= ScopedCollection.new(self, :col, (0..(col_count-1)))
  end
  
  def cell_value(nrow, ncol_or_name)
    ncol = header_index(ncol_or_name)
    @data[(nrow * (col_count)) + ncol]
  end
  
  # Usage: 
  #
  # table.select('column1','column2') do |rows| 
  #   rows.where {|row| row['column3'].value == 'foo'}
  #   rows.where {|row| row['status'].value > 0 }
  # end
  # #=> Table.new
  #
  # Equivalent to SELECT 'column1', 'column2'
  #               WHERE 'column3' == 'foo' AND 'status' > 0
  #
  def select(*args)
    args = headers if args.empty?
    hdrs = args.flatten.map {|arg| header(arg)}
    rows.where(true); yield(rows)
    Table.new(
      rows.map(&:values),
      :headers => hdrs
    )
  end
  
  def reset; init_caches!; end
  
    
  # ----  Methods below change table data state
  
  def append_row!(*args)
    insert_row!(*args)
  end
  
  def append_col!(*args)
    insert_col!(*args)
  end
  
  # signatures:
  #   Array           insert 1 row at end
  #   Array, Numeric  insert 1 row before n row
  #   Array, Hash     insert 1 row :after => n or :before => n
  #
  def insert_row!(*args)
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
    init_blank_headers!(input.size) if headers.empty?
    
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
    
    init_caches!
    self
  end
  
  # signatures:
  #   Array           insert 1 cols at end
  #   Array, Numeric  insert 1 cols before n row
  #   Array, Hash     insert 1 cols :after => n or :before => n
  #
  def insert_col!(*args)
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
      col_init!(input, name)
    else
      
      # pad or truncate column based on row count
      input = normalized_rows(input)    
      
      if after
        col_insert_after!(after, input, name)
      end   
      if before
        col_insert_before!(before, input, name)
      end
        
    end
    
    self
  end
  
  def delete_row_data!(n)
    return self if row_count == 0
    n = [n, (row_count - 1)].min
    @data.slice!(
      index_of_row_start(n)..(index_of_next_row_start(n)-1)
    )
    init_caches!
    self
  end
    
  def delete_col_data!(n_or_name)
    return self if col_count == 0
    n = header_index(n_or_name)
    col_delete!(n)
    self
  end
  


  # Call from Col#header=
  def update_header!(ncol_or_name, name)
    headers[header_index(ncol_or_name)] = name
  end
  
  # Call from Cell#value=, #update
  def update_cell_value!(nrow, ncol_or_name, value)
    ncol = header_index(ncol_or_name)
    if (0..(row_count - 1)).include?(nrow) && \
       (0..(col_count - 1)).include?(ncol)
      @data.fill((nrow * (col_count)) + ncol,1) {|i| value}
    end
  end
  
  
  protected
  
  def init_caches!
    @row_cache, @col_cache, @cell_cache = {}, {}, {}
    @rows, @cols = nil, nil
  end
  
  #TODO: these header operations should be moved to a separate class
  
  def init_headers!(names = [])
    names = [names] unless names.is_a?(Array)
    @headers = []
    names.each_with_index {|name, i| @headers[i] = name}
  end
  
  def init_blank_headers!(n)
    @headers = []
    (0..(n-1)).each {|i| @headers[i] = nil} if n > 0
  end
  
  def insert_header!(at, name)
    @headers.insert(at, name)
  end
  
  def delete_header!(at)
    @headers.delete_at(at)
  end
  
  def index_of_row_start(n)
    raise NotImplementedError if n < 0
    n * col_count
  end
  
  def index_of_next_row_start(n)
    raise NotImplementedError if n < 0
    (n+1) * col_count
  end
  
  def index_of_col_start(n)
    raise NotImplementedError if n < 0
    n * row_count
  end
  
  def index_of_next_col_start(n)
    raise NotImplementedError if n < 0
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
  
  #--- column operations that reassign @data and modify @headers
  
  def col_init!(cdata, name = nil)
    @data = cdata
    name ? init_headers!(name) : init_blank_headers!(1)
    init_caches!
    self
  end
  
  def col_insert_before!(pos, cdata, name = nil)
    pos = [pos, (col_count - 1)].min
    i = -1
    @data = \
      @data.inject([]) do |memo, it|
        i += 1
        if (i % col_count) == pos
          memo << cdata.shift
        end
        memo << it
        memo
      end
      
    if name
      insert_header!(pos, name)
    else
      init_blank_headers!(headers.size + 1)
    end
    init_caches!
    self
  end
  
  def col_insert_after!(pos, cdata, name = nil)
    pos = [pos, (col_count - 1)].min
    i = -1
    @data = \
      @data.inject([]) do |memo, it|
        i += 1
        memo << it
        if (i % col_count) == pos
          memo << cdata.shift
        end
        memo
      end
    if name
      insert_header!((-1 * pos), name)
    else
      init_blank_headers!(headers.size + 1)
    end
    init_caches!
    self
  end
  
  def col_delete!(pos)
    pos = [pos, (col_count - 1)].min
    i = -1
    @data = \
      @data.inject([]) do |memo, it|
        i += 1
        unless (i % col_count) == pos
          memo << it
        end
        memo
      end
    delete_header!(pos)
    init_caches!
    self
  end
  
end
end
end
