module FormBuilders
  module Inputs
    class Submit < BaseInput
      def initialize(form_builder, value = nil, options = {})
        @form_builder = form_builder
        @value = value
        @options = options
        @template = form_builder.instance_variable_get(:@template)
      end

      def render
        classes = [ "btn", "btn-primary" ]
        classes << @options.delete(:class) if @options[:class]

        @template.submit_tag(@value, @options.merge(class: classes.compact.join(" ")))
      end
    end
  end
end
