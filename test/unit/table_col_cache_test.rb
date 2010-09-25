require 'test/helper'
require 'lib/data_table'

class TableColTest_AfterInsertRow < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
    @before = @subject.col(2)
    @subject.insert_row!([16,17,18,19,20],2)
  end
  
  must 'return updated column' do
    assert_equal [3,8,18,13], @subject.col(2).map(&:value)
  end
  
end

class TableColTest_AfterInsertCol < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
    @before = @subject.col(4)
    @subject.insert_col!([16,17,18],2)
  end
  
  must 'return updated column' do
    assert_equal [4,9,14], @subject.col(4).map(&:value)
  end
  
end

class TableColTest_AfterDeleteRowData < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
    @before = @subject.col(3)
    @subject.delete_row_data!(2)
  end
  
  must 'return updated column' do
    assert_equal [4,9], @subject.col(3).map(&:value)
  end
  
end

class TableColTest_AfterDeleteColData < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
    @before = @subject.col(1)
    @subject.delete_col_data!(1)
  end
  
  must 'return updated column' do
    assert_equal [3,8,13], @subject.col(1).map(&:value)
  end
  
end

class TableColTest_AfterUpdateHeader < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
    @before = @subject.col(0)
    @subject.update_header!(0, 'foo')
  end
  
  must 'return updated column' do
    assert_equal [1,6,11], @subject.col(0).map(&:value)
  end
  
end

class TableColTest_AfterUpdateCellValue < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
    @before = @subject.col(4)
    @subject.update_cell_value!(2, 4, 'surprise!')
  end
  
  must 'return updated column' do
    assert_equal [5,10,'surprise!'], @subject.col(4).map(&:value)
  end
  
end