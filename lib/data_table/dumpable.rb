module Dumpable

  def dump_to(file, output_type, opts = {})
  end
  alias_method :dump, :dump_to
  
  def dump_to_files_of_format(output_type, &blk)
  end
  
end

