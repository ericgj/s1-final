module Dumpable

  def dump_to(file, output_type, opts = {})
    delim = opts[:delim] || $/
    if IO === file
      self.class.dumper[output_type].call(self, io, opts) if self.class.dumper[output_type]
    else
      File.open(file, 'w') do |io| 
        self.class.dumper[output_type].call(self, io, opts) if self.class.dumper[output_type]
      end
    end
  end
  alias_method :dump, :dump_to
    
  module ClassMethods
  
    def dumper
      @_dumper ||= {}
    end
    
    def dump_to_files_of_format(output_type, &blk)
    #todo check airity
      dumper[output_type] = blk
    end
  
  end
  
  def self.included(mod)
    mod.extend(ClassMethods)
  end

end

