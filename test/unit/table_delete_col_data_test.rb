require 'test/helper'
require 'lib/data_table'

class TableDeleteColTest_WhenEmpty < Test::Unit::TestCase

  def setup
    @subject = RMU::Data::Table.new
    @orig_headers = @subject.headers.dup
    @orig_data = @subject.data.dup
    @subject.delete_col_data!(0)
  end
  
  must "data be equal to original state" do
    assert_equal @orig_data, @subject.data
  end
  
  must "headers be equal to original state" do
    assert_equal @orig_headers, @subject.headers
  end

end

class TableDeleteColTest_WhenOneRowOneCol < Test::Unit::TestCase

  def setup
    @input = [1]
    @subject = RMU::Data::Table.new(@input)
    @subject.delete_col_data!(0)
  end
  
  must "data be empty" do
    assert_equal [], @subject.data
  end
  
  must "have row_count == 0" do
    assert_equal 0, @subject.row_count
  end
  
  must "have col_count == 0" do
    assert_equal 0, @subject.col_count
  end
  
end

class TableDeleteColTest_WhenOneRowThreeCols < Test::Unit::TestCase

  def setup
    @input = [1,2,3]
    @subject = RMU::Data::Table.new(@input)
    @subject.delete_col_data!(1)
  end
  
  must "data be missing the deleted col" do
    assert_equal [1,3], @subject.data
  end
  
  must "have row_count == 1" do
    assert_equal 1, @subject.row_count
  end
  
  must "have col_count == 2" do
    assert_equal 2, @subject.col_count
  end
  
end

class TableDeleteColTest_WhenThreeRowsOneCol < Test::Unit::TestCase

  def setup
    @input = [[1],[2],[3]]
    @subject = RMU::Data::Table.new(@input)
    @subject.delete_col_data!(0)
  end
  
  must "data be empty" do
    assert_equal [], @subject.data
  end
  
  must "have row_count == 0" do
    assert_equal 0, @subject.row_count
  end
  
  must "have col_count == 0" do
    assert_equal 0, @subject.col_count
  end
  
end

class TableDeleteColTest_WhenThreeRowsThreeCols < Test::Unit::TestCase

  def setup
    @input = [[1,2,3],[4,5,6],[7,8,9]]
    @subject = RMU::Data::Table.new(@input)
    @subject.delete_col_data!(2)
  end
  
  must "data be missing the deleted col" do
    assert_equal [1,2,4,5,7,8], @subject.data
  end
  
  must "have row_count == 3" do
    assert_equal 3, @subject.row_count
  end
  
  must "have col_count == 2" do
    assert_equal 2, @subject.col_count
  end
  
end


class TableDeleteColTest_WhenColIndexAfterEOF < Test::Unit::TestCase

  def setup
    @input = [[1,2,3],[4,5,6],[7,8,9]]
    @subject = RMU::Data::Table.new(@input)
  end
  
  must "raise error (column not found)" do
    assert_raise(ArgumentError) {
      @subject.delete_col_data!(3)
    }
  end
  
end

class TableDeleteColTest_WhenColIndexNegative < Test::Unit::TestCase

  def setup
    @input = [[1,2,3],[4,5,6],[7,8,9]]
    @subject = RMU::Data::Table.new(@input)
    @subject.delete_col_data!(-2)
  end
  
  must "data be missing the 2nd col from the end" do
    assert_equal [1,3,4,6,7,9], @subject.data
  end
  
  must "have row_count == 3" do
    assert_equal 3, @subject.row_count
  end
  
  must "have col_count == 2" do
    assert_equal 2, @subject.col_count
  end
  
end
