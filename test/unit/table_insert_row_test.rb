require 'test/helper'
require 'lib/data_table'

#----------------------------------------
#  Tests of default inserts (appends) into empty table
#----------------------------------------
class TableInsertRowTest_WhenNoArgs < Test::Unit::TestCase

  def setup
    @subject = RMU::Data::Table.new
    @orig_headers = @subject.headers.dup
    @orig_data = @subject.data.dup
    @subject.insert_row
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
    @subject.insert_row([])
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
    @subject.insert_row(1)
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
    @subject.insert_row(@input)
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
    
end

class TableInsertRowTest_WhenSimpleNonNumericValues < Test::Unit::TestCase

  def setup
    @input = %w{a b c d}
    @subject = RMU::Data::Table.new
    @subject.insert_row(*@input)
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
  
end

class TableInsertRowTest_WhenSimpleArray < Test::Unit::TestCase

  def setup
    @input = [1,2,3,4]
    @subject = RMU::Data::Table.new
    @subject.insert_row(@input)
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
  
end




#----------------------------------------
#  Tests of inserts before
#----------------------------------------
class TableInsertRowTest_BeforeWhenEmpty < Test::Unit::TestCase

  def setup
    @input = [1,2,3,4]
    @subject = RMU::Data::Table.new
    @subject.insert_row(@input, :before => 99)
  end
  
  must "data be equal to the given array flattened" do
    assert_equal @input.flatten, @subject.data
  end
  
  must "have row_count == 1" do
    assert_equal 1, @subject.row_count
  end
  
  must "have col_count == size of input array" do
    assert_equal 4, @subject.col_count
  end
  
end

class TableInsertRowTest_BeforeWhenOneRow < Test::Unit::TestCase

  def setup
    @input = [5,6,7,8]
    @subject = RMU::Data::Table.new([1,2,3,4])
    @subject.insert_row(@input, :before => 0)
  end
  
  must "data be equal to the existing array with the inserted row flattened" do
    assert_equal [5,6,7,8,1,2,3,4], @subject.data
  end
  
  must "have row_count == 2" do
    assert_equal 2, @subject.row_count
  end
  
  must "have col_count == size of input array" do
    assert_equal 4, @subject.col_count
  end
  
end

class TableInsertRowTest_BeforeWhenOneRowAfterEOF < Test::Unit::TestCase

  def setup
    @input = [5,6,7,8]
    @subject = RMU::Data::Table.new([1,2,3,4])
    @subject.insert_row(@input, :before => 2)
  end
  
  must "data be equal to the existing array with the inserted row flattened" do
    assert_equal [1,2,3,4,5,6,7,8], @subject.data
  end
  
  must "have row_count == 2" do
    assert_equal 2, @subject.row_count
  end
  
  must "have col_count == size of input array" do
    assert_equal 4, @subject.col_count
  end
  
end

class TableInsertRowTest_BeforeWhenThreeRows < Test::Unit::TestCase

  def setup
    @input = [5,6,7,8]
    @subject = RMU::Data::Table.new([[1,2,3,4],[9,10,11,12]])
    @subject.insert_row(@input, :before => 1)
  end
  
  must "data be equal to the existing array with the inserted row flattened" do
    assert_equal [1,2,3,4,5,6,7,8,9,10,11,12], @subject.data
  end
  
  must "have row_count == 3" do
    assert_equal 3, @subject.row_count
  end
  
  must "have col_count == size of input array" do
    assert_equal 4, @subject.col_count
  end
  
end

class TableInsertRowTest_BeforeWhenMoreCols < Test::Unit::TestCase

  def setup
    @input = [5,6,7,8,9,10,11,12]
    @subject = RMU::Data::Table.new([1,2,3,4])
    @subject.insert_row(@input, :before => 0)
  end
  
  must "data be equal to the existing array with the inserted row truncated and flattened" do
    assert_equal [5,6,7,8,1,2,3,4], @subject.data
  end
  
  must "have row_count == 2" do
    assert_equal 2, @subject.row_count
  end
  
  must "have col_count == size of input array" do
    assert_equal 4, @subject.col_count
  end
  
end

class TableInsertRowTest_BeforeWhenLessCols < Test::Unit::TestCase

  def setup
    @input = [5]
    @subject = RMU::Data::Table.new([1,2,3,4])
    @subject.insert_row(@input, :before => 0)
  end
  
  must "data be equal to the existing array with the inserted row padded and flattened" do
    assert_equal [5,nil,nil,nil,1,2,3,4], @subject.data
  end
  
  must "have row_count == 2" do
    assert_equal 2, @subject.row_count
  end
  
  must "have col_count == size of input array" do
    assert_equal 4, @subject.col_count
  end
  
