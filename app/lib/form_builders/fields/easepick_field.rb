module FormBuilders
  module Fields
    class EasepickField < BaseField
      def initialize(form_builder, method, options = {}, field_type = :text_field)
        super(form_builder, method, options)
        @field_type = field_type
      end

      def render
        @value = @options.delete(:value) || @object&.send(@method)
        @options[:value] = @value.present? ? I18n.l(@value) : nil

        @options[:data] = {
          action: "#{@options.dig(:data, :action)} focus->easepick#show",
          controller: "easepick"
        }.merge(@options[:data] || {})

        @options[:class] = field_classes
        @options[:autocomplete] ||= "off"
        @options[:required] = required?

        ActionView::Helpers::FormBuilder.instance_method(@field_type).bind(@form_builder).call(@method, @options)
      end
    end
  end
end
