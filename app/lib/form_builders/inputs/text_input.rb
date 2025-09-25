module FormBuilders
  module Inputs
    class TextInput < BaseInput
      def initialize(form_builder, method, options = {}, field_type = :text_field)
        super(form_builder, method, options)
        @field_type = field_type
      end

      def render
        @options[:class] = input_classes
        @options[:autocomplete] ||= "off"
        @options[:required] = required?

        @template.send(@field_type, @form_builder.object_name, @method, @options.merge(object: @form_builder.object))
      end
    end
  end
end
