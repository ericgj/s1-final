# Set-like class for dealing with headers
# Complains if duplicate header names
#
# TODO: integrate this into Table
#
module RMU
module Data
module Table
class Headers
  include Enumerable
  
  def initialize(*args)
    @hsh = {}
    if args.size == 1 && Numeric === args.first
      @ary = Array.new(*args)
    else
      @ary = Array.new
      push *args
    end
  end
  
  def each
    @ary.each {|it| yield(it)}
  end
  
  def push(*args)
    args.each do |it|
      raise_if_found(it)
      @ary.push(it) && @hsh[it] = it
    end
  end
  alias_method :add, :push
  
  def insert(at, *args)
    args.each do |it|
      raise_if_found(it)
      @hsh[it] = it
      @ary.insert(at, it) 
    end
  end
  
  def update(at, val)
    raise_if_found(val)
    @hsh.delete {|k, v| k == @ary[at]}
    @hsh[val] = val
    @ary[at] = val
  end
  
  def pop
    delete(@ary.last)
  end
  
  def delete(at)
    @hsh.delete {|k, v| k == @ary[at]}
    @ary.delete_at(at)
  end
  
  protected
  
  def raise_if_found(name)
    raise ArgumentError, "#{it} is already a column name" \
      if @hsh.has_key?(it)
  end

end
end
end
end