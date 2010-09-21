require 'test/helper'
require 'lib/data_table/table'


class TableDeleteRowTest_WhenEmpty < Test::Unit::TestCase

  def setup
    @subject = RMU::Data::Table.new
    @orig_headers = @subject.headers.dup
    @orig_data = @subject.data.dup
    @subject.delete_row_data(0)
  end
  
  must "data be equal to original state" do
    assert_equal @orig_data, @subject.data
  end
  
  must "headers be equal to original state" do
    assert_equal @orig_headers, @subject.headers
  end

end

class TableDeleteRowTest_WhenOneRowOneCol < Test::Unit::TestCase

  def setup
    @input = [1]
    @subject = RMU::Data::Table.new(@input)
    @subject.delete_row_data(0)
  end
  
  must "data be empty" do
    assert_equal [], @subject.data
  end
  
  must "have row_count == 0" do
    assert_equal 0, @subject.row_count
  end
  
  must "have col_count == 1" do
    assert_equal 1, @subject.col_count
  end
  
end

class TableDeleteRowTest_WhenOneRowThreeCols < Test::Unit::TestCase

  def setup
    @input = [1,2,3]
    @subject = RMU::Data::Table.new(@input)
    @subject.delete_row_data(0)
  end
  
  must "data be empty" do
    assert_equal [], @subject.data
  end
  
  must "have row_count == 0" do
    assert_equal 0, @subject.row_count
  end
  
  must "have col_count == 3" do
    assert_equal 3, @subject.col_count
  end
  
end

class TableDeleteRowTest_WhenThreeRowsOneCol < Test::Unit::TestCase

  def setup
    @input = [[1],[2],[3]]
    @subject = RMU::Data::Table.new(@input)
    @subject.delete_row_data(1)
  end
  
  must "data be missing the deleted row" do
    assert_equal [1,3], @subject.data
  end
  
  must "have row_count == 2" do
    assert_equal 2, @subject.row_count
  end
  
  must "have col_count == 1" do
    assert_equal 1, @subject.col_count
  end
  
end

class TableDeleteRowTest_WhenThreeRowsThreeCols < Test::Unit::TestCase

  def setup
    @input = [[1,2,3],[4,5,6],[7,8,9]]
    @subject = RMU::Data::Table.new(@input)
    @subject.delete_row_data(2)
  end
  
  must "data be missing the deleted row" do
    assert_equal [1,2,3,4,5,6], @subject.data
  end
  
  must "have row_count == 2" do
    assert_equal 2, @subject.row_count
  end
  
  must "have col_count == 3" do
    assert_equal 3, @subject.col_count
  end
  
end

class TableDeleteRowTest_WhenRowIndexAfterEOF < Test::Unit::TestCase

  def setup
    @input = [[1,2,3],[4,5,6],[7,8,9]]
    @subject = RMU::Data::Table.new(@input)
    @subject.delete_row_data(3)
  end
  
  must "data be missing the last row" do
    assert_equal [1,2,3,4,5,6], @subject.data
  end
  
  must "have row_count == 2" do
    assert_equal 2, @subject.row_count
  end
  
  must "have col_count == 3" do
    assert_equal 3, @subject.col_count
  end
  
end

# Note: not yet implemented

class TableDeleteRowTest_WhenRowIndexNegative < Test::Unit::TestCase

  def setup
    @input = [[1,2,3],[4,5,6],[7,8,9]]
    @subject = RMU::Data::Table.new(@input)
    @subject.delete_row_data(-2)
  end
  
  must "data be missing the 2nd row from the end" do
    assert_equal [1,2,3,7,8,9], @subject.data
  end
  
  must "have row_count == 2" do
    assert_equal 2, @subject.row_count
  end
  
  must "have col_count == 3" do
    assert_equal 3, @subject.col_count
  end
  
end
