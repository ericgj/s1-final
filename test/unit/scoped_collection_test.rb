require 'test/helper'
require 'lib/scoped_collection'

module ScopedCollectionTest
  class DummyTable

    attr_reader :data
    
    def rows
      @rows ||= ScopedCollection.new(self, :row, (0..(row_count-1)))
    end

    def rows=(ary)
      @data = ary
    end
    
    def row_count
      data.size
    end
    
    def row(enum)
      @data[enum]
    end
    
  end
end

class ScopedCollectionTest_WhenNoArgNorBlock < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]
    @table = ScopedCollectionTest::DummyTable.new
    @table.rows = @input
    @table.rows.where
    @subject = @table.rows.map
  end
  
  must "select all rows" do
    assert_equal @input, @subject
  end
  
end

class ScopedCollectionTest_WhenRangeNoBlock < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]
    @table = ScopedCollectionTest::DummyTable.new
    @table.rows = @input
    @table.rows.where(1..2)
    @subject = @table.rows.map
  end
  
  must "select all rows indexed within range" do
    assert_equal @input[1..2], @subject
  end
  
end

class ScopedCollectionTest_WhenNumberNoBlock < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]
    @table = ScopedCollectionTest::DummyTable.new
    @table.rows = @input
    @table.rows.where(3)
    @subject = @table.rows.map
  end
  
  must "select single row indexed by number" do
    assert_equal @input[3], @subject
  end
  
end

class ScopedCollectionTest_WhenTrueNoBlock < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]
    @table = ScopedCollectionTest::DummyTable.new
    @table.rows = @input
    @table.rows.where(true)
    @subject = @table.rows.map
  end
  
  must "select all rows that match condition" do
    assert_equal @input, @subject
  end
  
end


class ScopedCollectionTest_WhenTrueAfterWhereCalled < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]
    @table = ScopedCollectionTest::DummyTable.new
    @table.rows = @input
    @table.rows.where(2..3) {|row| row.include?(5) || row.include?(15)}
    @table.rows.where(true)
    @subject = @table.rows.map
  end
  
  must "select all rows that match condition" do
    assert_equal @input, @subject
  end
  
end

class ScopedCollectionTest_WhenNoArg < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]
    @table = ScopedCollectionTest::DummyTable.new
    @table.rows = @input
    @table.rows.where {|row| row.include?(5) || row.include?(15)}
    @subject = @table.rows.map
  end
  
  must "select all rows that match condition" do
    assert_equal [@input[1], @input[3]], @subject
  end
  
end

class ScopedCollectionTest_WhenArgAndBlock < Test::Unit::TestCase

  def setup
    @input = [[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]
    @table = ScopedCollectionTest::DummyTable.new
    @table.rows = @input
    @table.rows.where(0..1) {|row| row.include?(5) || row.include?(15)}
    @subject = @table.rows.map
  end
  
  must "select all rows in range that match condition" do
    assert_equal [@input[1]], @subject
  end
  
end
