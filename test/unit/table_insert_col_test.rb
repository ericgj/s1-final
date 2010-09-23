require 'test/helper'
require 'lib/data_table'

#----------------------------------------
#  Tests of default inserts (appends) into empty table
#----------------------------------------
class TableInsertColTest_WhenNoArgs < Test::Unit::TestCase

  def setup
    @subject = RMU::Data::Table.new
    @orig_headers = @subject.headers.dup
    @orig_data = @subject.data.dup
    @subject.insert_col!
  end
  
  must "data be equal to original state" do
    assert_equal @orig_data, @subject.data
  end
  
  must "headers be equal to original state" do
    assert_equal @orig_headers, @subject.headers
  end
  
end

class TableInsertColTest_WhenEmptyArray < Test::Unit::TestCase

  def setup
    @subject = RMU::Data::Table.new
    @orig_headers = @subject.headers.dup
    @orig_data = @subject.data.dup
    @subject.insert_col!([])
  end
  
  must "data be equal to original state" do
    assert_equal @orig_data, @subject.data
  end
  
  must "headers be equal to original state" do
    assert_equal @orig_headers, @subject.headers
  end
  
end

class TableInsertColTest_WhenSimpleNonNumericValue < Test::Unit::TestCase

  def setup
    @input = 'a'
    @subject = RMU::Data::Table.new
    @subject.insert_col!(@input)
  end
  
  must "data be equal to array of input" do
    assert_equal [@input], @subject.data
  end
  
  must "have row_count == size of input array" do
    assert_equal [@input].size, @subject.row_count
  end
  
  must "have col_count == 1" do
    assert_equal 1, @subject.col_count
  end
  
end

class TableInsertColTest_WhenSimpleNonNumericValues < Test::Unit::TestCase

  def setup
    @input = %w{a b c d}
    @subject = RMU::Data::Table.new
    @subject.insert_col!(*@input)
  end
  
  must "data be equal to given array" do
    assert_equal @input, @subject.data
  end
  
  must "have row_count == size of input array" do
    assert_equal @input.size, @subject.row_count
  end
  
  must "have col_count == 1" do
    assert_equal 1, @subject.col_count
  end
  
end


#----------------------------------------
#  Tests of inserts before
#----------------------------------------
class TableInsertColTest_BeforeWhenEmpty < Test::Unit::TestCase

  def setup
    @input = [1,2,3,4]
    @subject = RMU::Data::Table.new
    @subject.insert_col!(@input, :before => 99)
  end
  
  must "data be equal to the given array flattened" do
    assert_equal @input.flatten, @subject.data
  end
  
  must "have row_count == size of input array" do
    assert_equal 4, @subject.row_count
  end
  
  must "have col_count == 1" do
    assert_equal 1, @subject.col_count
  end
  
end

class TableInsertColTest_BeforeWhenOneCol < Test::Unit::TestCase

  def setup
    @input = [5,6,7,8]
    @subject = RMU::Data::Table.new([[1],[2],[3],[4]])
    @subject.insert_col!(@input, :before => 0)
  end
  
  must "data be equal to the existing array with the inserted col flattened" do
    assert_equal [5,1,6,2,7,3,8,4], @subject.data
  end
  
  must "have row_count == size of input array" do
    assert_equal 4, @subject.row_count
  end
  
  must "have col_count == 2" do
    assert_equal 2, @subject.col_count
  end
  
end

class TableInsertColTest_BeforeWhenOneColAfterEOF < Test::Unit::TestCase

  def setup
    @input = [5,6,7,8]
    @subject = RMU::Data::Table.new([[1],[2],[3],[4]])
    @subject.insert_col!(@input, :before => 2)
  end
  
  must "data be equal to the existing array with the inserted row flattened" do
    assert_equal [5,1,6,2,7,3,8,4], @subject.data
  end
  
  must "have row_count == size of input array" do
    assert_equal 4, @subject.row_count
  end
  
  must "have col_count == 2" do
    assert_equal 2, @subject.col_count
  end
  
end

class TableInsertColTest_BeforeWhenThreeCols < Test::Unit::TestCase

  def setup
    @input = [2,6,10]
    @subject = RMU::Data::Table.new([[1,3,4],[5,7,8],[9,11,12]])
    @subject.insert_col!(@input, :before => 1)
  end
  
  must "data be equal to the existing array with the inserted col flattened" do
    assert_equal [1,2,3,4,5,6,7,8,9,10,11,12], @subject.data
  end
  
  must "have row_count == size of input array" do
    assert_equal 3, @subject.row_count
  end
  
  must "have col_count == 4" do
    assert_equal 4, @subject.col_count
  end
  
end

class TableInsertColTest_BeforeWhenMoreRows < Test::Unit::TestCase

  def setup
    @input = [5,6,7,8,9,10,11,12]
    @subject = RMU::Data::Table.new([[1],[2],[3],[4]])
    @subject.insert_col!(@input, :before => 0)
  end
  
  must "data be equal to the existing array with the inserted row truncated and flattened" do
    assert_equal [5,1,6,2,7,3,8,4], @subject.data
  end
  
  must "have row_count == 4" do
    assert_equal 4, @subject.row_count
  end
  
  must "have col_count == 2" do
    assert_equal 2, @subject.col_count
  end
  
end

