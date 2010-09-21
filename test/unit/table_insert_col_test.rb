require 'test/helper'
require 'lib/data_table/table'

#----------------------------------------
#  Tests of default inserts (appends) into empty table
#----------------------------------------
class TableInsertColTest_WhenNoArgs < Test::Unit::TestCase

  def setup
    @subject = RMU::Data::Table.new
    @orig_headers = @subject.headers.dup
    @orig_data = @subject.data.dup
    @subject.insert_col
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
    @subject.insert_col([])
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
    @subject.insert_col(@input)
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
    @subject.insert_col(*@input)
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


__END__
# Possibly this case should raise error instead
class TableInsertColTest_WhenSimpleNumericValue < Test::Unit::TestCase

  def setup
    @subject = RMU::Data::Table.new
    @orig_headers = @subject.headers.dup
    @orig_data = @subject.data.dup
    @subject.insert_col(1)
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

