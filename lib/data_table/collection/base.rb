module RMU
module Data
module Collection
class Base < ::Array

  def all(&blk)
    if block_given?
      (@_scopes ||= []) << blk
    end
    self
  end
  
  %w{collect detect each each_index each_with_index find_all}.each do |meth|
    module_eval(<<-EEEEE
      alias_method :_orig_#{meth}, :#{meth}
      def #{meth}
        (@_scopes ||= []).each do |f|
          delete_if {|it| !f.call(it)}
        end
        #_orig_{meth} { |it| yield(it) }
      end
    EEEEE
    )
  end
  
end
end
end
end