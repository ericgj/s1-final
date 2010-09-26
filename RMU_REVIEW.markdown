## Description

I implemented the data table fundamentally as a single array for the contents and a single array for the headers. All operations on the data are controlled via the `RMU::Data::Table` class.  

On top of this, there are 

- Helper classes that allow more intuitive access to a `Row` and `Column` as Enumerables, and to a `Cell` for getting and setting its value. 
- A `ScopedCollection` class that implements a kind of basic lazy-loading of collections of Rows and Columns, which the Table class uses to define a SQL-ish `#select` method.  (Note that this `#select` is not destructive, it creates a new Table object.)  ScopedCollection is entirely uncoupled from Table.
- Generic modules for loading and dumping data from files (`Loadable` and `Dumpable`).  These also are entirely uncoupled from Table.  I used them for loading and dumping the YAML files to/from the Table, other routines could be defined similarly for e.g. CSV files.

My decision to implement the data table as one flattened array (rather than the naive approach to store rows or cols as nested arrays) was motivated by a basic problem of _data concurrency_: Ruby does not retain references across arrays.  So updating/inserting/deleting columns and rows, under the naive approach, would seem to require a lot of messy double changes.  Also it would have higher memory requirements (`1 + n + n * m`  vs  `1 + n * m`).  But I'm not so sure now how much difference this design decision made in the end, see below.


## Running the tests and scenario

To run the tests, `rake`.

To run the scenario against the sample data, `rake scenario:run`.
Note the output file is `scenario/s1-exam-data-transformed.yaml`.


## Missing features

Two basic 'missing' features I can see are actually features I need to take out: I should not allow direct access to the data and headers arrays, it's asking for data corruption.

Also there are a number of features that need formalized testing, see TODO file.

At various places (in `Table#row`, `Table#col`, and `ScopedCollection#each`) I memoize collections of objects.  But I am guessing now this is not really a performance improvement for most use-cases, in fact it could be detrimental to load up a ton of objects. For instance, in `table.select { }`, a Row object gets loaded for every row in the table; then when you cash that out in `table.rows.map(&:values)` you load a Cell object for every cell in every selected Row.  So I'd really like to do some performance testing.

Another place for improvement would be to make the bang methods thread-safe.


## Project evaluation

I'm pretty happy with my implementation overall.  It seems to run very fast.  I learned a lot. Especially glad to have the experience writing Enumerable classes and trying my hand at lazy-loading collections.

Regarding the decision to store the data as one flattened array, this may not have been that important in the end.  I still had to face concurrency issues updating headers and data together, and updating noncontiguous array elements (in `insert_col!` and `delete_col!`). 

Both `insert_col!` and `delete_col!` are pretty expensive routines right now, requiring basically making a copy of the entire data table.  If Ruby had an `Array#insert` and `#fill` and `#delete_at` that modified noncontiguous array elements concurrently, I could get around this, but I didn't see a way otherwise to do it except to rebuild the table.

I did the tests in Test::Unit just to have the experience using it.  Probably could have been done in a DRY-er way but I didn't have the patience to learn it.  Actually it's kind of blessing in disguise that it's so clunky, it means you don't spend so much time perfecting your tests which is definitely one of my bad tendencies!  

But there has to be some middle ground.  I am really looking forward to switching to MiniTest, esp. since I hear it comes with a BDD DSL and mocking library built in!