
## Usage:
##
# class Table
#   extend Loadable
#
#   parse_lines_from :csv, opts do |table, input_row|
#    table.append_row(input_row)
#    table
#   end
#   
#   parse_from :yaml, opts do |input|
#    yaml = YAML.load(input)
#    raise SomeInputError unless yaml.is_a?(Array)
#    new(yaml, opts)
#   end
#   
# end
#
# table = Table.load(myfile, :yaml)
# table2 = Table.load_lines(myfile, :csv)

module Loadable

  def load(file, input_type, opts = {})
    delim = opts[:delim] || $/
    if IO === file
      @_parser[input_type].call(io, opts) if @_parser[input_type]
    else
      File.open(file, 'r') do |io| 
        @_parser[input_type].call(io, opts) if @_parser[input_type]
      end
    end
  end
  
  def load_lines(file, input_type, opts = {})
    delim = opts[:delim] || $/
    instance = new
    parser = lambda {|io|
                io.each_line(delim) do |line|
                  @_parser[input_type].call(instance, line, opts) if @_parser[input_type]
                end
             }
    if IO === file
      parser.call(file)
    else
      File.open(file, 'r') {|io| parser.call(io)}
    end
  end

  def parse_from(input_type, &blk)
    @_parser ||= {}
    @_parser[input_type] = blk
  end

  def parse_lines_from(input_type, &blk)
    parse_from(input_type, &blk)
  end
  
end
