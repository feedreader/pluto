module Pluto

module ActiveRecordMethods

  def read_attribute_w_fallbacks( *keys )
    ### todo: use a different name e.g.:
    ##   read_attribute_cascade ??  - does anything like this exists already?
    ## why? why not?
    keys.each do |key|
      value = read_attribute( key )
      return value unless value.nil?
    end
    value # fallthrough? return latest value (will be nil)
  end


end # module ActiveRecordMethods
end # module Pluto
