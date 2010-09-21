
## Usage:
##
# class Table
#   extend Loadable
#
#   parse_lines_from :csv do |table, input_row|
#    table.append_row(input_row)
#    table
#   end
#   
#   parse_from :yaml do |input|
#    yaml = YAML.load(input)
#    raise SomeInputError unless yaml.is_a?(Array)
#    new(yaml)
#   end
#   
# end
#
# table = Table.load(myfile, :yaml)
# table2 = Table.load_lines(myfile, :csv)

module Loadable

  def self.load(file, input_type, opts = {})
    delim = opts[:delim] || $/
    if IO === file
      @_parser[input_type].call(io) if @_parser[input_type]
    else
      File.open(file, 'r') do |io| 
        @_parser[input_type].call(io) if @_parser[input_type]
      end
    end
  end
  
  def self.load_lines(file, input_type, opts = {})
    delim = opts[:delim] || $/
    instance = new
    parser = lambda {|io|
                io.each_line(delim) do |line|
                  @_parser[input_type].call(instance, line) if @_parser[input_type]
                end
             }
    if IO === file
      parser.call(file)
    else
      File.open(file, 'r') {|io| parser.call(io)}
    end
  end

  def self.parse_from(input_type, &blk)
    @_parser ||= {}
    @_parser[input_type] = blk
  end
  alias_method :parse_lines_from, :parse_from
  
end
