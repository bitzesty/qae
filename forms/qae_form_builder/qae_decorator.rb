class QaeFormBuilder
  class QaeDecorator
    attr_reader :delegate_obj

    def initialize(obj, decorator_options = {})
      @delegate_obj = obj
      @decorator_options = decorator_options
    end

    def method_missing(meth, *, &)
      result = @delegate_obj.send(meth, *, &)
      wrap result, @decorator_options
    end

    private

    def wrap(o, options)
      if o.respond_to? :decorate
        o.decorate options
      elsif o.is_a?(Array)
        r = []
        o.each_with_index do |e, idx|
          r << (wrap e, options.merge(collection_idx: idx))
        end
        r
      else
        o
      end
    end
  end
end
