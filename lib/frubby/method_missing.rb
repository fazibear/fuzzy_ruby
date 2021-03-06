module Frubby
  module MethodMissing
    
    EXCLUDED_METHODS = %i[
      to_ary
      to_io
      to_hash
      to_str
    ]
   
    KERNEL_METHODS = Kernel.methods.delete_if {|m| m.match /^[A-Z]/}

    def method_missing(method_sym, *args, &block)
      return super if EXCLUDED_METHODS.include? method_sym

      _methods = KERNEL_METHODS + methods
      _method = FuzzyMatch.new(_methods).find(method_sym.to_s)

      warn "[frubby] method_missing: #{method_sym} -> #{_method}" if $DEBUG

      _method.is_a?(Symbol) ? send(_method.to_sym, *args, &block) : super
    end
  end
end
