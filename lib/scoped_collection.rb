# Usage
#
#  class Table
#    def rows
#      @_rows ||= ScopedCollection.new(self, :row, (0..(row_count-1)))
#    end
#  end
#  
#  table.rows.where(0..9) {|row| row['column1'] == 'foo'}
#  table.rows.map(&:values)   # select row values for condition from rows 0..9
  
class ScopedCollection
  include Enumerable
  
  def initialize(target, meth, enum)
    @_target, @_meth, @_default_enum = target, meth, enum
    @_scopes, @_enum, @_cache = nil, nil, nil
  end
  
  def where(enum = nil, &blk)
    case enum
    when TrueClass
      @_enum = nil
      @_scopes = []
#    when Numeric
#      @_enum = (enum..enum)
    else
      if enum
        @_enum = enum
      end
    end
    if block_given?
      (@_scopes ||= []) << blk
    end
    init_cache
    self
  end
  
  def each
    @_cache ||= resolved_scope
    @_cache.each {|r| yield(r)}
  end
    
  protected
  
  def init_cache
    @_cache = nil
  end

  def resolved_scope
    @_enum ||= @_default_enum
    base = \
      case @_enum
      when Numeric
        @_target.__send__(@_meth, @_enum)
      else
        @_enum.inject([]) do |memo, i|
          memo << @_target.__send__(@_meth, i)
          memo
        end
      end
    (@_scopes ||= []).each do |scope|
      base = base.select(&scope)
    end
    base
  end
  
end
