require 'test/helper'
require 'lib/data_table'

class TableCellValueTest_WhenFirstRow < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
  end
  
  must 'return value matching each cell in first row of input' do
    (0..@input.first.size - 1).each do |i|
      assert_equal @input[0][i], @subject.cell_value(0,i)
    end
  end
  
end

class TableCellValueTest_WhenLastRow < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
  end
  
  must 'return value matching each cell in last row of input' do
    (0..@input.first.size - 1).each do |i|
      assert_equal @input[2][i], @subject.cell_value(2,i)
    end
  end
  
end

class TableCellValueTest_WhenMiddleRow < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
  end
  
  must 'return value matching each cell in 2nd row of input' do
    (0..@input.first.size - 1).each do |i|
      assert_equal @input[1][i], @subject.cell_value(1,i)
    end
  end
  
end

class TableCellValueTest_WhenFirstCol < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
  end
  
  must 'return value matching each cell in first col of input' do
    (0..@input.size - 1).each do |i|
      assert_equal @input[i][0], @subject.cell_value(i,0)
    end
  end
  
end

class TableCellValueTest_WhenLastCol < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
  end
  
  must 'return value matching each cell in last col of input' do
    (0..@input.size - 1).each do |i|
      assert_equal @input[i][4], @subject.cell_value(i,4)
    end
  end
  
end

class TableCellValueTest_WhenMiddleCol < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
  end
  
  must 'return value matching each cell in 2nd col of input' do
    (0..@input.size - 1).each do |i|
      assert_equal @input[i][1], @subject.cell_value(i,1)
    end
  end
  
end

class TableCellValueTest_WhenFirstColNamed < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input, :headers => ['first', 'second', 'third', 'fourth', 'fifth'])
  end
  
  must 'return value matching each cell in first col of input' do
    (0..@input.size - 1).each do |i|
      assert_equal @input[i][0], @subject.cell_value(i,'first')
    end
  end
  
end

class TableCellValueTest_WhenLastColNamed < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input, :headers => ['first', 'second', 'third', 'fourth', 'fifth'])
  end
  
  must 'return value matching each cell in last col of input' do
    (0..@input.size - 1).each do |i|
      assert_equal @input[i][4], @subject.cell_value(i,'fifth')
    end
  end
  
end

class TableCellValueTest_WhenMiddleColNamed < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input, :headers => ['first', 'second', 'third', 'fourth', 'fifth'])
  end
  
  must 'return value matching each cell in 3rd col of input' do
    (0..@input.size - 1).each do |i|
      assert_equal @input[i][2], @subject.cell_value(i,'third')
    end
  end
  
end

class TableCellValueTest_WhenRowPastEOF < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
  end
  
  must 'return value is nil' do
    assert_equal nil, @subject.cell_value(3,1)
  end
  
end

class TableCellValueTest_WhenColPastEOF < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
  end
  
  must 'raise error' do
    assert_raise(ArgumentError) { @subject.cell_value(2,5) }
  end
  
end

class TableCellValueTest_WhenColUnknown < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15]]
    @subject = RMU::Data::Table.new(@input)
  end
  
  must 'raise error' do
    assert_raise(ArgumentError) { @subject.cell_value(2,'booga') }
  end
  
end
