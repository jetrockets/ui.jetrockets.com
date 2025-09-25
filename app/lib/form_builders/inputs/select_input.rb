module FormBuilders
  module Inputs
    class SelectInput < BaseInput
      def initialize(form_builder, method, choices = nil, options = {}, html_options = {})
        super(form_builder, method, options)
        @choices = choices
        @html_options = html_options
      end

      def render
        @html_options[:class] = input_classes(@html_options[:class])
        @options[:required] = required?

        @template.select(@form_builder.object_name, @method, @choices, @options.merge(object: @form_builder.object), @html_options)
      end
    end
  end
end
