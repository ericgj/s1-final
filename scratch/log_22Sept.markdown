## Critical tests to do

- Table.new :headers => true
- Table.header, Table.header_index
- Loadable.load and load_lines unit tests
- Dumpable.dump unit tests

- Table.load_files_of_format, .load functional tests
- Table.dump_to_files_of_format, .dump functional tests
- Table.rows.where , .cols.where functional tests
- Table.select functional tests

## Less critical tests

- Update cell
- Table#row(n), #col(n)


## New features

- dumping
- headers is not directly accessible; error if attempt to resize