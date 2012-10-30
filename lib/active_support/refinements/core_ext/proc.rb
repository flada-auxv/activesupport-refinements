module ProcExt
require "active_support/core_ext/kernel/singleton_class"
require "active_support/deprecation"

refine Proc do
  def bind(object)
    ActiveSupport::Deprecation.warn 'Proc#bind is deprecated and will be removed in future versions', caller

    block, time = self, Time.now
    object.class_eval do
      method_name = "__bind_#{time.to_i}_#{time.usec}"
      define_method(method_name, &block)
      method = instance_method(method_name)
      remove_method(method_name)
      method
    end.bind(object)
  end
end
end
