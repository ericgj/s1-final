## First thoughts

The naive approach is either to (1) store the data in rows and columns as arrays or (2) store the data in rows, and have the columns be sliced out from the rows, or vice-versa.  

However the basic problem with both of these is in _data concurrency_.  A quick check verified that Ruby does not retain references across arrays -- when an object is pushed from one array to another array, the destination array gets a copy of the object, not the object itself.

    input = [[1,2,3,4],[11,12,13,14]]
    rows = *input
    cols = []; input[0].each_index {|i| cols << input.map {|r| r[i]}}
    puts cols    
    #  [[1, 11], [2, 12], [3, 13], [4, 14]]

    puts cols[0][0] == rows[0][0]
    #  true

    cols[0][0] = 'foo'
    puts cols[0][0] == rows[0][0]
    #  false

    puts cols
    #  [["foo", 11], [2, 12], [3, 13], [4, 14]]
    puts rows
    #  [[1, 2, 3, 4], [11, 12, 13, 14]]


Since we are dealing with updating/inserting/deleting columns and rows and not just reading them, the naive approaches would require a lot of messy double changes - not to mention larger memory requirements than seems necessary.

So my initial thought is to have all write operations basically handled at the table level.  The data would be stored basically as one big flattened array.  Row and Column objects would basically delegate their operations to the table.