end

class TableInsertRowTest_BeforeWhenThreeRowsSpecifyingNumber < Test::Unit::TestCase

  def setup
    @input = [5,6,7,8]
    @subject = RMU::Data::Table.new([[1,2,3,4],[9,10,11,12]])
    @subject.insert_row(@input, 1)
  end
  
  must "data be equal to the existing array with the inserted row flattened" do
    assert_equal [1,2,3,4,5,6,7,8,9,10,11,12], @subject.data
  end
  
  must "have row_count == 3" do
    assert_equal 3, @subject.row_count
  end
  
  must "have col_count == size of input array" do
    assert_equal 4, @subject.col_count
  end
  
end

#----------------------------------------
#  Tests of inserts after
#----------------------------------------
class TableInsertRowTest_AfterWhenEmpty < Test::Unit::TestCase

  def setup
    @input = [1,2,3,4]
    @subject = RMU::Data::Table.new
    @subject.insert_row(@input, :after => 99)
  end
  
  must "data be equal to the given array flattened" do
    assert_equal @input.flatten, @subject.data
  end
  
  must "have row_count == 1" do
    assert_equal 1, @subject.row_count
  end
  
  must "have col_count == size of input array" do
    assert_equal 4, @subject.col_count
  end
  
end

class TableInsertRowTest_AfterWhenOneRow < Test::Unit::TestCase

  def setup
    @input = [5,6,7,8]
    @subject = RMU::Data::Table.new([1,2,3,4])
    @subject.insert_row(@input, :after => 0)
  end
  
  must "data be equal to the existing array with the inserted row flattened" do
    assert_equal [1,2,3,4,5,6,7,8], @subject.data
  end
  
  must "have row_count == 2" do
    assert_equal 2, @subject.row_count
  end
  
  must "have col_count == size of input array" do
    assert_equal 4, @subject.col_count
  end
  
end

class TableInsertRowTest_AfterWhenOneRowAfterEOF < Test::Unit::TestCase

  def setup
    @input = [5,6,7,8]
    @subject = RMU::Data::Table.new([1,2,3,4])
    @subject.insert_row(@input, :after => 2)
  end
  
  must "data be equal to the existing array with the inserted row flattened" do
    assert_equal [1,2,3,4,5,6,7,8], @subject.data
  end
  
  must "have row_count == 2" do
    assert_equal 2, @subject.row_count
  end
  
  must "have col_count == size of input array" do
    assert_equal 4, @subject.col_count
  end
  
end

class TableInsertRowTest_AfterWhenThreeRows < Test::Unit::TestCase

  def setup
    @input = [5,6,7,8]
    @subject = RMU::Data::Table.new([[1,2,3,4],[9,10,11,12]])
    @subject.insert_row(@input, :after => 0)
  end
  
  must "data be equal to the existing array with the inserted row flattened" do
    assert_equal [1,2,3,4,5,6,7,8,9,10,11,12], @subject.data
  end
  
  must "have row_count == 3" do
    assert_equal 3, @subject.row_count
  end
  
  must "have col_count == size of input array" do
    assert_equal 4, @subject.col_count
  end
  
end

class TableInsertRowTest_AfterWhenMoreCols < Test::Unit::TestCase

  def setup
    @input = [5,6,7,8,9,10,11,12]
    @subject = RMU::Data::Table.new([1,2,3,4])
    @subject.insert_row(@input, :after => 0)
  end
  
  must "data be equal to the existing array with the inserted row truncated and flattened" do
    assert_equal [1,2,3,4,5,6,7,8], @subject.data
  end
  
  must "have row_count == 2" do
    assert_equal 2, @subject.row_count
  end
  
  must "have col_count == size of input array" do
    assert_equal 4, @subject.col_count
  end
  
end

class TableInsertRowTest_AfterWhenLessCols < Test::Unit::TestCase

  def setup
    @input = [5]
    @subject = RMU::Data::Table.new([1,2,3,4])
    @subject.insert_row(@input, :after => 0)
  end
  
  must "data be equal to the existing array with the inserted row padded and flattened" do
    assert_equal [1,2,3,4,5,nil,nil,nil], @subject.data
  end
  
  must "have row_count == 2" do
    assert_equal 2, @subject.row_count
  end
  
  must "have col_count == size of input array" do
    assert_equal 4, @subject.col_count
  end
  
end