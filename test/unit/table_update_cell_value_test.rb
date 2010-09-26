require 'test/helper'
require 'lib/data_table'

class TableUpdateCellValueTest_WhenFirstRow <  Test::Unit::TestCase
  
  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
    @change_row = 0
    @change_col = 1
    @change_val = 'boo'
    @subject.update_cell_value!(@change_row, @change_col, @change_val)
  end
 
  must 'return changed value for specified cell' do
    assert_equal @change_val, @subject.cell_value(@change_row, @change_col)
  end
  
  must 'return value matching each cell in changed row of input except the changed column' do
    (0..@input[@change_row].size - 1).each do |i|
      unless i == @change_col
        assert_equal @input[@change_row][i], @subject.cell_value(@change_row,i)
      end
    end
  end   
end

class TableUpdateCellValueTest_WhenLastRow <  Test::Unit::TestCase
  
  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
    @change_row = @input.size - 1
    @change_col = 2
    @change_val = 'boo'
    @subject.update_cell_value!(@change_row, @change_col, @change_val)
  end

  must 'return changed value for specified cell' do
    assert_equal @change_val, @subject.cell_value(@change_row, @change_col)
  end
  
  must 'return value matching each cell in changed row of input except the changed column' do
    (0..@input[@change_row].size - 1).each do |i|
      unless i == @change_col
        assert_equal @input[@change_row][i], @subject.cell_value(@change_row,i)
      end
    end
  end   
end

class TableUpdateCellValueTest_WhenMiddleRow <  Test::Unit::TestCase
 
  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
    @change_row = 1
    @change_col = 3
    @change_val = 'boo'
    @subject.update_cell_value!(@change_row, @change_col, @change_val)
  end

  must 'return changed value for specified cell' do
    assert_equal @change_val, @subject.cell_value(@change_row, @change_col)
  end
  
  must 'return value matching each cell in changed row of input except the changed column' do
    (0..@input[@change_row].size - 1).each do |i|
      unless i == @change_col
        assert_equal @input[@change_row][i], @subject.cell_value(@change_row,i)
      end
    end
  end   
end

class TableUpdateCellValueTest_WhenFirstCol < Test::Unit::TestCase
  
  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
    @change_row = 1
    @change_col = 0
    @change_val = 'boo'
    @subject.update_cell_value!(@change_row, @change_col, @change_val)
  end
 
  must 'return changed value for specified cell' do
    assert_equal @change_val, @subject.cell_value(@change_row, @change_col)
  end
  
  must 'return value matching each cell in changed col of input except the changed row' do
    (0..@input.size - 1).each do |i|
      unless i == @change_row
        assert_equal @input[i][@change_col], @subject.cell_value(i,@change_col)
      end
    end
  end   
  
end

class TableUpdateCellValueTest_WhenLastCol < Test::Unit::TestCase
 
  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
    @change_row = 2
    @change_col = @input[0].size - 1
    @change_val = 'boo'
    @subject.update_cell_value!(@change_row, @change_col, @change_val)
  end
 
  must 'return changed value for specified cell' do
    assert_equal @change_val, @subject.cell_value(@change_row, @change_col)
  end
  
  must 'return value matching each cell in changed col of input except the changed row' do
    (0..@input.size - 1).each do |i|
      unless i == @change_row
        assert_equal @input[i][@change_col], @subject.cell_value(i,@change_col)
      end
    end
  end   
  
end

class TableUpdateCellValueTest_WhenMiddleCol < Test::Unit::TestCase
 
  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
    @change_row = 2
    @change_col = 3
    @change_val = 'boo'
    @subject.update_cell_value!(@change_row, @change_col, @change_val)
  end
 
  must 'return changed value for specified cell' do
    assert_equal @change_val, @subject.cell_value(@change_row, @change_col)
  end
  
  must 'return value matching each cell in changed col of input except the changed row' do
    (0..@input.size - 1).each do |i|
      unless i == @change_row
        assert_equal @input[i][@change_col], @subject.cell_value(i,@change_col)
      end
    end
  end   
  
end

class TableUpdateCellValueTest_WhenFirstColNamed < Test::Unit::TestCase
 
  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @headers = %w{first second third fourth fifth}
    @subject = RMU::Data::Table.new(@input, :headers => @headers)
    @change_row = 1
    @change_col = 'first'
    @change_val = 'boo'
    @subject.update_cell_value!(@change_row, @change_col, @change_val)
  end
 
  must 'return changed value for specified cell' do
    assert_equal @change_val, @subject.cell_value(@change_row, @change_col)
  end
  
  must 'return value matching each cell in changed col of input except the changed row' do
    (0..@input.size - 1).each do |i|
      unless i == @change_row
        assert_equal @input[i][@headers.index(@change_col)], @subject.cell_value(i,@change_col)
      end
    end
  end   
  
end

class TableUpdateCellValueTest_WhenLastColNamed < Test::Unit::TestCase
 
  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @headers = %w{first second third fourth fifth}
    @subject = RMU::Data::Table.new(@input, :headers => @headers)
    @change_row = 1
    @change_col = 'fifth'
    @change_val = 'boo'
    @subject.update_cell_value!(@change_row, @change_col, @change_val)
  end
 
  must 'return changed value for specified cell' do
    assert_equal @change_val, @subject.cell_value(@change_row, @change_col)
  end
  
  must 'return value matching each cell in changed col of input except the changed row' do
    (0..@input.size - 1).each do |i|
      unless i == @change_row
        assert_equal @input[i][@headers.index(@change_col)], @subject.cell_value(i,@change_col)
      end
    end
  end   
  
end

class TableUpdateCellValueTest_WhenMiddleColNamed < Test::Unit::TestCase
 
  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @headers = %w{first second third fourth fifth}
    @subject = RMU::Data::Table.new(@input, :headers => @headers)
    @change_row = 1
    @change_col = 'second'
    @change_val = 'boo'
    @subject.update_cell_value!(@change_row, @change_col, @change_val)
  end
 
  must 'return changed value for specified cell' do
    assert_equal @change_val, @subject.cell_value(@change_row, @change_col)
  end
  
  must 'return value matching each cell in changed col of input except the changed row' do
    (0..@input.size - 1).each do |i|
      unless i == @change_row
        assert_equal @input[i][@headers.index(@change_col)], @subject.cell_value(i,@change_col)
      end
    end
  end   
  
end

class TableUpdateCellValueTest_WhenRowPastEOF < Test::Unit::TestCase
  
  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
    @change_row = 3
    @change_col = 1
    @change_val = 'boo'
    @data_orig = @subject.data.dup.freeze
    @subject.update_cell_value!(@change_row, @change_col, @change_val)
  end
 
  must 'return value is nil' do
    assert_equal nil, @subject.cell_value(@change_row, @change_col)
  end
  
  must 'data be unchanged' do
    assert_equal @data_orig, @subject.data
  end   
end

class TableUpdateCellValueTest_WhenColPastEOF < Test::Unit::TestCase
  
  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
    @change_row = 1
    @change_col = 5
    @change_val = 'boo'
  end
  
  must 'raise error' do
    assert_raise(ArgumentError) do 
      @subject.update_cell_value!(@change_row, @change_col, @change_val)
    end
  end
  
end

class TableUpdateCellValueTest_WhenColUnknown < Test::Unit::TestCase
  
  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
    @change_row = 2
    @change_col = 'foo'
    @change_val = 'boo'
  end
  
  must 'raise error' do
    assert_raise(ArgumentError) do 
      @subject.update_cell_value!(@change_row, @change_col, @change_val)
    end
  end
  
end
