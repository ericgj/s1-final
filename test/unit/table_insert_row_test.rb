require 'test/helper'
require 'lib/data_table/table'

#----------------------------------------
#  Tests of default inserts into empty table
#----------------------------------------
class TableInsertRowTest_WhenNoArgs < Test::Unit::TestCase

  def setup
    @subject = RMU::Data::Table.new
    @orig_headers = @subject.headers.dup
    @orig_data = @subject.data.dup
    @subject.insert_rows
  end
  
  must "data be equal to original state" do
    assert_equal @orig_data, @subject.data
  end
  
  must "headers be equal to original state" do
    assert_equal @orig_headers, @subject.headers
  end
  
end

class TableInsertRowTest_WhenEmptyArray < Test::Unit::TestCase

  def setup
    @subject = RMU::Data::Table.new
    @orig_headers = @subject.headers.dup
    @orig_data = @subject.data.dup
    @subject.insert_rows([])
  end
  
  must "data be equal to original state" do
    assert_equal @orig_data, @subject.data
  end
  
  must "headers be equal to original state" do
    assert_equal @orig_headers, @subject.headers
  end
  
end

# Possibly this case should raise error instead
class TableInsertRowTest_WhenSimpleNumericValue < Test::Unit::TestCase

  def setup
    @subject = RMU::Data::Table.new
    @orig_headers = @subject.headers.dup
    @orig_data = @subject.data.dup
    @subject.insert_rows(1)
  end
  
  must "have row_count == 0" do
    assert_equal 0, @subject.row_count
  end
  
  must "have col_count == 0" do
    assert_equal 0, @subject.col_count
  end
  
  must "headers be equal to original state" do
    assert_equal @orig_headers, @subject.headers
  end
  
end

class TableInsertRowTest_WhenSimpleNonNumericValue < Test::Unit::TestCase

  def setup
    @input = 'a'
    @subject = RMU::Data::Table.new
    @subject.insert_rows(@input)
  end
  
  must "data be equal to array of input" do
    assert_equal [@input], @subject.data
  end
  
  must "have row_count == 1" do
    assert_equal 1, @subject.row_count
  end
  
  must "have col_count == size of input array" do
    assert_equal @input.size, @subject.col_count
  end
  
  must "have headers named sequentially" do
    assert_equal (0..@input.size-1).to_a, @subject.headers.to_a
  end
  
end

class TableInsertRowTest_WhenSimpleNonNumericValues < Test::Unit::TestCase

  def setup
    @input = %w{a b c d}
    @subject = RMU::Data::Table.new
    @subject.insert_rows(*@input)
  end
  
  must "data be equal to given array" do
    assert_equal @input, @subject.data
  end
  
  must "have row_count == 1" do
    assert_equal 1, @subject.row_count
  end
  
  must "have col_count == size of input array" do
    assert_equal @input.size, @subject.col_count
  end
  
  must "have headers named sequentially" do
    assert_equal (0..@input.size-1).to_a, @subject.headers
  end
  
end

class TableInsertRowTest_WhenSimpleArray < Test::Unit::TestCase

  def setup
    @input = [1,2,3,4]
    @subject = RMU::Data::Table.new
    @subject.insert_rows(@input)
  end
  
  must "data be equal to given array" do
    assert_equal @input, @subject.data
  end
  
  must "have row_count == 1" do
    assert_equal 1, @subject.row_count
  end
  
  must "have col_count == size of input array" do
    assert_equal @input.size, @subject.col_count
  end
  
  must "have headers named sequentially" do
    assert_equal (0..@input.size-1).to_a, @subject.headers
  end
  
end

class TableInsertRowTest_WhenSimpleArrays < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4],[5,6,7,8],[9,10,11,12]]
    @subject = RMU::Data::Table.new
    @subject.insert_rows(*@input)
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


class TableInsertRowTest_WhenComplexArray < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4],[5,6,7,8],[9,10,11,12]]
    @subject = RMU::Data::Table.new
    @subject.insert_rows(@input)
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

class TableInsertRowTest_WhenJaggedArray < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4],[5,6,7,8,9],[10,11,12]]
    @subject = RMU::Data::Table.new
    @subject.insert_rows(@input)
  end
  
  must "data be equal to given array flattened and padding with nil" do
    assert_equal [1,2,3,4,nil,5,6,7,8,9,10,11,12,nil,nil], @subject.data
  end
  
  must "have row_count == size of input array" do
    assert_equal @input.size, @subject.row_count
  end
  
  must "have col_count == size of largest element of input array" do
    assert_equal 5, @subject.col_count
  end
  
end