class TableInsertColTest_BeforeWhenLessRows < Test::Unit::TestCase

  def setup
    @input = [5]
    @subject = RMU::Data::Table.new([[1],[2],[3],[4]])
    @subject.insert_col!(@input, :before => 0)
  end
  
  must "data be equal to the existing array with the inserted col padded and flattened" do
    assert_equal [5,1,nil,2,nil,3,nil,4], @subject.data
  end
  
  must "have row_count == 4" do
    assert_equal 4, @subject.row_count
  end
  
  must "have col_count == 2" do
    assert_equal 2, @subject.col_count
  end
  
end


class TableInsertColTest_BeforeWhenThreeColsSpecifyingNumber < Test::Unit::TestCase

  def setup
    @input = [2,6,10]
    @subject = RMU::Data::Table.new([[1,3,4],[5,7,8],[9,11,12]])
    @subject.insert_col!(@input, 1)
  end
  
  must "data be equal to the existing array with the inserted col flattened" do
    assert_equal [1,2,3,4,5,6,7,8,9,10,11,12], @subject.data
  end
  
  must "have row_count == size of input array" do
    assert_equal 3, @subject.row_count
  end
  
  must "have col_count == 4" do
    assert_equal 4, @subject.col_count
  end
  
end

class TableInsertColTest_BeforeWhenThreeColsSpecifyingName < Test::Unit::TestCase
  
end


#----------------------------------------
#  Tests of inserts after
#----------------------------------------


class TableInsertColTest_AfterWhenEmpty < Test::Unit::TestCase

  def setup
    @input = [1,2,3,4]
    @subject = RMU::Data::Table.new
    @subject.insert_col!(@input, :after => 99)
  end
  
  must "data be equal to the given array flattened" do
    assert_equal @input.flatten, @subject.data
  end
  
  must "have row_count == size of input array" do
    assert_equal 4, @subject.row_count
  end
  
  must "have col_count == 1" do
    assert_equal 1, @subject.col_count
  end
  
end

class TableInsertColTest_AfterWhenOneCol < Test::Unit::TestCase

  def setup
    @input = [5,6,7,8]
    @subject = RMU::Data::Table.new([[1],[2],[3],[4]])
    @subject.insert_col!(@input, :after => 0)
  end
  
  must "data be equal to the existing array with the inserted col flattened" do
    assert_equal [1,5,2,6,3,7,4,8], @subject.data
  end
  
  must "have row_count == size of input array" do
    assert_equal 4, @subject.row_count
  end
  
  must "have col_count == 2" do
    assert_equal 2, @subject.col_count
  end
  
end


class TableInsertColTest_AfterWhenOneColAfterEOF < Test::Unit::TestCase

  def setup
    @input = [5,6,7,8]
    @subject = RMU::Data::Table.new([[1],[2],[3],[4]])
    @subject.insert_col!(@input, :after => 2)
  end
  
  must "data be equal to the existing array with the inserted col flattened" do
    assert_equal [1,5,2,6,3,7,4,8], @subject.data
  end
  
  must "have row_count == size of input array" do
    assert_equal 4, @subject.row_count
  end
  
  must "have col_count == 2" do
    assert_equal 2, @subject.col_count
  end
  
end

class TableInsertColTest_AfterWhenThreeCols < Test::Unit::TestCase

  def setup
    @input = [2,6,10]
    @subject = RMU::Data::Table.new([[1,3,4],[5,7,8],[9,11,12]])
    @subject.insert_col!(@input, :after => 0)
  end
  
  must "data be equal to the existing array with the inserted col flattened" do
    assert_equal [1,2,3,4,5,6,7,8,9,10,11,12], @subject.data
  end
  
  must "have row_count == size of input array" do
    assert_equal 3, @subject.row_count
  end
  
  must "have col_count == 4" do
    assert_equal 4, @subject.col_count
  end
  
end

class TableInsertColTest_AfterWhenMoreRows < Test::Unit::TestCase

  def setup
    @input = [5,6,7,8,9,10,11,12]
    @subject = RMU::Data::Table.new([[1],[2],[3],[4]])
    @subject.insert_col!(@input, :after => 0)
  end
  
  must "data be equal to the existing array with the inserted row truncated and flattened" do
    assert_equal [1,5,2,6,3,7,4,8], @subject.data
  end
  
  must "have row_count == 4" do
    assert_equal 4, @subject.row_count
  end
  
  must "have col_count == 2" do
    assert_equal 2, @subject.col_count
  end
  
end

class TableInsertColTest_AfterWhenLessRows < Test::Unit::TestCase

  def setup
    @input = [5]
    @subject = RMU::Data::Table.new([[1],[2],[3],[4]])
    @subject.insert_col!(@input, :after => 0)
  end
  
  must "data be equal to the existing array with the inserted col padded and flattened" do
    assert_equal [1,5,2,nil,3,nil,4,nil], @subject.data
  end
  
  must "have row_count == 4" do
    assert_equal 4, @subject.row_count
  end
  
  must "have col_count == 2" do
    assert_equal 2, @subject.col_count
  end
  
end

class TableInsertColTest_AfterWhenThreeColsSpecifyingName < Test::Unit::TestCase
  
end


__END__

# Possibly this case should raise error instead
class TableInsertColTest_WhenSimpleNumericValue < Test::Unit::TestCase

  def setup
    @subject = RMU::Data::Table.new
    @orig_headers = @subject.headers.dup
    @orig_data = @subject.data.dup
    @subject.insert_col!(1)
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

