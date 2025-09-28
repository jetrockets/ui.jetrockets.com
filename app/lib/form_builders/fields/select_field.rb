module FormBuilders
  module Fields
    class SelectField < BaseField
      def initialize(form_builder, method, choices = nil, select_options = {}, options = {})
        super(form_builder, method, options)
        @choices = choices
        @select_options = select_options
      end

      def render
        @options[:class] = field_classes(@options[:class])
        @options[:required] = required?

        ActionView::Helpers::FormBuilder.instance_method(:select).bind(@form_builder).call(@method, @choices, @select_options, @options)
      end
    end
  end
end
