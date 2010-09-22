## Final exam for RMU session 1
### Eric Gjertsen's submission

(See REQUIREMENTS for description of the problem.)

#### 21 Sept

The following requirements are implemented:

- table initialization
- row append
- row insert
- row delete
- row get (not formally tested)
- col append
- col delete
- col insert
- col get (not formally tested)
- cell contents get and set (not formally tested)
- row map (not formally tested)
- col map (not formally tested)

These requirements are sketched but not yet implemented:

- column headers
- table reduce by row
- table reduce by col

And the testing scenario is not yet written.


My general priorities right now are to 

1. Focus on the requirements left for the testing scenario.
2. Concentrate on having a good test suite, which will make it easier to do the various refactorings needed.  

The Table class in my implementation is necessarily dense as that's where all the real state is controlled from, but it could still be refactored a bit, particularly regarding the headers and row/col collections.  But my plan is to focus on the requirements first and the refactoring second.


