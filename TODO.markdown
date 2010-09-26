## Critical tests to do

- Table.header, Table.header_index
- Table.update_header!

- Table.rows.where , .cols.where functional tests
- Table.select functional tests


## Less critical
- Table.row + after ! methods
- Loadable.load and load_lines unit tests
- Dumpable.dump unit tests
- Table.load_files_of_format, .load functional tests
- Table.dump_to_files_of_format, .dump functional tests


## Done

- Table.new :headers => true
- Table.cell_value
- Table.col, + after ! methods
- Table.update_cell_value!


## New features

- headers & data not directly accessible; error if attempt to resize
- performance testing of caching rows/cols/cells vs. not caching
- threadsafe bang methods
