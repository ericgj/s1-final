require 'test/helper'
require 'lib/data_table'

class TableNewTest_WhenNoArgs < Test::Unit::TestCase

  def setup
    @subject = RMU::Data::Table.new  
  end
  
  must "be empty" do
    assert_equal 0, @subject.data.size
  end
  
  must "have row_count == 0" do
    assert_equal 0, @subject.row_count
  end
  
  must "have col_count == 0" do
    assert_equal 0, @subject.col_count
  end
  
  must "have empty headers" do
    assert_equal 0, @subject.headers.size
  end
  
end

class TableNewTest_WhenHeadersAndNoData < Test::Unit::TestCase

  def setup
    @input = %w(one two three four)
    @subject = RMU::Data::Table.new([], :headers => @input)  
  end
  
  must "be empty" do
    assert_equal 0, @subject.data.size
  end
  
  must "have row_count == 0" do
    assert_equal 0, @subject.row_count
  end
  
  must "have col_count == size of input headers array" do
    assert_equal @input.size, @subject.col_count
  end
  
  must "have headers == input headers array" do
    assert_equal @input, @subject.headers.to_a
  end
  
end

class TableNewTest_WhenHeadersAndData < Test::Unit::TestCase

  def setup
    @headers = %w(one two three four)
    @input = [[1,2,3,4],[5,6,7,8]]
    @subject = RMU::Data::Table.new(@input, :headers => @headers)  
  end
  
  must "data be equal to given array flattened" do
    assert_equal @input.flatten, @subject.data
  end
  
  must "have row_count == size of given array" do
    assert_equal @input.size, @subject.row_count
  end
  
  must "have col_count == size of given headers array" do
    assert_equal @headers.size, @subject.col_count
  end
  
  must "have headers == given headers array" do
    assert_equal @headers, @subject.headers
  end
  
end

class TableNewTest_WhenSimpleArray < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4]]
    @subject = RMU::Data::Table.new(@input)
  end
  
  must "data be equal to given array flattened" do
    assert_equal @input.flatten, @subject.data
  end
  
  must "have row_count == 1" do
    assert_equal 1, @subject.row_count
  end
  
  must "have col_count == size of input array" do
    assert_equal 4, @subject.col_count
  end
  
end

class TableNewTest_WhenComplexArray < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4],[5,6,7,8],[9,10,11,12]]
    @subject = RMU::Data::Table.new(@input)
  end
  
  must "data be equal to given array flattened" do
    assert_equal @input.flatten, @subject.data
  end
  
  must "have row_count == size of input array" do
    assert_equal @input.size, @subject.row_count
  end
  
  must "have col_count == size of first element of input array" do
    assert_equal @input.first.size, @subject.col_count
  end
  
end

#
# Tests when :headers => true
#

class TableNewTest_WhenHeadersTrueOneRow < Test::Unit::TestCase

  def setup
    @input = ['col1','col2','col3'].freeze
    @subject = RMU::Data::Table.new(@input, :headers => true)
  end
  
  must "data be empty array" do
    assert_equal [], @subject.data
  end
  
  must "have row_count == 0" do
    assert_equal 0, @subject.row_count
  end
  
  must "have col_count == size of input array" do
    assert_equal @input.size, @subject.col_count
  end
  
  must "have headers == input array" do
    assert_equal @input, @subject.headers
  end
  
end

class TableNewTest_WhenHeadersTrueThreeRows < Test::Unit::TestCase

  def setup
    @input = [['col1','col2','col3'],[1,2,3],[4,5,6]].freeze
    @subject = RMU::Data::Table.new(@input, :headers => true)
  end
  
  must "data be equal to given array with first element removed and flattened" do
    assert_equal @input[1..2].flatten, @subject.data
  end
  
  must "have row_count == 2" do
    assert_equal 2, @subject.row_count
  end
  
  must "have col_count == size of first element of input array" do
    assert_equal @input[0].size, @subject.col_count
  end
  
  must "have headers == first element of input array" do
    assert_equal @input[0], @subject.headers
  end
  
end

class TableNewTest_WhenHeadersTrueNoRows < Test::Unit::TestCase

  def setup
    @input = [].freeze
    @subject = RMU::Data::Table.new(@input, :headers => true)
  end
  
  must "data be empty array" do
    assert_equal [], @subject.data
  end
    
  must "have row_count == 0" do
    assert_equal 0, @subject.row_count
  end
  
  must "have col_count == size of input array" do
    assert_equal @input.size, @subject.col_count
  end
  
  must "have headers == input array" do
    assert_equal @input, @subject.headers
  end
  
end