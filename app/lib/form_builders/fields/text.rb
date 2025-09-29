module FormBuilders
  module Fields
    class Text < Base
      def initialize(form_builder, method, options = {}, field_type = :text_field)
        super(form_builder, method, options)
        @field_type = field_type
      end

      def render
        @options[:class] = field_classes
        @options[:autocomplete] ||= "off"
        @options[:required] = required?

        ActionView::Helpers::FormBuilder.instance_method(@field_type).bind(@form_builder).call(@method, @options)
      end
    end
  end
end
