module FormBuilders
  module Fields
    class TextField < BaseField
      def initialize(form_builder, method, options = {}, field_type = :text_field)
        super(form_builder, method, options)
        @field_type = field_type
      end

      def render
        @options[:class] = field_classes
        @options[:autocomplete] ||= "off"
        @options[:required] = required?

        @template.send(@field_type, @form_builder.object_name, @method, @options)
      end
    end
  end
end
